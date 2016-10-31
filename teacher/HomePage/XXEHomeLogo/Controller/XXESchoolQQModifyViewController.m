


//
//  XXESchoolQQModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolQQModifyViewController.h"
#import "XXEModifyQQApi.h"

@interface XXESchoolQQModifyViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@end

@implementation XXESchoolQQModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"更换QQ号";
    
    _QQTextField.text = _qqStr;
    
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
    
    XXEModifyQQApi *modifyQQApi = [[XXEModifyQQApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:_position qq:_QQTextField.text];
    
    [modifyQQApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(_QQTextField.text);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败" forSecond:1.5];
    }];
    
}

- (void)returnStr:(ReturnStrBlock)block{
    self.returnStrBlock = block;
}

@end
