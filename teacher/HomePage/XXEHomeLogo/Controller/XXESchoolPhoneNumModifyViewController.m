


//
//  XXESchoolPhoneNumModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolPhoneNumModifyViewController.h"
#import "XXEModifyPhoneNumApi.h"
#import "XXEMyselfInfoModifyPhoneNumApi.h"

#import "XXERegisterCheckApi.h"
#import <SMS_SDK/SMSSDK.h>
#import "XXEVertifyTimesApi.h"

@interface XXESchoolPhoneNumModifyViewController ()<UITextFieldDelegate>
{
   //用户 手机 号
    NSString *account;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

/** 用户名 */
@property (nonatomic, copy)NSString *registerUserName;

/** 验证码 */
@property (nonatomic, copy)NSString *registerVerifi;


@end

@implementation XXESchoolPhoneNumModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"更换手机号";
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
        
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    [self createContent];

}

- (void)createContent{

    //用户名
    [[self.phoneNumTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return [self isChinaMobile:text];
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        self.registerUserName = x;
    } ];
    
    self.phoneNumTextField.delegate = self;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    //验证码
    [[self.checkCodeTextField.rac_textSignal filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(id x) {
        self.registerVerifi = x;
    }];
    self.checkCodeTextField.delegate = self;
    
    
    //最初 验证码 按钮 不可点击
    [_checkCodeButton addTarget:self action:@selector(checkCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _checkCodeButton.userInteractionEnabled = NO;
    
    
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取 验证码
- (void)checkCodeButtonClick:(UIButton *)button{

    NSLog(@"----获取验证码----");
    [button startWithTime:5 title:@"获取验证码" countDownTile:@"s后重新获取" mColor:XXEColorFromRGB(189, 210, 38) countColor:XXEColorFromRGB(204, 204, 204)];
    [self showString:@"验证码已发送" forSecond:1.f];
    [self getVerificationNumber];

}

- (void)getVerificationNumber
{
    //短信验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.registerUserName zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [self showString:@"获取验证码成功" forSecond:1.f];
            //记录次数
            [self recordTheVerifyCodeNum];
        }
    }];
}

#pragma mark - 获取验证码次数
- (void)recordTheVerifyCodeNum
{
    XXEVertifyTimesApi *timesApi = [[XXEVertifyTimesApi alloc]initWithVertifyTimesActionPage:@"1" PhoneNum:self.registerUserName];
    [timesApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        NSInteger code1 = [code integerValue];
        
        if (code1 == 4) {
            [self showString:@"已达今日5条上线" forSecond:1.f];
            self.checkCodeButton.userInteractionEnabled = NO;
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}


#pragma mark - UItextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.phoneNumTextField == textField) {
        [self.phoneNumTextField resignFirstResponder];
        if (self.registerUserName == nil) {
            [self showString:@"输入电话号码有误" forSecond:1.f];
        } else {
            //验证手机号有没有注册过
            [self checkPhoneNumber];
        }
    }
}

#pragma mark - 网络请求

- (void)checkPhoneNumber
{
    XXERegisterCheckApi *registerCheckApi = [[XXERegisterCheckApi alloc]initWithChechPhoneNumber:self.registerUserName];
    [registerCheckApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"电话可不可以用%@",request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        NSString *string = [dic objectForKey:@"code"];
        if ([string intValue] == 1) {
            [self showString:@"此号码可以注册" forSecond:1.f];
            self.checkCodeButton.userInteractionEnabled = YES;
        } else if ([string intValue] == 3) {
            [self showString:@"手机号码已存在" forSecond:2.f];
            self.checkCodeButton.userInteractionEnabled = NO;
        } else{
            [self showString:@"请重新注册" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"网络不好请重新注册" forSecond:1.f];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumTextField resignFirstResponder];
    [self.checkCodeTextField resignFirstResponder];
}


/** 判断用户名 */
- (BOOL)isChinaMobile:(NSString *)phoneNum{
    BOOL isChinaMobile = NO;
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    if([regextestcm evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国移动");
    }
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    if([regextestcu evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国联通");
    }
    
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if([regextestct evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国电信");
    }
    return isChinaMobile;
}

//
- (void)submitButtonClick{
    //先 验证 验证码 对不对
    [self verifyNumberISRight];

}

#pragma mark - 验证验证码对不对
-(void)verifyNumberISRight
{
    NSLog(@"电话号码%@ 验证码%@",self.registerUserName,self.registerVerifi);
    [SMSSDK commitVerificationCode:self.registerVerifi phoneNumber:self.registerUserName zone:@"86" result:^(NSError *error) {
        if (error) {
            [self showString:@"验证码错误" forSecond:1.f];
        }else {
//            NSLog(@"验证码 验证 成功");
            [self submitNewPhoneNum];
        }
    }];
}

//@"fromMyselfInfo"




- (void)submitNewPhoneNum{
    if ([_flagStr isEqualToString:@"fromSchoolInfo"]) {
        //修改 学校 电话
        [self modifySchoolPhoneNum];
    }else if ([_flagStr isEqualToString:@"fromMyselfInfo"]){
        //修改 个人 电话
        [self modifyProvatePhoneNum];
    }
}

- (void)modifySchoolPhoneNum{

    //position		//教职身份(传数字,1:授课老师  2:主任  3:管理  4:校长)
    XXEModifyPhoneNumApi *modifyPhoneNumApi = [[XXEModifyPhoneNumApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:_position tel:_registerUserName];
    [modifyPhoneNumApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(_registerUserName);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];
    
}

- (void)modifyProvatePhoneNum{
    XXEMyselfInfoModifyPhoneNumApi *modifyMyselfInfoPhoneNumApi = [[XXEMyselfInfoModifyPhoneNumApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE phone:_registerUserName];
    [modifyMyselfInfoPhoneNumApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(_registerUserName);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];
    
    
}

- (void)returnStr:(ReturnStrBlock)block{
    self.returnStrBlock = block;
}

@end
