//
//  XXEXingCoinViewController.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCoinViewController.h"
#import "XXEXingCoinApi.h"
#import "XXEXingCoinHistoryViewController.h"

#define URL @"http://www.xingxingedu.cn/Global/check_in"


@interface XXEXingCoinViewController ()
{
    //签到 天数
    UILabel *signDayLabel;
    //猩币 数量
    UILabel *xingCoinLabel;
    //明天 签到 将 获取 猩币 数
    UILabel *tomorrowXingCoinLabel;
    
    //连续签到次数
    NSString *continued;
    //本次签到获得猩币数量
    NSString *sign_coin;
    //明天签到将获得多少猩币
    NSString *next_sign_coin;
    //中间 进度条
    UIProgressView * progressView;
    
    //历史猩币数
    NSString *coin_total;
    //升下一级所需猩币数
    NSString *next_grade_coin;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}



@end

@implementation XXEXingCoinViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self fetchNetData];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"猩币签到";
    //创建 右边 历史 按钮
    UIButton *historyBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_flowerbasket_historyIcon44x44" Target:self Action:@selector(historyBtn) Title:@""];
    UIBarButtonItem *historyItem =[[UIBarButtonItem alloc]initWithCustomView:historyBtn];
    self.navigationItem.rightBarButtonItem =historyItem;
    //创建 内容
    [self createCheckInView];
    
}

#pragma mark ========  猩币 历史 =========
- (void)historyBtn{
    if ([XXEUserInfo user].login) {
        XXEXingCoinHistoryViewController *xingCoinHistoryVC = [[XXEXingCoinHistoryViewController alloc] init];
        
        [self.navigationController pushViewController:xingCoinHistoryVC animated:YES];
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
    }
    
}

- (void)fetchNetData{

    XXEXingCoinApi *xingCoinApi = [[XXEXingCoinApi alloc] initWithUrlString:URL xid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE];
    [xingCoinApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        /*
         {
         code = 1;
         data =     {
         "coin_total" = 100;  //历史猩币数
         continued = 1;       //连续签到次数
         "next_grade_coin" = 500;//升下一级所需猩币数
         "next_sign_coin" = 10;//明天签到将获得多少猩币
         "sign_coin" = 5;      //本次签到获得猩币数量
         };
         msg = "\U7b7e\U5230\U6210\U529f!";
         }
         */
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        NSDictionary *dict = request.responseJSONObject[@"data"];
        if ([codeStr isEqualToString:@"1"]) {
            continued = dict[@"continued"];
            sign_coin = dict[@"sign_coin"];
            next_sign_coin = dict[@"next_sign_coin"];
            coin_total = dict[@"coin_total"];
            next_grade_coin = dict[@"next_grade_coin"];
            
            [self showHudWithString:@"签到成功!" forSecond:1];
            
        }else if([codeStr isEqualToString:@"3"]){
            continued = dict[@"continued"];
            sign_coin = dict[@"sign_coin"];
            next_sign_coin = dict[@"next_sign_coin"];
            coin_total = dict[@"coin_total"];
            next_grade_coin = dict[@"next_grade_coin"];
            
            [self showHudWithString:@"今天已签到!" forSecond:1];
        }
        
        [self updateCheckInfo];
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"请求失败" forSecond:1.f];
    }];

}



