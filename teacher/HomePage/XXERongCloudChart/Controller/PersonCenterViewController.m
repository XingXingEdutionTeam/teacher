//
//  PersonCenterViewController.m
//  RCIM
//
//  Created by codeDing on 16/3/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "XXERongCloudAddToBlackListApi.h"
#import "XXERongCloudJudgePositionApi.h"
#import "XXERongCloudDeleteFriendApi.h"
#import "WMConversationViewController.h"
#import "XXERongCloudAddFriendRequestApi.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HHControl.h"
#import "SVProgressHUD.h"
#import "XXEFriendMyCircleViewController.h"
#import "ReportPicViewController.h"

@interface PersonCenterViewController (){

    UIButton *chatButton;
    UIButton *seeFriendCirileButton;
    UIButton *blackButton;
    UIButton *reportButton;
    UIButton *deleteButton;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}


@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
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

     //创建 头像 ,名称 ,xid
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 80)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
//    NSString *headUrl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,self.friendModel.head_img];
    NSString *headUrl = _userInfo.portraitUri;
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    [bgView addSubview:iconImageView];
    
    UILabel *nameLabel = [HHControl createLabelWithFrame:CGRectMake(100, 20, 150, 20) Font:14.0 Text:self.userInfo.name];
    [bgView addSubview:nameLabel];
    
    UILabel *xidLabel = [HHControl createLabelWithFrame:CGRectMake(100, 50, 200, 20) Font:14.0 Text:[NSString stringWithFormat:@"xid: %@", self.userInfo.userId]];
    xidLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:xidLabel];
    
    
    //创建 button   按钮big650x84@2x
    
    //650  84
    CGFloat buttonWidth = 325.0 * kWidth / 375;
    CGFloat buttonHeight = 42.0 * kWidth / 375;
    /**
    私聊
     */
    chatButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, bgView.frame.origin.y + bgView.frame.size.height + 50, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(chatButttonClick:) Title:@"私   聊"];
    [chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:chatButton];
    
    /**
     圈子
     */
    seeFriendCirileButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, chatButton.frame.origin.y + chatButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(seeFriendCirileButtonClick:) Title:@"查看圈子"];
    [seeFriendCirileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:seeFriendCirileButton];
    
    /**
     拉黑
     */
    blackButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, seeFriendCirileButton.frame.origin.y + seeFriendCirileButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(blackButtonClick:) Title:@"拉   黑"];
    [blackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:blackButton];
    
    /**
     举报
     */
   reportButton  = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, blackButton.frame.origin.y + blackButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(reportButtonClick:) Title:@"举   报"];
    [reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:reportButton];
    
//    /**
//     删除
//     */
//    deleteButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, reportButton.frame.origin.y + reportButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(deleteButtonClick:) Title:@"删   除"];
//    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:deleteButton];
    

}

- (void)chatButttonClick:(UIButton *)button{
//    if ([XXEUserInfo user].login){
        [self judgePosition];
//    }else{
//        [self showHudWithString:@"请用账号登录" forSecond:1.5];
//    }
    
}
    
- (void)judgePosition{
    NSString *otherXid = _userInfo.userId;
    
//    NSLog(@"kk %@", otherXid);
    XXERongCloudJudgePositionApi *rongCloudJudgePositionApi = [[XXERongCloudJudgePositionApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXid];
    [rongCloudJudgePositionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        /*
         ★其他结果需提醒用户
         code:5	//不是好友,不能发起聊天,是否要添加好友?(触发添加好友请求接口)
         code:6	//对方设置了不接受您的消息!无法发起聊天!
         code:7	//你不在对方的好友名单中,是否要添加好友?
         code:8	//你在对方的黑名单中,无法发起聊天!
         */
        if ([codeStr isEqualToString:@"1"]) {
            
            [self startChart];
        }else if ([codeStr isEqualToString:@"5"]) {
            [self showHudWithString:@"不是好友,不能发起聊天!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addFriendRequest];
            });

        }else if ([codeStr isEqualToString:@"6"]) {
            [self showHudWithString:@"对方设置了不接受您的消息!无法发起聊天!" forSecond:1.5];
            
        }else if ([codeStr isEqualToString:@"7"]) {
            [self showHudWithString:@"你不在对方的好友名单中,不能发起聊天!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addFriendRequest];
            });
        }else if ([codeStr isEqualToString:@"8"]) {
            [self showHudWithString:@"你在对方的黑名单中,无法发起聊天!" forSecond:1.5];
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
}

- (void)addFriendRequest{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
  [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    //
    textField.placeholder = @"申请备注";
  }];

  UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

  UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    [self requestAddFriend];
  }];
  [alert addAction:cancel];
  [alert addAction:ok];

  [self presentViewController:alert animated:YES completion:nil];

}

