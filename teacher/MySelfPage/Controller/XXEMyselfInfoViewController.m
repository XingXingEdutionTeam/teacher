


//
//  XXEMyselfInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"
#import "XXEMySelfInfoApi.h"
#import "XXEMyselfInfoNameModifyViewController.h"
#import "XXESchoolPhoneNumModifyViewController.h"


@interface XXEMyselfInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
//    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *pictureArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
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
    UILabel *lvLabel;
    //性别
    UIImage *sexPic;
    //距下等级 还差 多少 个 星币
    UILabel *titleLbl;
    //进度条
    UIProgressView * progressView;
    //用户名
    UILabel *nameLbl;
    NSString *nameStr;
    //已连续签到 多少天
    NSString *continued;
    UILabel *continuedLabel;
    //明天 签到 将 获得 多少 星币
    NSString *next_get_coin;
    UILabel *next_get_coinLabel;
    
}

@end

@implementation XXEMyselfInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = XXEBackgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pictureArray = [[NSMutableArray alloc] initWithObjects:@"myself_xid_icon40x40", @"myself_nickname_icon40x44", @"myself_name_icon40x40", @"myself_age_icon40x46", @"home_redflower_courseIcon", @"home_logo_phone_icon40x40", @"home_logo_email_icon40x40",@"myself_school_icon", @"myself_professional_icon", @"myself_experience_icon40x40", @"myself_feeling_icon40x40",@"myself_Individuality signature_icon40x40", @"home_redflower_picIcon", nil];
    titleArray = [[NSMutableArray alloc] initWithObjects:@"猩ID",@"昵称",@"姓名",@"教龄",@"科目" , @"手机号", @"邮箱", @"毕业院校", @"所学专业", @"教学经历",@"教学感悟", @"个性签名", @"相册", nil];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createHeadView];
    
    [self fetchNetData];
    
    [self createTableView];
}

- (void)fetchNetData{
    
    XXEMySelfInfoApi *mySelfInfoApi = [[XXEMySelfInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE];
    
    [mySelfInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//                    NSLog(@"111   %@", request.responseJSONObject);
        
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
            //已连续 签到
            continued = dict[@"continued"];
            //明天 签到 将 获得 多少 星币
            next_get_coin = dict[@"next_get_coin"];
            
            //content 内容
            contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"xid"], dict[@"nickname"], dict[@"tname"], dict[@"exper_year"], dict[@"teach_course"], dict[@"phone"],dict[@"email"], dict[@"graduate_sch"], dict[@"specialty"],  dict[@"teach_life"],dict[@"teach_feel"], dict[@"personal_sign"] ,@"", nil];
            
            
        }else{
            
        }
//        NSLog(@"%@", contentArray);
        
        [self updateHeadViewInfo];
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}

- (void)updateHeadViewInfo{
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    manimage.image = sexPic;
    
    if (nameStr == nil) {
        nameStr = @" ";
    }
    nameLbl.text = [NSString stringWithFormat:@"%@", nameStr];
    
    if (lvStr == nil) {
        lvStr = @" ";
    }
    lvLabel.text = [NSString stringWithFormat:@"LV%@", lvStr];
    
    //等级  星币 差距
    int a = [next_grade_coinStr intValue];
    int b = [coin_totalStr intValue];
    int c = a - b;
    int d = [lvStr intValue] + 1;
    
    //    NSLog(@"%d  ////   %d  //// %d //// %d", a, b,c,d);
    
    NSString *titleStr = [NSString stringWithFormat:@"还差%d星币升级到%d级会员  %d/%d", c, d, b, a];
     titleLbl.text = titleStr;
    progressView.progress = [coin_totalStr floatValue] / [next_grade_coinStr floatValue] ;
    
    if (continued == nil) {
        continued = @" ";
    }
    continuedLabel.text = [NSString stringWithFormat:@"已连续签到%@天",continued];
    
    if (next_get_coin == nil) {
        next_get_coin = @" ";
    }
    next_get_coinLabel.text = [NSString stringWithFormat:@"明天继续签到将获得%@个猩币",next_get_coin];
}


