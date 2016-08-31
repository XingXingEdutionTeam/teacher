

//
//  XXECommentHistoryDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentHistoryDetailInfoViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"



@interface XXECommentHistoryDetailInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
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
}

@end

@implementation XXECommentHistoryDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *timeStr = [XXETool dateStringFromNumberTimer:_ask_time];
//[com_pic] => app_upload/class_album/2016/07/29/20160729105538_3449.jpg	//点评图片,多个逗号隔开

    //[type] => 1			//点评类型  1:老师主动点评,2:家长请求点评
    if ([_type isEqualToString:@"1"]) {
        picArray =[[NSMutableArray alloc]initWithObjects:@"comment_people_icon", @"comment_content_icon", @"home_redflower_picIcon",nil];
        titleArray =[[NSMutableArray alloc]initWithObjects:@"学生:", @"评价内容:", @"图片:", nil];
        contentArray = [[NSMutableArray alloc] initWithObjects:_name,  _com_con, @"", nil];
    }else if ([_type isEqualToString:@"2"]){
    picArray =[[NSMutableArray alloc]initWithObjects:@"comment_people_icon", @"comment_ask_content_icon", @"comment_time_icon", @"comment_content_icon", @"home_redflower_picIcon",nil];
    titleArray =[[NSMutableArray alloc]initWithObjects:@"学生:",@"请求:",@"时间:", @"评价内容:", @"图片:", nil];
        contentArray = [[NSMutableArray alloc] initWithObjects:_name, _ask_con, timeStr, _com_con, @"", nil];
    }
//        NSLog(@"%@", _picString);
    if (![_picString isEqualToString:@""]) {
        _picWallArray = [[NSMutableArray alloc] initWithObjects:_picString, nil];
    }
    
    if ([_picString containsString:@","]) {
        _picWallArray = [_picString componentsSeparatedByString:@","];
    }

//    NSLog(@"图片 数组  ---  %@", _picWallArray);
    
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
    
    NSInteger t;
    //[type] => 1			//点评类型  1:老师主动点评,2:家长请求点评
    if ([_type isEqualToString:@"1"]) {
        t = 2;
    }else if ([_type isEqualToString:@"2"]){
        t = 4;
    }
    
    
    if (indexPath.row == t) {
        
        //result= num1>num2?num1:num2;
        
//        NSLog(@"%@", _picWallArray);
        
        if (_picWallArray.count % 3 == 0) {
            picRow = _picWallArray.count / 3;
        }else{
            
            picRow = _picWallArray.count / 3 + 1;
        }
        //创建 十二宫格  三行、四列
        int margin = 10;
        picWidth = (KScreenWidth - 4 * margin - 5 * 2) / 3;
        picHeight = picWidth;
        
        for (int i = 0; i < _picWallArray.count; i++) {
            
            //行
            int buttonRow = i / 3;
            
            //列
            int buttonLine = i % 3;
            
            CGFloat buttonX = (picWidth + margin) * buttonLine;
            CGFloat buttonY = 40 + (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX + 5, buttonY, picWidth, picHeight)];
            
            NSString *str = [NSString stringWithFormat:@"%@%@", kXXEPicURL, _picWallArray[i]];
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:str]];
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
    NSInteger t;
    //[type] => 1			//点评类型  1:老师主动点评,2:家长请求点评
    if ([_type isEqualToString:@"1"]) {
        t = 2;
    }else if ([_type isEqualToString:@"2"]){
        t = 4;
    }
    if (indexPath.row==t) {

        return 44 + picRow * picHeight;
    }
    else{
        return 44;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    UIButton *deleteButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - 325 * kScreenRatioWidth) / 2, 30 * kScreenRatioHeight, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:@"login_green" Target:self Action:@selector(deleteBurronClick) Title:@"删除评论"];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:deleteButton];
    return footerView;
}

- (void)deleteBurronClick{
    
    NSLog(@"0000");
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 100;

}

@end
