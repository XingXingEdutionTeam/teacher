
//
//  XXEClassManagerClassDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerClassDetailInfoViewController.h"
#import "XXEClassManagerClassSupportAndRefuseApi.h"


@interface XXEClassManagerClassDetailInfoViewController ()
{
    NSString *action_type;	//执行类型  1:通过  2:驳回
    NSString *parameterXid;
    NSString *parameterUser_Id;
}



@end

@implementation XXEClassManagerClassDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"班级详情";
    action_type = @"";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    _classNameLabel.text = _classNameStr;
    _classNumLabel.text = _classNumStr;
    _teacherLabel.text = _teacherStr;

    if (![_position isEqualToString:@"4"] || [_condit isEqualToString:@"1"]) {
       
        _supportButton.hidden = YES;
        _refuseButton.hidden = YES;
    }else{
        [_supportButton addTarget:self action:@selector(supportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_refuseButton addTarget:self action:@selector(refuseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    
}

- (void)supportButtonClick:(UIButton *)button{
    action_type = @"1";
    [self submitInfo];
}


- (void)refuseButtonClick:(UIButton *)button{
    action_type = @"2";
    [self submitInfo];

}


- (void)submitInfo{    
    XXEClassManagerClassSupportAndRefuseApi *classManagerClassSupportAndRefuseApi = [[XXEClassManagerClassSupportAndRefuseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id class_id:_classId school_id:_schoolId position:_position action_type:action_type];
    
    [classManagerClassSupportAndRefuseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//      NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"操作成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"发布失败!" forSecond:1.5];
    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