- (void)createHeadView{
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 180 * kScreenRatioHeight)];
//    headerBgImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:headerView];
    
    headerBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 180 * kScreenRatioHeight)];
    headerBgImageView.image = [UIImage imageNamed:@"green_background_banner"];
    headerBgImageView.userInteractionEnabled =YES;
    [headerView addSubview:headerBgImageView];
    
    iconImageView = [[UIImageView alloc] init];

    [iconImageView setFrame:CGRectMake(30, 30, 86,86)];
    iconImageView.layer.cornerRadius =43;
    iconImageView.layer.masksToBounds =YES;
    [headerView addSubview:iconImageView];
    iconImageView.userInteractionEnabled =YES;
    
    CGFloat iconBottom = iconImageView.frame.origin.y + iconImageView.frame.size.height;
    
    manimage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 60, 20, 20)];
    
    [iconImageView addSubview:manimage];
    
    //名称
    nameLbl =[UILabel createLabelWithFrame:CGRectMake(150, 40, 150, 20) Font:18 Text:nil];
    
    nameLbl.textAlignment = NSTextAlignmentLeft;
    nameLbl.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:nameLbl];
    
    //等级
    
    lvLabel = [UILabel createLabelWithFrame:CGRectMake(300 * kScreenRatioWidth, 42, 30, 15) Font:12 Text:@""];
    lvLabel.textColor = UIColorFromRGB(3, 169, 244);
    lvLabel.textAlignment = NSTextAlignmentCenter;
    lvLabel.backgroundColor = [UIColor whiteColor];
    lvLabel.layer.cornerRadius = 5;
    lvLabel.layer.masksToBounds = YES;
    [headerView addSubview:lvLabel];
    

    titleLbl =[UILabel createLabelWithFrame:CGRectMake(150, 70, 200, 35) Font:12 Text:@""];
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLbl];
    
    //中间 进度条
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(150, 110, 150, 10);
    // 设置已过进度部分的颜色
    progressView.progressTintColor = XXEColorFromRGB(255, 255, 255);
    // 设置未过进度部分的颜色
    progressView.trackTintColor = XXEColorFromRGB(220, 220, 220);
    [headerView addSubview:progressView];
    
    UIButton *checkBtn =[UIButton createButtonWithFrame:CGRectMake(40 * kScreenRatioWidth, iconBottom + 15 * kScreenRatioHeight, 57 * kScreenRatioWidth, 26 * kScreenRatioHeight) backGruondImageName:@"myself_signIn_icon106x48" Target:self Action:@selector(check) Title:@""];
    
    [headerView addSubview:checkBtn];
    
    continuedLabel =[UILabel createLabelWithFrame:CGRectMake(145 * kScreenRatioWidth, iconBottom + 10 * kScreenRatioHeight, 120 * kScreenRatioWidth, 15 * kScreenRatioHeight) Font:12 * kScreenRatioWidth Text:@""];
    continuedLabel.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:continuedLabel];
    
    next_get_coinLabel =[UILabel createLabelWithFrame:CGRectMake(145 * kScreenRatioWidth, continuedLabel.frame.origin.y + continuedLabel.frame.size.height + 5 *kScreenRatioHeight, 200 * kScreenRatioWidth, 15 * kScreenRatioHeight) Font:12 * kScreenRatioWidth Text:@""];
    next_get_coinLabel.textColor =UIColorFromRGB(255, 255, 255);
    [headerView addSubview:next_get_coinLabel];
}


- (void)check{
    NSLog(@"签到---------------");
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180 * kScreenRatioHeight, KScreenWidth, KScreenHeight - 180 * kScreenRatioHeight - 49) style:UITableViewStyleGrouped];
    
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
    cell.contentLabel.text = contentArray[indexPath.row];
//@"猩ID"--0,@"昵称"--1,@"姓名"--2,@"教龄"--3,@"科目"--4 , @"手机号"--5, @"邮箱"--6, @"毕业院校"--7, @"所学专业"--8, @"教学经历"--9,@"教学感悟"--10, @"个性签名"--11, @"相册"--12
    if (indexPath.row == 1 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 11) {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return  0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//@"猩ID"--0,@"昵称"--1,@"姓名"--2,@"教龄"--3,@"科目"--4 , @"手机号"--5, @"邮箱"--6, @"毕业院校"--7, @"所学专业"--8, @"教学经历"--9,@"教学感悟"--10, @"个性签名"--11, @"相册"--12
    
    //昵称 1
    if (indexPath.row == 1) {
        XXEMyselfInfoNameModifyViewController *myselfInfoNameModifyVC = [[XXEMyselfInfoNameModifyViewController alloc] init];
        myselfInfoNameModifyVC.nickNameStr = contentArray[1];
        
        [myselfInfoNameModifyVC returnStr:^(NSString *str) {
            //
            contentArray[1] = str;
            [_myTableView reloadData];
        }];
        [self.navigationController pushViewController:myselfInfoNameModifyVC animated:YES];
    }
    //手机号
    if (indexPath.row == 5) {
//        XXESchoolPhoneNumModifyViewController *schoolPhoneNumModifyVC = [[XXESchoolPhoneNumModifyViewController alloc] init];
//        schoolPhoneNumModifyVC.flagStr = @"fromMyselfInfo";
//        [self.navigationController pushViewController:schoolPhoneNumModifyVC animated:YES];
    }
    //邮箱
    
    //经历
    
    //感悟
    
    //毕业院校
    
    //所学专业
    
    //教学年龄
    
    
    //个性签名
    
    //修改头像
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