- (void)requestAddFriend{

    NSString *otherXid = _userInfo.userId;
    XXERongCloudAddFriendRequestApi *rongCloudAddFriendRequestApi = [[XXERongCloudAddFriendRequestApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXid];
    [rongCloudAddFriendRequestApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
              NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        /*
         ★其他结果需提醒用户
         code:4	//不能请求自己
         code:5	//已经是好友了(不能对好友发起请求)
         code:6	//对方在我的黑名单中,无法发起请求!
         code:7	//您已经在对方黑名单中,无法发起请求!
         code:8	//不能重复对同一个人发起请求!
         code:9	//对方已同意,可以直接聊天了 (对方设置了任何人请求直接通过)
         */
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"请求发送成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [self showHudWithString:@"不能请求自己!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"5"]) {
            [self showHudWithString:@"对方已经是您的好友!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"6"]) {
            [self showHudWithString:@"对方在我的黑名单中,无法发起请求!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"7"]) {
            [self showHudWithString:@"您已经在对方黑名单中,无法发起请求!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"8"]) {
            [self showHudWithString:@"不能重复对同一个人发起请求!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"9"]) {
            [self showHudWithString:@"对方已同意,可以直接聊天了!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"10"]) {
            [self showHudWithString:@"添加成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHudWithString:@"请求发送失败!" forSecond:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}



- (void)startChart{
    if (self.userInfo) {
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        
        _conversationVC.targetId = self.userInfo.userId;
        _conversationVC.title = [NSString stringWithFormat:@"%@",self.userInfo.name];
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else{
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        //                NSLog(@"%@", )
        
        _conversationVC.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
        _conversationVC.title = [NSString stringWithFormat:@"%@",[RCIM sharedRCIM].currentUserInfo.name];
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }

}



- (void)seeFriendCirileButtonClick:(UIButton *)button{
    
    XXEFriendMyCircleViewController *viewVC = [[XXEFriendMyCircleViewController alloc]init];
    viewVC.otherXid = self.userInfo.userId;
    viewVC.rootChat = @"从聊天界面过去";
    [self.navigationController pushViewController:viewVC animated:YES
     ];

}

- (void)blackButtonClick:(UIButton *)button{

        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定将好友加入黑名单？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //加入 黑名单
            [self addToBlackList];

        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    

}

- (void)addToBlackList{
    NSString *otherXid = _userInfo.userId;
    XXERongCloudAddToBlackListApi *rongCloudAddToBlackListApi = [[XXERongCloudAddToBlackListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXid];
    [rongCloudAddToBlackListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //      NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        /*
         ★其他结果需提醒用户
         code:4		//此人已在黑名单中
         */
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"拉黑成功!" forSecond:1.5];
            
            NSDictionary *notiDic = [NSDictionary dictionaryWithObject:otherXid forKey:@"DeleteXid"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:self userInfo:notiDic];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [self showHudWithString:@"此人已在黑名单中!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHudWithString:@"拉黑失败!" forSecond:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];


}

- (void)reportButtonClick:(UIButton *)button{

    ReportPicViewController * vc=[[ReportPicViewController alloc]init];
    
    /*
     【举报提交】
     
     接口类型:2
     
     接口:
     http://www.xingxingedu.cn/Global/report_sub
     
     传参:
     other_xid	//被举报人xid (举报用户时才有此参数)
     report_name_id	//举报内容id , 多个逗号隔开
     report_type	//举报类型 1:举报用户  2:举报图片
     */
    vc.other_xidStr = _userInfo.userId;
    vc.report_type = @"1";
    
    [self.navigationController pushViewController:vc animated:YES];

}

//- (void)deleteButtonClick:(UIButton *)button{
//
//        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除好友？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
//    
//        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //删除 好友
//            [self deleteFriend];
//
//        }];
//        [alert addAction:ok];
//        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:nil];
//
//
//}
//
//- (void)deleteFriend{
//    NSString *otherXid = _userInfo.userId;
//    XXERongCloudDeleteFriendApi *rongCloudDeleteFriendApi = [[XXERongCloudDeleteFriendApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXid];
//    [rongCloudDeleteFriendApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
//        //      NSLog(@"2222---   %@", request.responseJSONObject);
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//
//        if ([codeStr isEqualToString:@"1"]) {
//            [self showHudWithString:@"删除成功!" forSecond:1.5];
//            
//            NSDictionary *notiDic = [NSDictionary dictionaryWithObject:otherXid forKey:@"DeleteXid"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:self userInfo:notiDic];
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }else{
//            [self showHudWithString:@"删除失败!" forSecond:1.5];
//        }
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        
//        [self showString:@"数据请求失败" forSecond:1.f];
//    }];
//
//}

@end
