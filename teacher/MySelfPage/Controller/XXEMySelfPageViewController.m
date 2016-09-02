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

    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    [self.view addSubview:headerView];
    
    headerBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    headerBgImageView.image = [UIImage imageNamed:@"green_background_banner"];
    headerBgImageView.userInteractionEnabled =YES;
    [headerView addSubview:headerBgImageView];
    
    iconImageView = [[UIImageView alloc] init];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    [iconImageView setFrame:CGRectMake(30, 30, 86,86)];
    iconImageView.layer.cornerRadius =43;
    iconImageView.layer.masksToBounds =YES;
    [headerView addSubview:iconImageView];
    iconImageView.userInteractionEnabled =YES;
    
    manimage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 60, 20, 20)];
    manimage.image = sexPic;
    [iconImageView addSubview:manimage];
    
    //名称
    nameLbl =[UILabel createLabelWithFrame:CGRectMake(150, 40, 150, 20) Font:18 Text:nil];
    nameLbl.text = nameStr;
    nameLbl.textAlignment = NSTextAlignmentLeft;
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:nameLbl];
    
    //等级
    NSString *lvString = [NSString stringWithFormat:@"LV%@", lvStr];
    UILabel *lvLabel = [UILabel createLabelWithFrame:CGRectMake(300, 42, 30, 15) Font:12 Text:lvString];
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
    UILabel *titleLbl =[UILabel createLabelWithFrame:CGRectMake(150, 70, 200, 35) Font:12 Text:titleStr];
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.text = titleStr;
    
    titleLbl.textColor = [UIColor whiteColor];
    
    [headerView addSubview:titleLbl];
    
    //中间 进度条
    UIProgressView * progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(150, 110, 150, 10);
    // 设置已过进度部分的颜色
    progressView.progressTintColor = XXEColorFromRGB(255, 255, 255);
    // 设置未过进度部分的颜色
    progressView.trackTintColor = XXEColorFromRGB(220, 220, 220);
    progressView.progress = [coin_totalStr floatValue] / [next_grade_coinStr floatValue] ;
    [headerView addSubview:progressView];

}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
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



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
//    return 150 * kScreenRatioHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
