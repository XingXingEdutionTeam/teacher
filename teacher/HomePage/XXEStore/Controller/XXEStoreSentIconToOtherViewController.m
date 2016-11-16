
//
//  XXEStoreSentIconToOtherViewController.m
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreSentIconToOtherViewController.h"
#import "XXEStoreSentIconToOtherHistoryViewController.h"
#import "XXEStoreIconSentToOtherModel.h"


#define KMarg 10.0f
#define KLabelX 20.0f
#define KLabelW 70.0f
#define KLabelH 30.0f

@interface XXEStoreSentIconToOtherViewController ()
{

//    NSMutableDictionary *xidDict;
    UITextField * moneyText;
    UILabel * moneyRemainLabel;
    UIView *_view1;
    UILabel *_zhuanZeng;
    
    NSString *moneyRemainStr;
    
    //转赠 对象
    NSMutableArray *toOtherModelArray;
    
    NSString *take_xid;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;

}
@property(nonatomic,strong)WJCommboxView *familyCombox;
@property (nonatomic, strong) UIView *comBackView;


@end

@implementation XXEStoreSentIconToOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    self.title = @"猩币转赠";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    take_xid = @"";
    
    //获取猩币
    [self fetchIconInfoData];
    
    //转赠对象
    [self fetchIconToOther];

    [self createContent];
}

