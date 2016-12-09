

//
//  XXEHomeworkDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeworkDetailInfoViewController.h"
#import "XXERedFlowerDetialInfoTableViewCell.h"
#import "XXEHomeworkDetailInfoApi.h"
#import "XXEImageBrowsingViewController.h"

@interface XXEHomeworkDetailInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *picArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
    //照片墙 的图片 可以排列几行
    NSInteger picRow;
    //照片墙 照片 宽
    CGFloat picWidth;
    //照片墙 照片 高
    CGFloat picHeight;
    
    CGFloat maxWidth;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}


@end

@implementation XXEHomeworkDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    picArray =[[NSMutableArray alloc]initWithObjects:@"homework_teacher_icon", @"homework_subject_icon", @"homework_content_icon", @"homework_publishtime_icon", @"homework_submittime_icon",nil];
    titleArray =[[NSMutableArray alloc]initWithObjects:@"发布人:",@"作业主题:",@"作业内容:", @"发布时间:", @"交作业时间:", nil];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self fetchNetData];
    [self createTableView];
}

- (void)fetchNetData{
    /*
     【班级作业详情】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Parent/class_homework_detail
     传参:
     homework_id	//作业id */
    
    XXEHomeworkDetailInfoApi *homeworkApi = [[XXEHomeworkDetailInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE homework_id:_homeworkId];
    [homeworkApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//             NSLog(@"2222---   %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSDictionary *dic = request.responseJSONObject[@"data"];
            
            _picWallArray = [[NSMutableArray alloc] init];

            _name = dic[@"tname"];
            _subject = dic[@"title"];
            _content = dic[@"con"];
            _publishTime = [XXETool dateStringFromNumberTimer:dic[@"date_tm"]];
            _submitTime = [XXETool dateStringFromNumberTimer:dic[@"date_end_tm"]];
            _picWallArray = dic[@"pic_group"];
            
            contentArray = [[NSMutableArray alloc] initWithObjects:_name, _subject, _content, _publishTime, _submitTime, nil];
        }else{
            
        }
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return picArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[XXERedFlowerDetialInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.iconImageView.image = [UIImage imageNamed:picArray[indexPath.row]];
    cell.titleLabel.text = titleArray[indexPath.row];
    
    if (contentArray.count != 0) {
        cell.contentLabel.text = contentArray[indexPath.row];
        cell.contentLabel.numberOfLines = 0;
        maxWidth = cell.contentLabel.width;
        CGFloat height = [StringHeight contentSizeOfString:contentArray[indexPath.row] maxWidth:maxWidth fontSize:14];
        
        CGSize size = cell.contentLabel.size;
        size.height = height;
        cell.contentLabel.size = size;
    }

    if (indexPath.row == 3) {
        
        //result= num1>num2?num1:num2;
        
        if (_picWallArray.count % 3 == 0) {
            picRow = _picWallArray.count / 3;
        }else{
            
            picRow = _picWallArray.count / 3 + 1;
        }
        //创建 十二宫格  三行、四列
        int margin = 10;
        picWidth = (KScreenWidth - 20 - 4 * margin) / 3;
        picHeight = picWidth;
        
        for (int i = 0; i < _picWallArray.count; i++) {
            
            //行
            int buttonRow = i / 3;
            
            //列
            int buttonLine = i % 3;
            
            CGFloat buttonX = 10 + (picWidth + margin) * buttonLine;
            CGFloat buttonY = 44 + (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
            pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
            pictureImageView.clipsToBounds = YES;
            
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _picWallArray[i]]]];
            pictureImageView.tag = 20 + i;
            pictureImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:pictureImageView];
        }
        
    }
    
    return cell;
}

- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
//    NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    XXEImageBrowsingViewController * imageBrowsingVC = [[XXEImageBrowsingViewController alloc] init];
    
    imageBrowsingVC.imageUrlArray = _picWallArray;
    imageBrowsingVC.currentIndex = tap.view.tag - 20;
    //举报 来源 7:作业图片
    imageBrowsingVC.origin_pageStr = @"7";
    
    [self.navigationController pushViewController:imageBrowsingVC animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        CGFloat height = [StringHeight contentSizeOfString:contentArray[indexPath.row] maxWidth:maxWidth fontSize:14];
        return height + 20;
    }else if (indexPath.row==3) {
        return 44 + picRow * (picHeight + 10);
    }
    else{
        return 44;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00000001;
}



@end
