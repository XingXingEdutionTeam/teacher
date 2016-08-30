

//
//  XXESchoolEmailModiyfViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolEmailModiyfViewController.h"
#import "XXEModifyEmailApi.h"



@interface XXESchoolEmailModiyfViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXESchoolEmailModiyfViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"更换邮箱";
    
    _emailTextField.text = _emailStr;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)submitButtonClick{

    if ([self validateEmail:_emailTextField.text] == YES) {
        
        [self modifyEmailInfo];
        
    }else{
    
        [self showHudWithString:@"请输入正确的邮箱号" forSecond:1.5];
    }
    
}

- (void)modifyEmailInfo{

    XXEModifyEmailApi *modifyEmailApi = [[XXEModifyEmailApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:@"4" email:_emailTextField.text];
    
    [modifyEmailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(_emailTextField.text);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败" forSecond:1.5];
    }];

}




- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)returnStr:(ReturnStrBlock)block{
    self.returnStrBlock = block;
}


@end
