

//
//  XXESchoolIntroductionDetailViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolIntroductionDetailViewController.h"
#import "XXEIntroductionDetailApi.h"


@interface XXESchoolIntroductionDetailViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@end

@implementation XXESchoolIntroductionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"简   介";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitButton:(UIButton *)sender {
    
    if ([_introductionDetailTextView.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善信息" forSecond:1.5];
    }else{
        
        [self submitSchoolFeatureInfo];
    }
}

- (void)submitSchoolFeatureInfo{
    
    XXEIntroductionDetailApi *introductionDetailApi = [[XXEIntroductionDetailApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:@"4" introduction:_introductionDetailTextView.text];
    
    [introductionDetailApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                //               self.returnStrBlock(_featureTextView.text);
                self.returnStrBlock(_introductionDetailTextView.text);
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
