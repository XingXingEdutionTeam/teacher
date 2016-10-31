//
//  XXEWalletWithdrawCashViewController.h
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEWalletWithdrawCashViewController : XXEBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *aliPayTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *certainButton;

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;



//账号 中间 隐藏一部分
@property (nonatomic, copy) NSString *aliPayAccountStr;
//账号 全部 明文 显示
@property (nonatomic, copy) NSString *accountStr;
//account_id
@property (nonatomic, copy) NSString *account_id;
//账户 名称
@property (nonatomic, copy) NSString *name;

@end
