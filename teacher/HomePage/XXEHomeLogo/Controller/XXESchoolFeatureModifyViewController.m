

//
//  XXESchoolFeatureModifyViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolFeatureModifyViewController.h"
#import "XXEModifyCharacterApi.h"
#import "XXEMyselfInfoTeachingExpericenceApi.h"
#import "XXEMyselfInfoModifyTeachingFeelingApi.h"
#import "XXEMyselfInfoModifyPersonal_signApi.h"


@interface XXESchoolFeatureModifyViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}
@end

@implementation XXESchoolFeatureModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    _featureTextView.text = _schoolfeatureStr;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submitButton:(UIButton *)sender {
    
    if ([_featureTextView.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善信息" forSecond:1.5];
    }else{
    
        [self submitSchoolFeatureInfo];
    }
    
}

- (void)submitSchoolFeatureInfo{
    if ([_flagStr isEqualToString:@"formSchoolInfo"]) {
        //修改 学校 特点
        
        self.title = @"特   点";
        [self modifySchoolFeatureInfo];
    }else if ([_flagStr isEqualToString:@"fromMyselfInfoTeachingExperience"]) {
        //修改 个人 教学经历
        self.title = @"教学经历";
        [self modifyMyselfTeachingExperience];
    }else if ([_flagStr isEqualToString:@"fromMyselfInfoTeachingFeeling"]) {
        //修改 个人 教学感悟
        self.title = @"教学感悟";
        [self modifyMyselfTeachingFeeling];
    }else if ([_flagStr isEqualToString:@"fromMyselfInfoPersonalSignApi"]) {
        //修改 个人 个性签名
        self.title = @"个性签名";
        [self modifyMyselfTeachingPersonalSign];
    }

}

//修改 学校 特点
- (void)modifySchoolFeatureInfo{

    XXEModifyCharacterApi *modifySchoolCharacterApi = [[XXEModifyCharacterApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:@"4" charact:_featureTextView.text];
    
    [modifySchoolCharacterApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                //               self.returnStrBlock(_featureTextView.text);
                self.returnStrBlock(_featureTextView.text);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败" forSecond:1.5];
    }];
}

//修改 个人 教学经历
- (void)modifyMyselfTeachingExperience{

    XXEMyselfInfoTeachingExpericenceApi *modifyMyselfTeachingExperienceApi = [[XXEMyselfInfoTeachingExpericenceApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE teach_life:_featureTextView.text];
    
    [modifyMyselfTeachingExperienceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                //               self.returnStrBlock(_featureTextView.text);
                self.returnStrBlock(_featureTextView.text);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败" forSecond:1.5];
    }];
}

//修改 个人 教学感悟
- (void)modifyMyselfTeachingFeeling{

    XXEMyselfInfoModifyTeachingFeelingApi *modifyMyselfTeachingFeelingApi = [[XXEMyselfInfoModifyTeachingFeelingApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE teach_feel:_featureTextView.text];
    
    [modifyMyselfTeachingFeelingApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                //               self.returnStrBlock(_featureTextView.text);
                self.returnStrBlock(_featureTextView.text);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"提交失败" forSecond:1.5];
    }];

}

//修改 个人 个性签名
- (void)modifyMyselfTeachingPersonalSign{
    
    XXEMyselfInfoModifyPersonal_signApi *modifyMyselfPersonal_signApi = [[XXEMyselfInfoModifyPersonal_signApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE personal_sign:_featureTextView.text];
    
    [modifyMyselfPersonal_signApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                //               self.returnStrBlock(_featureTextView.text);
                self.returnStrBlock(_featureTextView.text);
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
