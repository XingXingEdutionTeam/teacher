




//
//  XXERedFlowerDetialViewController.m
//  teacher
//
//  Created by Mac on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERedFlowerDetialViewController.h"
#import "XXERedFlowerDetialInfoTableViewCell.h"
#import "XXEImageBrowsingViewController.h"
#import "XXEGlobalDecollectApi.h"
#import "XXEGlobalCollectApi.h"


@interface XXERedFlowerDetialViewController ()<UITableViewDelegate, UITableViewDataSource>
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
    
    BOOL isCollect;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    UIButton*rightButton;
    
}

@end

@implementation XXERedFlowerDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //@"home_redflower_courseIcon",
    picArray =[[NSMutableArray alloc]initWithObjects:@"home_redflower_nameIcon", @"home_redflower_timeIcon", @"home_redflower_schoolIcon", @"home_redflower_classIcon", @"home_redflower_contentIcon",  @"home_redflower_picIcon",nil];
    titleArray =[[NSMutableArray alloc]initWithObjects:@"姓名:",@"赠送时间:",@"学校:", @"班级:", @"赠言:", @"照片墙:", nil];
    contentArray = [[NSMutableArray alloc] initWithObjects:_name, _time, _schoolName, _className, _content, @"", nil];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createTableView];
    [self setRightCollectionButton];
    
}

- (void)setRightCollectionButton{
    
    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton addTarget:self action:@selector(collectbtn:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    //[collect_condit] => 1			//1:是收藏过这个商品  2:未收藏过
    UIImage *saveImage;
    
    if ([_collect_conditStr integerValue] == 1) {
        isCollect = YES;
        saveImage = [UIImage imageNamed:@"home_logo_collection_icon44x44"];
        
    }else if([_collect_conditStr integerValue] == 2){
        isCollect = NO;
        saveImage = [UIImage imageNamed:@"home_logo_uncollection_icon44x44"];
    }
    [rightButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    
}

-(void)collectbtn:(UIButton *)btn{
    
    if (isCollect==NO) {
        [self collectRedFlower];
        
    }
    else  if (isCollect==YES) {
        
        [self deleteCollectcollectRedFlower];
    }
    
}

//收藏  小红花
- (void)collectRedFlower{
    /*
     【收藏】通用于各种收藏
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/collect
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
     */
    
    XXEGlobalCollectApi *globalCollectApi = [[XXEGlobalCollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:_collect_id collect_type:@"6"];
    
    
    [globalCollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//                NSLog(@"收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"收藏成功!" forSecond:1.5];
            [rightButton setBackgroundImage:[UIImage imageNamed:@"home_logo_collection_icon44x44"] forState:UIControlStateNormal];
            isCollect=!isCollect;
        }else if([codeStr isEqualToString:@"5"]){
            
            [self showHudWithString:@"" forSecond:1.5];
        }else{
        
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"收藏失败!" forSecond:1.5];
    }];
    
}

//取消收藏 小红花
- (void)deleteCollectcollectRedFlower{
    /*
     【删除/取消收藏】通用于各种取消收藏
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵 7:图片
     */
    XXEGlobalDecollectApi *globalDecollectApi = [[XXEGlobalDecollectApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:_collect_id collect_type:@"6"];
    [globalDecollectApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"取消收藏 -- %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"取消收藏成功!" forSecond:1.5];
            
            [rightButton setBackgroundImage:[UIImage imageNamed:@"home_logo_uncollection_icon44x44"] forState:UIControlStateNormal];
            isCollect=!isCollect;
        }else{
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"取消收藏失败!" forSecond:1.5];
    }];
    
}



- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
    
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
    
    return 6;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cell";
    XXERedFlowerDetialInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[XXERedFlowerDetialInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.iconImageView.image = [UIImage imageNamed:picArray[indexPath.row]];
    cell.titleLabel.text = titleArray[indexPath.row];
    
    cell.contentLabel.text = contentArray[indexPath.row];
    
    maxWidth = cell.contentLabel.width;
    CGFloat height = [StringHeight contentSizeOfString:contentArray[indexPath.row] maxWidth:maxWidth fontSize:14 * kScreenRatioWidth];
    
    CGSize size = cell.contentLabel.size;
    size.height = height;
    cell.contentLabel.size = size;
    
    if (indexPath.row == 5) {
        
        //result= num1>num2?num1:num2;
        
        if (_picWallArray.count % 3 == 0) {
            picRow = _picWallArray.count / 3;
        }else{
            
            picRow = _picWallArray.count / 3 + 1;
        }
        //创建 十二宫格  三行、四列
        int margin = 10;
        picWidth = (KScreenWidth - 20- 4 * margin) / 3;
        picHeight = picWidth;
        
        for (int i = 0; i < _picWallArray.count; i++) {
            
            //行
            int buttonRow = i / 3;
            
            //列
            int buttonLine = i % 3;
            
            CGFloat buttonX = 10 + (picWidth + margin) * buttonLine;
            CGFloat buttonY = 40 + (picHeight + margin) * buttonRow;
            
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
    //举报 来源 1:小红花赠言中的图片
    imageBrowsingVC.origin_pageStr = @"1";
    
    [self.navigationController pushViewController:imageBrowsingVC animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 4) {
    CGFloat height = [StringHeight contentSizeOfString:contentArray[indexPath.row] maxWidth:maxWidth fontSize:14 * kScreenRatioWidth];
        return height + 20;
    }else if (indexPath.row==5) {
        return 44 + picRow * (picHeight + 10);
    } else{
        return 44;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 130 * kScreenRatioHeight)];
    headerView.backgroundColor = XXEColorFromRGB(0, 170, 42);
    
    CGFloat iconWidth = 87 * kScreenRatioWidth;
    CGFloat iconHeight = iconWidth;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - iconWidth) / 2, (headerView.frame.size.height - iconHeight) / 2, iconWidth, iconHeight)];

//    icon.image = [UIImage imageNamed:@"headplaceholder"];
    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _iconUrl]] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    icon.layer.cornerRadius = icon.frame.size.width / 2;
    icon.layer.masksToBounds = YES;
    
    [headerView addSubview:icon];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 130 * kScreenRatioHeight;
}


@end
