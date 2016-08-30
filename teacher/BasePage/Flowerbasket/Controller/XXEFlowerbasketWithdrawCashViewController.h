//
//  XXEFlowerbasketWithdrawCashViewController.h
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEFlowerbasketWithdrawCashViewController : XXEBaseViewController



@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;


@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UITextField *aliPayAccountTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
//账号 中间 隐藏一部分
@property (nonatomic, copy) NSString *aliPayAccountStr;
//账号 全部 明文 显示
@property (nonatomic, copy) NSString *accountStr;


- (IBAction)certenButton:(UIButton *)sender;



@end
