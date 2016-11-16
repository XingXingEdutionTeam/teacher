

//
//  XXEStorePayViewController.m
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStorePayViewController.h"

@interface XXEStorePayViewController ()
{
    //上部 订单bgView
    UIView *orderBgView;
    //下部 支付bgView
    UIView *payBgView;
    
    //确认支付 按钮
    UIButton *sureButton;
    
    //可用猩币数
    NSString *coinAble;
    //纯猩币支付时候的说明
    UILabel *noteLabel1;
    
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@end

@implementation XXEStorePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    coinAble = @"";

    /*
     data =     {
     "order_id" = 594;
     "order_index" = 39288589297;
     "pay_coin" = 300;
     "pay_price" = 0;   //一/当 pay_price 为0的时候,为纯猩币支付;二/当非0 的时候,非两种情况:(1)纯钱 (2)钱和猩币  ,两者调用同一个接口,如果使用猩币抵扣,后台会自动扣除猩币
     "user_coin_able" = 10708;
     };
     */

    
    //当前可用猩币数
    [self fetchXingCoinableInfo];

    //创建 内容
    [self createContent];
}

- (void)createContent{

    //上部 订单
    orderBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    orderBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderBgView];
    
    //购物车
    UIImageView *shoppingCart = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 33)];
    shoppingCart.image = [UIImage imageNamed:@"gouwuche"];
    [orderBgView addSubview:shoppingCart];
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(shoppingCart.frame.origin.x + shoppingCart.width + 20, 10, KScreenWidth - 50, 20)];
    moneyLabel.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:12];
    if ([_dict[@"pay_price"] integerValue] == 0) {
    moneyLabel.text = [NSString stringWithFormat:@"猩币:%@",_dict[@"pay_coin"]];
    }else{
    moneyLabel.text = [NSString stringWithFormat:@"猩币:%@     ￥:%@",_dict[@"pay_coin"], _dict[@"pay_price"]];
    }
    
    [orderBgView addSubview:moneyLabel];
    
    //订单号
    UILabel *orderCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.origin.x ,moneyLabel.frame.origin.y + moneyLabel.height + 10, KScreenWidth - 50, 20)];
    orderCodeLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    orderCodeLabel.text = [NSString stringWithFormat:@"订单号:%@", _dict[@"order_index"]];
    orderCodeLabel.textColor = [UIColor lightGrayColor];
    [orderBgView addSubview:orderCodeLabel];
    
    //下部 支付
    if ([_dict[@"pay_price"] integerValue] == 0) {
        //纯猩币 支付
        [self createOnlyXingCoinPay];
        
    }else{
        // 可猩币 / 可钱
        [self createMoneyPay];
    }
    
    //确认 支付 按钮
    CGFloat buttonX = (KScreenWidth - 325 * kScreenRatioWidth) / 2;
    CGFloat buttonY = payBgView.frame.origin.y + payBgView.height + 20;
    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    
    sureButton = [UIButton createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) backGruondImageName:@"zhifuaniu" Target:self Action:@selector(sureButtonClick:) Title:@""];
    NSString *buttonTitle = @"";
    sureButton.titleLabel.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:12];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([_dict[@"pay_price"] integerValue] == 0) {
      //纯猩币 支付
        buttonTitle = [NSString stringWithFormat:@"确认支付猩币:%@个", _dict[@"pay_coin"]];
    }else{
        buttonTitle = [NSString stringWithFormat:@"确认支付金额:%@元", _dict[@"pay_price"]];
    }
    [sureButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.view addSubview:sureButton];

}


