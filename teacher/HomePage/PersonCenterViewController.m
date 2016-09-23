//
//  PersonCenterViewController.m
//  RCIM
//
//  Created by codeDing on 16/3/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "WMConversationViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HHControl.h"
#import "RCAddFriendViewController.h"
#import "SVProgressHUD.h"
#import "XXEFriendMyCircleViewController.h"
#import "ReportPicViewController.h"
#import "XXEfriendListMdoel.h"

@interface PersonCenterViewController (){

    UIButton *chatButton;
    UIButton *seeFriendCirileButton;
    UIButton *blackButton;
    UIButton *reportButton;
    UIButton *deleteButton;
    
}


@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    if (self.friendModel==nil) {
//        self.showUserInfo = [RCIM sharedRCIM].currentUserInfo;
//    }

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);

    [self createContent];
    
    
}

- (void)createContent{

     //创建 头像 ,名称 ,xid
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kWidth, 80)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    NSString *headUrl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,self.friendModel.head_img];
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"DefaultHeader"]];
    [bgView addSubview:iconImageView];
    
    UILabel *nameLabel = [HHControl createLabelWithFrame:CGRectMake(100, 20, 150, 20) Font:14.0 Text:self.friendModel.nickname];
    [bgView addSubview:nameLabel];
    
    UILabel *xidLabel = [HHControl createLabelWithFrame:CGRectMake(100, 50, 200, 20) Font:14.0 Text:[NSString stringWithFormat:@"xid: %@", self.friendModel.xid]];
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
    
    /**
     删除
     */
    deleteButton = [HHControl createButtonWithFrame:CGRectMake((kWidth - buttonWidth) / 2, reportButton.frame.origin.y + reportButton.frame.size.height + 20 * kWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(deleteButtonClick:) Title:@"删   除"];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:deleteButton];
    

}

- (void)chatButttonClick:(UIButton *)button{
    if (self.friendModel) {
                WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
                _conversationVC.conversationType = ConversationType_PRIVATE;
        
                _conversationVC.targetId = self.friendModel.xid;
                _conversationVC.title = [NSString stringWithFormat:@"%@",self.friendModel.nickname];
                [self.navigationController pushViewController:_conversationVC animated:YES];
            }else{
                WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
                _conversationVC.conversationType = ConversationType_PRIVATE;
                _conversationVC.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
                _conversationVC.title = [NSString stringWithFormat:@"%@",[RCIM sharedRCIM].currentUserInfo.name];
                [self.navigationController pushViewController:_conversationVC animated:YES];
            }


}

- (void)seeFriendCirileButtonClick:(UIButton *)button{
    
    XXEFriendMyCircleViewController *viewVC = [[XXEFriendMyCircleViewController alloc]init];
    viewVC.otherXid = [self.friendModel.xid integerValue];
    viewVC.rootChat = @"从聊天界面过去";
    [self.navigationController pushViewController:viewVC animated:YES
     ];

}

- (void)blackButtonClick:(UIButton *)button{

        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定将好友加入黑名单？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showSuccessWithStatus:@"加入黑名单成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    

}


- (void)reportButtonClick:(UIButton *)button{

    ReportPicViewController * vc=[[ReportPicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)deleteButtonClick:(UIButton *)button{

        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除好友？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showSuccessWithStatus:@"删除好友成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];


}



@end