-(void)createCheckInView {
    //上面 签到 背景
    UIImage *upBgImage = [UIImage imageNamed:@"home_xing_sign"];
    UIImageView *upBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - upBgImage.size.width) / 2, 30, upBgImage.size.width, upBgImage.size.height)];
    upBgImageView.image = upBgImage;
    [self.view addSubview:upBgImageView];
    CGFloat upBgViewBottom = upBgImageView.frame.origin.y + upBgImageView.frame.size.height;
    //上面 左边 签到 第几天
    
    CGFloat signDayLabelWidth = upBgImageView.frame.size.height - 10 * 2 * kScreenRatioHeight;
    CGFloat signDayLabelHeight = signDayLabelWidth;
    signDayLabel =  [UILabel createLabelWithFrame:CGRectMake(20 * kScreenRatioWidth, 10 * kScreenRatioHeight, signDayLabelWidth, signDayLabelHeight) Font:16 Text:@""];
    signDayLabel.backgroundColor = XXEColorFromRGB(243, 183, 77);
    signDayLabel.layer.cornerRadius= signDayLabel.bounds.size.width/2;
    signDayLabel.layer.masksToBounds=YES;
    signDayLabel.textAlignment = NSTextAlignmentCenter;
    [upBgImageView addSubview:signDayLabel];
    
    //上面 右边 获得 多少个猩币
    xingCoinLabel = [UILabel createLabelWithFrame:CGRectMake(upBgImageView.frame.size.width / 2 + 20 *kScreenRatioWidth, 20 * kScreenRatioHeight, upBgImageView.frame.size.width / 2 - 20 *kScreenRatioWidth, 20) Font:12 Text:@""];
    [upBgImageView addSubview:xingCoinLabel];
    
    CGFloat xingCoinLabelBottom = xingCoinLabel.frame.origin.y + xingCoinLabel.frame.size.height;
    
    //上面 右边 明天签到将获得 多少猩币
    tomorrowXingCoinLabel = [UILabel createLabelWithFrame:CGRectMake(upBgImageView.frame.size.width / 2, xingCoinLabelBottom + 10, upBgImageView.frame.size.width / 2, 20) Font:12 Text:@""];
    [upBgImageView addSubview:tomorrowXingCoinLabel];
    
    
   progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(upBgImageView.frame.origin.x, upBgViewBottom + 20, upBgImageView.frame.size.width, 3);
    // 设置已过进度部分的颜色
    progressView.progressTintColor = XXEColorFromRGB(67, 181, 59);
    // 设置未过进度部分的颜色
    progressView.trackTintColor = XXEColorFromRGB(229, 229, 229);
    
    [self.view addSubview:progressView];
    CGFloat progressViewBottom = progressView.frame.origin.y + progressView.frame.size.height;
    
    
    //下面 活动规则
    UIImageView *downBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, progressViewBottom + 20 , KScreenWidth - 20 * 2, 20)];
    downBgImgView.backgroundColor = [UIColor clearColor];
    [downBgImgView setImage:[UIImage imageNamed:@"home_xing_rule"]];

    [self.view addSubview:downBgImgView];
    
    NSString *str = @"  1.每周第一次签到获得5猩币，之后每天签到多增加5猩币,直至20猩币,如有签到中断,将会重新从5猩币开始获取.\n  2.签到签满1周额外获得10猩币,连续签满2周额外获得20猩币,连续签满3周额外获得30猩币,连续签满4周额外获得40猩币.\n";
    CGFloat strHeight = [StringHeight contentSizeOfString:str maxWidth:KScreenWidth - 40 fontSize:16 * kScreenRatioWidth];
    
    UITextView *checkInText = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(downBgImgView.frame) + 20, KScreenWidth - 40, strHeight)];
    checkInText.text = str;
//    checkInText.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    checkInText.layer.backgroundColor = [[UIColor clearColor] CGColor];
    checkInText.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
    checkInText.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]CGColor];
    checkInText.layer.borderWidth = 1.0;
    checkInText.layer.cornerRadius = 8.0f;
    checkInText.userInteractionEnabled = NO;
    checkInText.editable = NO;
    [checkInText.layer setMasksToBounds:YES];
    //自动适应行高
//    static CGFloat maxHeight = 150.0f;
//    CGRect frame = checkInText.frame;
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    CGSize size = [checkInText sizeThatFits:constraintSize];
//    if (size.height >= maxHeight){
//        size.height = maxHeight;
//        checkInText.scrollEnabled = YES;   // 允许滚动
//    }
//    else{
//        checkInText.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
//    }
//    checkInText.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [self.view addSubview:checkInText];
    
    if ([GlobalVariable shareInstance].appleVerify == AppleVerifyHave) {
        UILabel *explainLbl = [[UILabel alloc] init];
        explainLbl.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
        explainLbl.textColor = UIColorFromHex(0x333333);
        explainLbl.textAlignment = NSTextAlignmentCenter;
        explainLbl.text = @"本活动与苹果公司无关";
        [self.view addSubview:explainLbl];
        [explainLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.top.mas_equalTo(checkInText.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
    }
    
    
}

- (void)updateCheckInfo{

    signDayLabel.text = [NSString stringWithFormat:@"%@天", continued];
    xingCoinLabel.text = [NSString stringWithFormat:@"获得%@猩币", sign_coin];
    tomorrowXingCoinLabel.text = [NSString stringWithFormat:@"明天签到将获得%@猩币", next_sign_coin];
    progressView.progress = [coin_total floatValue] / [next_grade_coin floatValue] ;
}

@end
