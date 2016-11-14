

//
//  XXEStorePerfectConsigneeAddressViewController.m
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStorePerfectConsigneeAddressViewController.h"
#import "XXEStoreConsigneeAddressViewController.h"



@interface XXEStorePerfectConsigneeAddressViewController ()<UITextFieldDelegate, UITextViewDelegate>
{
   //上部 地址 信息 背景
    UIView *upBgView;
    
    //姓名 电话 地址 背景
    UIView *addressBgView;
    
    
    
    //下部 背景
    UIView *downBgView;
    
    //发票 抬头
    UITextField *invoiceTextField;
    //留言
    UITextView *messageTextView;
    //支付 按钮
    UIButton *payButton;

}

@end

@implementation XXEStorePerfectConsigneeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XXEBackgroundColor;

    //上部 地址 信息
    [self createUpContent];
    
    //下部 金额
    [self createDownContent];

}

#pragma mark ====== 上部 地址 信息 ===========
- (void)createUpContent{

    upBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight / 3 - 1)];
    upBgView.backgroundColor = [UIColor whiteColor];
    upBgView.userInteractionEnabled = YES;
    
    [self.view addSubview:upBgView];
    
    //请填写收货地址
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, 20)];
    titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    titleLabel.text = @"请填写收货地址";
    [upBgView addSubview:titleLabel];
    
    //姓名 电话 背景
    addressBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, upBgView.height - 60)];
//    addressBgView.backgroundColor = [UIColor yellowColor];
    addressBgView.userInteractionEnabled = YES;
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
    [addressBgView addGestureRecognizer:tap];

    [upBgView addSubview:addressBgView];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth / 2 - 20, 20)];
//    nameLabel.backgroundColor = [UIColor greenColor];
    [addressBgView addSubview:nameLabel];
    
    //电话
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 2, 0, KScreenWidth / 2, 20)];
//    phoneLabel.backgroundColor = [UIColor purpleColor];
    [addressBgView addSubview:phoneLabel];
    
    //地址 title
    UILabel *addressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 60, 20)];
    addressTitleLabel.text = @"[收货地址]";
    addressTitleLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    addressTitleLabel.textColor = [UIColor lightGrayColor];
    [addressBgView addSubview:addressTitleLabel];
    
    //地址
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressTitleLabel.frame.origin.x + addressTitleLabel.width, addressTitleLabel.frame.origin.y, KScreenWidth - 120, 110)];
//    addressLabel.backgroundColor = [UIColor blueColor];
    [addressBgView addSubview:addressLabel];
    
    //箭头
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(addressLabel.frame.origin.x + addressLabel.width, addressLabel.frame.origin.y, 7, 13)];
    icon.image = [UIImage imageNamed:@"narrow_icon14x26"];
    [addressBgView addSubview:icon];
    
    
    //提示
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, upBgView.height - 20, KScreenWidth - 20, 20)];
    alertLabel.text = @"(收货不便时,可选择免费代收货服务)";
    alertLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    alertLabel.textColor = UIColorFromRGB(251, 188, 26);
    [upBgView addSubview:alertLabel];
    
}


- (void)onClickPicture:(UITapGestureRecognizer *)tap{

//    NSLog(@"kkkkkk");
    XXEStoreConsigneeAddressViewController *storeConsigneeAddressVC = [[XXEStoreConsigneeAddressViewController alloc] init];
    
    [self.navigationController pushViewController:storeConsigneeAddressVC animated:YES];

}

#pragma mark ------- 下部 金额 --------------
- (void)createDownContent{

    downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, upBgView.frame.origin.y + upBgView.height + 1, KScreenWidth, KScreenHeight / 3 * 2 - 64)];
    downBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downBgView];
    
    //运费 title
    UILabel *freightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    freightTitleLabel.textColor = [UIColor lightGrayColor];
    freightTitleLabel.text = @"运费:";
    freightTitleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [downBgView addSubview:freightTitleLabel];
    
    //运费
    UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(freightTitleLabel.frame.origin.x + freightTitleLabel.width, freightTitleLabel.frame.origin.y, KScreenWidth - 100, 20)];
    freightLabel.text = @"免运费";
    freightLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    freightLabel.textColor = UIColorFromRGB(244, 52, 139);
    [downBgView addSubview:freightLabel];
    
    //发票抬头 title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, freightTitleLabel.frame.origin.y + freightTitleLabel.height + 10, 80, 20)];
//    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.text = @"发票抬头:";
    titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [downBgView addSubview:titleLabel];
    
    //发票抬头
    invoiceTextField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.width, titleLabel.frame.origin.y, KScreenWidth - 120, 20)];
    invoiceTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    invoiceTextField.delegate = self;
    [downBgView addSubview:invoiceTextField];
    
    //给商家留言 title
    UILabel *messageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.height + 10, KScreenWidth - 20, 20)];
    messageTitleLabel.text = @"给商家留言:";
    messageTitleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [downBgView addSubview:messageTitleLabel];
    
    
    messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, messageTitleLabel.frame.origin.y + messageTitleLabel.height, KScreenWidth - 20, 50)];
    messageTextView.layer.borderColor = XXEBackgroundColor.CGColor;
    messageTextView.layer.borderWidth = 1;
//    messageTextView.backgroundColor = [UIColor yellowColor];
    [downBgView addSubview:messageTextView];
    
    //合计 钱 title
    UILabel *moneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kScreenRatioWidth, messageTextView.frame.origin.y + messageTextView.height + 10, 40, 20)];
    moneyTitleLabel.text = @"合计:";
//    moneyTitleLabel.backgroundColor = [UIColor whiteColor];
    [downBgView addSubview:moneyTitleLabel];
    
    //合计 钱
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyTitleLabel.frame.origin.x + moneyTitleLabel.width, moneyTitleLabel.frame.origin.y, 100, 20)];
    moneyLabel.textColor = UIColorFromRGB(244, 52, 139);
    
//    moneyLabel.backgroundColor = [UIColor redColor];
    [downBgView addSubview:moneyLabel];
    
    //合计 猩币 title
    UILabel *coinTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.origin.x + moneyLabel.width, moneyTitleLabel.frame.origin.y, 80, 20)];
    coinTitleLabel.text = @"合计猩币:";
//    coinTitleLabel.backgroundColor = [UIColor blueColor];
    [downBgView addSubview:coinTitleLabel];
    
    //合计 猩币
    UILabel *coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(coinTitleLabel.frame.origin.x + coinTitleLabel.width, moneyTitleLabel.frame.origin.y, 100, 20)];
//    coinLabel.backgroundColor = [UIColor whiteColor];
    [downBgView addSubview:coinLabel];
    
    
    //支付 按钮
    payButton = [UIButton createButtonWithFrame:CGRectMake(KScreenWidth / 3 * 2, coinTitleLabel.frame.origin.y + coinTitleLabel.height + 20, 100, 20) backGruondImageName:nil Target:self Action:@selector(payButtonClick) Title:@"去支付"];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.backgroundColor = UIColorFromRGB(244, 52, 139);
    [downBgView addSubview:payButton];
    
    
}


//去支付
- (void)payButtonClick{



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
