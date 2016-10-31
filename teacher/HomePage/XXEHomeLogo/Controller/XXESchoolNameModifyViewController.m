


//
//  XXESchoolNameModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolNameModifyViewController.h"
#import "XXEModifySchoolNameApi.h"


@interface XXESchoolNameModifyViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@end

@implementation XXESchoolNameModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _schoolNameTextView.text = _schoolNameStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submitButton:(UIButton *)sender {
    
    if ([_schoolNameTextView.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善信息" forSecond:1.5];
    }else{
        [self submitSchoolNameInfo];
    }
}

- (void)submitSchoolNameInfo{
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    XXEModifySchoolNameApi *modifySchoolNameApi = [[XXEModifySchoolNameApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:_position name:_schoolNameTextView.text];
    
    [modifySchoolNameApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                self.returnStrBlock(_schoolNameTextView.text);
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
