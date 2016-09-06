

//
//  XXEMyselfInfoNameModifyViewController.m
//  teacher
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoNameModifyViewController.h"
#import "XXEMyselfInfoModifyNicknameApi.h"
#import "XXEMyselfInfoModifyTeachingAgeApi.h"

@interface XXEMyselfInfoNameModifyViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@end

@implementation XXEMyselfInfoNameModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    if ([_flagStr isEqualToString:@"fromMyselfModifyName"]) {
        _titleLabel.text = @"昵称";
        _nameTextField.placeholder = @"请输入昵称";
    }else if ([_flagStr isEqualToString:@"fromMyselfModifyTeachingAge"]){
        _titleLabel.text = @"教龄";
        _nameTextField.placeholder = @"请输入教龄";
    }
    
    
    _nameTextField.text = _nickNameStr;
}



- (IBAction)submitButton:(UIButton *)sender {
    
    if ([_nameTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善信息" forSecond:1.5];
    }else{
        [self submitSchoolNameInfo];
    }
}

- (void)submitSchoolNameInfo{
    
    if ([_flagStr isEqualToString:@"fromMyselfModifyName"]) {
        [self modifySchoolName];
    }else if ([_flagStr isEqualToString:@"fromMyselfModifyTeachingAge"]){
        [self modifyMyselfTeachingAge];
    }
}

- (void)modifySchoolName{
    XXEMyselfInfoModifyNicknameApi *myselfInfoModifyNameApi = [[XXEMyselfInfoModifyNicknameApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE nickname:_nameTextField.text];
    
    [myselfInfoModifyNameApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(_nameTextField.text);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败" forSecond:1.5];
    }];

}

- (void)modifyMyselfTeachingAge{
//XXEMyselfInfoModifyTeachingAgeApi
    XXEMyselfInfoModifyTeachingAgeApi *myselfInfoModifyTeachingAgeApi = [[XXEMyselfInfoModifyTeachingAgeApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE exper_year:_nameTextField.text];
    
    [myselfInfoModifyTeachingAgeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(_nameTextField.text);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
