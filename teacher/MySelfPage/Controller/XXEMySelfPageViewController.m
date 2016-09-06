//
//  XXEMySelfPageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMySelfPageViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"
#import "XXEMySelfInfoApi.h"
#import "XXEMyselfInfoViewController.h"

@interface XXEMySelfPageViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *pictureArray;
    //标题
    NSMutableArray *titleArray;
    //个人 头像
    NSString *headImageStr;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
    //头部 视图
    UIView *headerView;
    UIImageView *headerBgImageView;
    UIImageView *iconImageView;
    //添加性别
    UIImageView *manimage;
    
    //下个等级 星币
    NSString *next_grade_coinStr;
    //现有 星币
    NSString *coin_totalStr;
    //等级
    NSString *lvStr;
    //性别
    UIImage *sexPic;
    
    //用户名
    UILabel *nameLbl;
    NSString *nameStr;

}


@end

@implementation XXEMySelfPageViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = XXEBackgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pictureArray = [[NSMutableArray alloc] initWithObjects:@"myself_info_icon40x40", @"myself_order_icon40x48", @"myself_friend_icon40x44", @"myself_chat_icon40x40", @"myself_collection_icon40x40", @"myself_friend_circle_icon40x40", @"myself_blackorder_icon40x40", @"myself_system_setting_icon40x40", @"myself_privacy_setting_icon40x40", nil];
    titleArray = [[NSMutableArray alloc] initWithObjects:@"我的资料",@"我的订单",@"我的好友",@"我的聊天",@"我的收藏" , @"我的圈子", @"我的黑名单", @"系统设置", @"隐私设置", nil];
    
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
    
    XXEMySelfInfoApi *mySelfInfoApi = [[XXEMySelfInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE];
    
    [mySelfInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//            NSLog(@"111   %@", request.responseJSONObject);

        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            //头像
            NSString * head_img;
            if([[NSString stringWithFormat:@"%@",dict[@"head_img_type"]]isEqualToString:@"0"]){
                head_img=[kXXEPicURL stringByAppendingString:dict[@"head_img"]];
            }else{
                head_img=dict[@"head_img"];
            }
            
            headImageStr = head_img;
            
            //tname
            nameStr = dict[@"tname"];
            //下等级 星币数
            next_grade_coinStr = dict[@"next_grade_coin"];
            
            //现有 星币数
            coin_totalStr = dict[@"coin_total"];
            
            //现在 等级
            lvStr = dict[@"lv"];
            
            //性别
            if ([dict[@"sex"] isEqualToString:@"男"]) {
                sexPic = [UIImage imageNamed:@"home_men_sex"];
            }else if ([dict[@"sex"] isEqualToString:@"女"]){
                sexPic = [UIImage imageNamed:@"home_women_sex"];
            }

        }else{
            
        }
        [self createHeadView];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


- (void)createHeadView{

    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150 * kScreenRatioHeight)];
    [self.view addSubview:headerView];
    
    headerBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150 * kScreenRatioHeight)];
    headerBgImageView.image = [UIImage imageNamed:@"green_background_banner"];
    headerBgImageView.userInteractionEnabled =YES;
    [headerView addSubview:headerBgImageView];
    
    iconImageView = [[UIImageView alloc] init];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    CGFloat iconWidth = 86 *kScreenRatioWidth;
    CGFloat iconHeight = iconWidth;

    [iconImageView setFrame:CGRectMake(30 * kScreenRatioWidth, 30 * kScreenRatioHeight, iconWidth,iconHeight)];
    iconImageView.layer.cornerRadius =iconWidth / 2;
    iconImageView.layer.masksToBounds =YES;
    [headerView addSubview:iconImageView];
    iconImageView.userInteractionEnabled =YES;
    
    
    CGFloat sexWidth = 20 * kScreenRatioWidth;
    CGFloat sexHeight = sexWidth;
    
    manimage = [[UIImageView alloc]initWithFrame:CGRectMake(35 * kScreenRatioWidth, 60 * kScreenRatioHeight, sexWidth, sexHeight)];
    manimage.image = sexPic;
    [iconImageView addSubview:manimage];
    
    //名称
    CGFloat nameLabelWidth = 150 * kScreenRatioWidth;
    CGFloat nameLabelHeight = 20 *kScreenRatioHeight;
    
    nameLbl =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 40 * kScreenRatioHeight, nameLabelWidth, nameLabelHeight) Font:18 * kScreenRatioWidth Text:nil];
    nameLbl.text = nameStr;
    nameLbl.textAlignment = NSTextAlignmentLeft;
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:nameLbl];
    
    //等级
    NSString *lvString = [NSString stringWithFormat:@"LV%@", lvStr];
    
    CGFloat lvLabelWidth = 30 * kScreenRatioWidth;
    CGFloat lvLabelHeight = 15 * kScreenRatioHeight;
    
    UILabel *lvLabel = [UILabel createLabelWithFrame:CGRectMake(300 * kScreenRatioWidth , 42 * kScreenRatioHeight, lvLabelWidth, lvLabelHeight) Font:12 Text:lvString];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [headerView addSubview:lvLabel];
    
    //等级  星币 差距
    int a = [next_grade_coinStr intValue];
    int b = [coin_totalStr intValue];
    int c = a - b;
    int d = [lvStr intValue] + 1;
    
    
    //    NSLog(@"%d  ////   %d  //// %d //// %d", a, b,c,d);
    
    NSString *titleStr = [NSString stringWithFormat:@"还差%d星币升级到%d级会员  %d/%d", c, d, b, a];
    
    CGFloat titleLabelWidth = 200 * kScreenRatioWidth;
    CGFloat titleLabelHeight = 35 * kScreenRatioHeight;
    
    UILabel *titleLbl =[UILabel createLabelWithFrame:CGRectMake(150 * kScreenRatioWidth, 70 * kScreenRatioHeight, titleLabelWidth, titleLabelHeight) Font:12 * kScreenRatioWidth Text:titleStr];
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.text = titleStr;
    
    titleLbl.textColor = [UIColor whiteColor];
    
    [headerView addSubview:titleLbl];
    
    //中间 进度条
    UIProgressView * progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(150 * kScreenRatioWidth, 110 * kScreenRatioHeight, 150 * kScreenRatioWidth, 10 * kScreenRatioHeight);
    // 设置已过进度部分的颜色
    progressView.progressTintColor = XXEColorFromRGB(255, 255, 255);
    // 设置未过进度部分的颜色
    progressView.trackTintColor = XXEColorFromRGB(220, 220, 220);
    progressView.progress = [coin_totalStr floatValue] / [next_grade_coinStr floatValue] ;
    [headerView addSubview:progressView];

}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150 * kScreenRatioHeight, KScreenWidth, KScreenHeight - 150 * kScreenRatioHeight - 49 - 64) style:UITableViewStyleGrouped];
    
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
    return titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerDetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerDetialTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.iconImageView.image = [UIImage imageNamed:pictureArray[indexPath.row]];
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果 不是 校长 身份
    if (indexPath.row == 0) {
      //@"我的资料"
        XXEMyselfInfoViewController *myselfInfoVC = [[XXEMyselfInfoViewController alloc] init];
        [self.navigationController pushViewController:myselfInfoVC animated:YES];
    }else if (indexPath.row == 1){
      //@"我的订单"
        
    }else if (indexPath.row == 2){
      //@"我的好友"
        
        
    }else if (indexPath.row == 3){
       //@"我的聊天"
        
    }else if (indexPath.row == 4){
       //@"我的收藏"
        
    }else if (indexPath.row == 5){
       //@"我的圈子"
    
    }else if (indexPath.row == 6){
       //@"我的黑名单"
    }else if (indexPath.row == 7){
       //@"系统设置"
    
    }else if (indexPath.row == 8){
       //@"隐私设置"
    
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
//    return 150 * kScreenRatioHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
