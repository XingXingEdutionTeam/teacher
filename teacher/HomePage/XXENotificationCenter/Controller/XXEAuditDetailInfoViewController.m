
//
//  XXEAuditDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAuditDetailInfoViewController.h"
#import "XXENotificationAgainstOrSupportApi.h"


@interface XXEAuditDetailInfoViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEAuditDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    _subjectLabel.text = _subjectStr;
    _contentTextView.text = _contentStr;
    [_againstButton addTarget:self action:@selector(againstButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_supportButton addTarget:self action:@selector(supportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

//驳回
- (void)againstButtonClick:(UIButton *)button{
/*
 【校园通知--审核通过和驳回操作】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/school_notice_action
 
 传参:
	notice_id	//通知id
	action_type	//操作类型  1:审核通过  2:驳回
 */
    XXENotificationAgainstOrSupportApi *notificationAgainstOrSupportApi = [[XXENotificationAgainstOrSupportApi alloc] initWithXid:parameterXid user_id:parameterUser_Id notice_id:_notice_id action_type:@"2"];
    
    [notificationAgainstOrSupportApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//                NSLog(@"反驳---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];

}

//通过
- (void)supportButtonClick:(UIButton *)button{
    
    XXENotificationAgainstOrSupportApi *notificationAgainstOrSupportApi = [[XXENotificationAgainstOrSupportApi alloc] initWithXid:parameterXid user_id:parameterUser_Id notice_id:_notice_id action_type:@"1"];
    
    [notificationAgainstOrSupportApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//                NSLog(@"通过---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end