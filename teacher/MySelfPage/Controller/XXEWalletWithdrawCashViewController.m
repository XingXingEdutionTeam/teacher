


//
//  XXEWalletWithdrawCashViewController.m
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEWalletWithdrawCashViewController.h"
#import "XXEWalletWithdrawCashApi.h"
#import "XXECheckPassWordApi.h"
#import "PayPwdView.h"


@interface XXEWalletWithdrawCashViewController ()<UITextFieldDelegate, PayPwdViewDelegate>
{
    NSString *totalMoney;
    NSString *fbasket_commission_per;
    NSString *schoolId;
    NSString *position;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@end

@implementation XXEWalletWithdrawCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

//    [DEFAULTS setObject:totalMoney forKey:@"totalMoney"];
//    [DEFAULTS setObject:fbasket_commission_per forKey:@"fbasket_commission_per"];
   totalMoney = [DEFAULTS objectForKey:@"totalMoney"];
   fbasket_commission_per = [DEFAULTS objectForKey:@"fbasket_commission_per"];
    schoolId = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    position = [DEFAULTS objectForKey:@"POSITION"];

    
    if (totalMoney == nil) {
        totalMoney = @"";
    }
    
    
    _moneyTextField.delegate = self;
    _aliPayTextField.delegate = self;
    _nameTextField.delegate = self;
    
    _moneyTextField.placeholder = [NSString stringWithFormat:@"%@", totalMoney];
    _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    _aliPayTextField.text = _aliPayAccountStr;
    _nameTextField.text = _name;
    _alertLabel.text = [NSString stringWithFormat:@"提示:提现需要收取%@的手续费", fbasket_commission_per];
    
    [_certainButton addTarget:self action:@selector(certainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)certainButtonClick:(UIButton *)button{

    if ([_moneyTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善提现金额" forSecond:1.5];
    }else{
    
        //请输入支付密码
        [self writePayCode];
    }
}


- (void)writePayCode{
//    PayPwdView *myPayPwdView=[[PayPwdView alloc]initWithFrame:self.view.bounds];
    PayPwdView *myPayPwdView=[[PayPwdView alloc]initWithFrame:CGRectMake(0, -64, KScreenWidth, KScreenHeight)];
    myPayPwdView.delegate=self;
    [self.view addSubview:myPayPwdView];
    
}


 #pragma mark -支付视图的Delegate =============================
 // 每次输入的密码
 -(void)eachInputPwd:(PayPwdView *)payView eachClickPwd:(NSString *)eachClickPwd{
     NSLog(@"这次输入的是:%@",eachClickPwd);
 }
 // 最终的密码(点击了确认按钮才回调用这个方法)
 -(void)finaInputPwd:(PayPwdView *)payView surePwd:(NSString *)surePwd{
     NSLog(@"最终的密码是:%@",surePwd);
     
     //需要先提交给顾老师 确认 支付 密码是否正确
     [self checkPayCode:surePwd];
     
 }

- (void)checkPayCode:(NSString *)surePwd{
 
    /*
     XXESchoolWithdrawPageApi *schoolWithdrawPageApi = [[XXESchoolWithdrawPageApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:schoolId position:position];
     [schoolWithdrawPageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
     */
    
    
    XXECheckPassWordApi *checkPassWordApi = [[XXECheckPassWordApi alloc] initWithXid:parameterXid user_id:parameterUser_Id pass:surePwd];
    [checkPassWordApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        NSLog(@"%@", request.responseJSONObject);
        
        NSString *codeStr = request.responseJSONObject[@"code"];
        if ([codeStr integerValue] == 1) {
            //如果 支付 密码 正确 再提交请求
            [self uploadPayRequest];
 
        }else{
        
            [self showHudWithString:@"支付密码错误!" forSecond:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}


- (void)uploadPayRequest{

    XXEWalletWithdrawCashApi *walletWithdrawCashApi = [[XXEWalletWithdrawCashApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:schoolId position:position account_id:_account_id all_money:_moneyTextField.text return_param_all:@""];
    [walletWithdrawCashApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //            NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功,等待处理!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
