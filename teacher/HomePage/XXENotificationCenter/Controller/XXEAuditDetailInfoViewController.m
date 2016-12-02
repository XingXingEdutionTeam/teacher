
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
    //创建 上部视图
    UIView *upBgView;
    UILabel *titleLabel;
    
    
    //下部 视图
    UIView *downBgView;
    UITextView *contentTextView;
    

    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEAuditDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XXEBackgroundColor;

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    //创建 内容
    [self createContent];

}


- (void)createContent{
    
#pragma mark ======== //通知主题 bgView ========
    UIView *cellBgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    cellBgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cellBgView1];
    
    //标题
    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(10, 10, 70, 20) Font:14 Text:@"通知主题:"];
    [cellBgView1 addSubview:titleLabel1];
    
    //内容
    UILabel *contentLabel1 = [UILabel createLabelWithFrame:CGRectMake(titleLabel1.frame.origin.x + titleLabel1.width, titleLabel1.frame.origin.y, KScreenWidth - 100, 20) Font:14 Text:_subjectStr];
    
    CGFloat height = [StringHeight contentSizeOfString:_subjectStr maxWidth:contentLabel1.width fontSize:14];
    
    CGSize size1 = contentLabel1.size;
    size1.height = height;
    contentLabel1.size = size1;
    [cellBgView1 addSubview:contentLabel1];
    
    CGSize size11 = cellBgView1.size;
    size11.height = 10 + height + 10;
    cellBgView1.size = size11;
    
    
#pragma mark ============ 创建 下部  ===========
    //创建 下部
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, cellBgView1.frame.origin.y + cellBgView1.height + 5, KScreenWidth, KScreenHeight - cellBgView1.height - 200)];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.text = _contentStr;
    contentTextView.editable = NO;
    [self.view addSubview:contentTextView];
    
#pragma mark ======== 创建  按钮 ========
    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    CGFloat buttonX = (KScreenWidth - buttonW) / 2;
    //驳回
    UIButton *againstButton = [UIButton createButtonWithFrame:CGRectMake(buttonX, contentTextView.frame.origin.y + contentTextView.height + 20, buttonW, buttonH) backGruondImageName:@"login_green" Target:self Action:@selector(againstButtonClick:) Title:@"驳     回"];
    [self.view addSubview:againstButton];
    
    //通过
    UIButton *supportButton = [UIButton createButtonWithFrame:CGRectMake(buttonX, againstButton.frame.origin.y + againstButton.height + 20, buttonW, buttonH) backGruondImageName:@"login_green" Target:self Action:@selector(supportButtonClick:) Title:@"通      过"];
    [self.view addSubview:supportButton];

    
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
