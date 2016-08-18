


//
//  XXECommentReplyViewController.m
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentReplyViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"



@interface XXECommentReplyViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *picArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
}



@end

@implementation XXECommentReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    picArray =[[NSMutableArray alloc]initWithObjects:@"homework_teacher_icon", @"homework_subject_icon", @"homework_content_icon", @"homework_publishtime_icon", @"homework_submittime_icon",nil];
    titleArray =[[NSMutableArray alloc]initWithObjects:@"学生:",@"请求:",@"请求时间:", @"评价:", nil];
    
    contentArray = [[NSMutableArray alloc] initWithObjects:_name, _content, _requestTime, @"", nil];
    
    [self createTableView];
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
    XXERedFlowerDetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerDetialTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.iconImageView.image = [UIImage imageNamed:picArray[indexPath.row]];
    cell.titleLabel.text = titleArray[indexPath.row];
    
    if (contentArray.count != 0) {
        cell.contentLabel.text = contentArray[indexPath.row];
    }
    
    if (indexPath.row == 3) {
        
        //result= num1>num2?num1:num2;
        
//        if (_picWallArray.count % 3 == 0) {
//            picRow = _picWallArray.count / 3;
//        }else{
//            
//            picRow = _picWallArray.count / 3 + 1;
//        }
//        //创建 十二宫格  三行、四列
//        int margin = 10;
//        picWidth = (KScreenWidth - 4 * margin) / 3;
//        picHeight = picWidth;
//        
//        for (int i = 0; i < _picWallArray.count; i++) {
//            
//            //行
//            int buttonRow = i / 3;
//            
//            //列
//            int buttonLine = i % 3;
//            
//            CGFloat buttonX = (picWidth + margin) * buttonLine;
//            CGFloat buttonY = 40 + (picHeight + margin) * buttonRow;
//            
//            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
//            
//            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _picWallArray[i]]]];
//            pictureImageView.tag = 20 + i;
//            pictureImageView.userInteractionEnabled = YES;
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
//            [pictureImageView addGestureRecognizer:tap];
//            
//            [cell.contentView addSubview:pictureImageView];
//        }
        
    }
    
    return cell;
}

- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    
    //    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
    //    NSMutableArray *imageArr = picMArr;
    //    redFlowerVC.index = tap.view.tag - 20;
    //    redFlowerVC.imageArr = imageArr;
    //    //举报 来源 7:作业图片
    //    redFlowerVC.origin_pageStr = @"7";
    //    redFlowerVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:redFlowerVC animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row==3) {
//        return 44 + picRow * picHeight;
//    }
//    else{
//        return 44;
//    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00000001;
}

@end