- (void)fetchIconInfoData{
/*
 【猩猩商城首页,显示猩币数量】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/get_user_coin
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_user_coin";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"原有猩币数%@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            NSString *coinNumStr = [NSString stringWithFormat:@"%@", responseObj[@"data"][@"coin_able"]];
            
            moneyRemainLabel.text= coinNumStr;
            moneyText.placeholder=[NSString stringWithFormat:@"最多可转%@猩币",coinNumStr];
            moneyRemainStr = coinNumStr;
        }
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];

}

#pragma mark ======= 转赠 对象 ===========
- (void)fetchIconToOther{
    /*
     【猩猩商城--获取互赠猩币的联系人】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/get_relation_person
     传参:(测试 user_id = 3)
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_relation_person";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };

[WZYHttpTool post:urlStr params:params success:^(id responseObj) {
    //
//    NSLog(@"转赠 猩币 对象 === %@", responseObj);
    if ([responseObj[@"code"] integerValue] == 1) {
      
        NSArray *arr = [[NSArray alloc] init];
        arr = [XXEStoreIconSentToOtherModel parseResondsData:responseObj[@"data"]];
        
        toOtherModelArray = [[NSMutableArray alloc] initWithArray:arr];
        
        NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        for (XXEStoreIconSentToOtherModel *model in toOtherModelArray) {
            [nameArray addObject:model.tname];
        }
        
        self.familyCombox.dataArray =  nameArray;
        [self.familyCombox.listTableView reloadData];
    }
    
} failure:^(NSError *error) {
    //
    [self showString:@"获取数据失败!" forSecond:1.5];
}];
}

- (void)createContent{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    //猩币余额
    UILabel *xingMoney = [UILabel createLabelWithFrame:CGRectMake(KLabelX, KMarg, KLabelW, KLabelH) Font:16 Text:@"猩币余额:"];
    [bgView addSubview:xingMoney];
    moneyRemainLabel=[UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(xingMoney.frame)+KMarg , KMarg, kWidth - CGRectGetMaxX(xingMoney.frame) - KLabelX*2 , KLabelH) Font:16 Text:@""];
    moneyRemainLabel.textColor=UIColorFromRGB(29, 29, 29);
    moneyRemainLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:moneyRemainLabel];
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyRemainLabel.frame) + 5, kWidth, 1)];
    _view1.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgView addSubview:_view1];
    
    //转赠对象
    _zhuanZeng = [UILabel createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(_view1.frame) + KMarg, KLabelW, KLabelH) Font:16 Text:@"转赠对象:"];
    [bgView addSubview:_zhuanZeng];
    
    
    self.familyCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zhuanZeng.frame) + KMarg, CGRectGetMaxY(_view1.frame) + KMarg, kWidth - CGRectGetMaxX(_zhuanZeng.frame) - KLabelX*2, KLabelH)];
    self.familyCombox.textField.placeholder = @"请选择转赠对象";
    self.familyCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.familyCombox.textField.borderStyle = UITextBorderStyleNone;
    self.familyCombox.textField.tag = 101;
    [bgView addSubview:self.familyCombox];
    self.comBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight+300)];
    self.comBackView.backgroundColor = [UIColor clearColor];
    self.comBackView.alpha = 0.5;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_zhuanZeng.frame) + KMarg, WinWidth, 1)];
    view2.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgView addSubview:view2];
    
    //转赠猩币数目
    UILabel *xingbiLabel =  [UILabel createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view2.frame) + 5, KLabelW, KLabelH) Font:16 Text:@"猩币数目:"];
    [bgView addSubview:xingbiLabel];
    moneyText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(xingbiLabel.frame) + KMarg, CGRectGetMaxY(view2.frame) + 5, kWidth - CGRectGetMaxX(xingbiLabel.frame) - KLabelX *2 , KLabelH)];
    moneyText.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    moneyText.placeholder = @"正在加载中...";
    moneyText.keyboardType=UIKeyboardTypeNumberPad;
    moneyText.borderStyle = UITextBorderStyleNone;
    moneyText.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview: moneyText];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyText.frame) + KMarg, WinWidth, 1)];
    view3.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgView addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view3.frame), WinWidth, WinHeight-CGRectGetMaxY(view3.frame))];
    view4.backgroundColor=UIColorFromRGB(229, 232, 233);
    [bgView addSubview:view4];
    
    
    //确认转赠
    UIButton *sentButton = [UIButton createButtonWithFrame:CGRectMake(KLabelX,CGRectGetMaxY(view3.frame) + KMarg *6 ,kWidth - KLabelX *2 , 42) backGruondImageName:@"login_green" Target:self Action:@selector(affirmBtn) Title:@"确认转赠"];
    [sentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sentButton];
    
    //转赠历史
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"home_flowerbasket_historyIcon44x44.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(moneyHistory)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;


}

#pragma mark ------  确认转赠 -------------
- (void)affirmBtn{
    if([moneyText.text intValue]>[moneyRemainStr intValue]){
        [self showString:@"余额不足，转赠失败" forSecond:1.5];
    }
    else if([self.familyCombox.textField.text isEqualToString:@""]){
        [self showString:@"请选择增送对象" forSecond:1.5];
    }
    else if([moneyText.text isEqualToString:@""]){
        [self showString:@"请输入转赠数目" forSecond:1.5];
    }
    else if([[moneyText.text substringToIndex:1]isEqualToString:@"0"]){
        [self showString:@"赠送数目不能以0开头" forSecond:1.5];
    }else{
        
        [self sentIconToOtherPerson];
        moneyText.text=@"";
        self.familyCombox.textField.text =@"";
        
    }
    
}

- (void)sentIconToOtherPerson{

    /*
     【猩猩商城--猩币互转】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/coin_turn
     传参:
     turn_num	//转增猩币数
     give_xid	//赠送人xid
     take_xid	//接收人xid
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/coin_turn";
    NSString *sentIconNumStr = moneyText.text;
    
    for (XXEStoreIconSentToOtherModel *model in toOtherModelArray) {
        if ([_familyCombox.textField.text isEqualToString:model.tname]) {
            take_xid = model.xid;
        }
    }

    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"turn_num":sentIconNumStr,
                             @"give_xid":parameterXid,
                             @"take_xid":take_xid
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"转赠 成功 %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            [self showString:@"转赠成功!" forSecond:1.5];
            
//            moneyRemainLabel.text=[NSString stringWithFormat:@"%@",responseObj[@"data"][@"coin_able"]];
//            moneyText.placeholder=[NSString stringWithFormat:@"最多可转%@猩币",responseObj[@"data"][@"coin_able"]];
//            moneyRemainStr=[NSString stringWithFormat:@"%@",responseObj[@"data"][@"coin_able"]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
    
}



#pragma mark ========= 转赠 历史 ==========
- (void)moneyHistory{

    XXEStoreSentIconToOtherHistoryViewController *storeSentIconToOtherHistoryVC = [[XXEStoreSentIconToOtherHistoryViewController alloc] init];
    
    [self.navigationController pushViewController:storeSentIconToOtherHistoryVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