#pragma mark ======= 纯 猩币 支付 =============
- (void)createOnlyXingCoinPay{
    payBgView = [[UIView alloc] initWithFrame:CGRectMake(0, orderBgView.frame.origin.y + orderBgView.height + 10, KScreenWidth, 70)];
    payBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payBgView];
    
    //支付 icon
    UIImageView *xingxingicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 33)];
    xingxingicon.image = [UIImage imageNamed:@"xingbiXB"];
    [payBgView addSubview:xingxingicon];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xingxingicon.frame.origin.x + xingxingicon.width + 20, 10, KScreenWidth - 50, 20)];
    titleLabel.text = @"猩币支付";
    titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [payBgView addSubview:titleLabel];
    
    //说明
    noteLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x ,titleLabel.frame.origin.y + titleLabel.height + 10, KScreenWidth - 50, 20)];
    noteLabel1.font = [UIFont systemWithIphone6P:12 Iphone6:10 Iphone5:8 Iphone4:6];
    [payBgView addSubview:noteLabel1];

    UIButton *selectButton = [UIButton createButtonWithFrame:CGRectMake(KScreenWidth - 50, 20, 25, 25) backGruondImageName:@"weixuan" Target:self Action:@selector(selectButtonClick:) Title:@""];
    [payBgView addSubview:selectButton];

}

- (void)selectButtonClick:(UIButton *)button{



}

#pragma mark ======= 可猩币 / 可钱 ============
- (void)createMoneyPay{

    payBgView = [[UIView alloc] initWithFrame:CGRectMake(0, orderBgView.frame.origin.y + orderBgView.height + 10, KScreenWidth, 140)];
    [self.view addSubview:payBgView];
    
    //支付 icon
    NSMutableArray *iconArray = [[NSMutableArray alloc] initWithObjects:@"weixinWX", @"zhifubaoZFB", nil];
    //title
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"微信支付", @"支付宝支付", nil];
    //说明
    NSMutableArray *noteArray = [NSMutableArray arrayWithObjects:@"推荐安装微信5.0以上的用户使用", @"推荐有支付宝账号的用户使用", nil];
    for (int i = 0; i < 2; i++) {
        UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + (70 + 1) * i, KScreenWidth, 70)];
        cellBgView.backgroundColor = [UIColor whiteColor];
        [payBgView addSubview:cellBgView];
        
        //支付 icon
        UIImageView *xingxingicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 33)];
        xingxingicon.image = [UIImage imageNamed:iconArray[i]];
        [cellBgView addSubview:xingxingicon];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xingxingicon.frame.origin.x + xingxingicon.width + 20, 10, KScreenWidth - 50, 20)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
        [cellBgView addSubview:titleLabel];
        
        //说明
        UILabel *noteLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x ,titleLabel.frame.origin.y + titleLabel.height + 10, KScreenWidth - 50, 20)];
        noteLabel1.font = [UIFont systemWithIphone6P:12 Iphone6:10 Iphone5:8 Iphone4:6];
        noteLabel1.text = noteArray[i];
        [cellBgView addSubview:noteLabel1];
        
        UIButton *selectButton = [UIButton createButtonWithFrame:CGRectMake(KScreenWidth - 50, 20, 25, 25) backGruondImageName:@"weixuan" Target:self Action:@selector(selectButtonClick:) Title:@""];
        selectButton.tag = 100 + i;
        
        [cellBgView addSubview:selectButton];
    
    }
    
}


#pragma mark ======== 当前可用猩币数 ==============
- (void)fetchXingCoinableInfo{
/*
 【获得用户单个字段信息】通用接口
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/getUserGlobalInfo
 传参:
	field	//想要获取信息的字段名,可以获取1个或者多个,多个逗号隔开,比如:coin_total,coin_able
 //可用字段名:
 lv		//登录
 coin_total	//猩币历史总数
 coin_able	//猩币可用数
 */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/getUserGlobalInfo";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"field":@"coin_able"
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
//        NSLog(@"可用猩币数 : %@", responseObj);
        /*
         data =     {
         "coin_able" = 10708;
         };
         */
        if ([responseObj[@"code"] integerValue] == 1) {
            coinAble = responseObj[@"data"][@"coin_able"];
            
            noteLabel1.text = [NSString stringWithFormat:@"您的剩余猩币总数:%@(每100猩币可抵扣1元)", coinAble];
        }
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
    
    
}

#pragma mark ********** 确认支付 ******************
- (void)sureButtonClick:(UIButton *)button{



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
