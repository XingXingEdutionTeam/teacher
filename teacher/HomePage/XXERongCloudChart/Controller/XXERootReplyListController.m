//
//  XXERootReplyListController.m
//  teacher
//
//  Created by codeDing on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERootReplyListController.h"
#import "WMConversationViewController.h"
#import "AppDelegate.h"
#import "XXERCCustomCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XXERCDataManager.h"
#import "XXERongCloudJudgePositionApi.h"
#import "XXERongCloudAddFriendRequestApi.h"
#import "SVProgressHUD.h"
#import "XXERongCloudAddFriendsListViewController.h"
#import "KxMenu.h"

@interface XXERootReplyListController ()<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *replyListArray;
    
    //
    NSString *deleteXid;
    
    //点击  某一个 cell ,找他聊天,他的xid
    NSString *otherXid;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;

}

@property (nonatomic,strong) RCConversationModel *tempModel;

@property (nonatomic,assign) BOOL isClick;


- (void) updateBadgeValueForTabBarItem;


@end

@implementation XXERootReplyListController

/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
        [RCIM sharedRCIM].receiveMessageDelegate = self;
        [RCIM sharedRCIM].connectionStatusDelegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriend:) name:@"delete" object:nil];
    
    [[XXERCDataManager shareManager] refreshBadgeValue];
    [self.conversationListTableView reloadData];

}

- (void)deleteFriend:(NSNotification *)noti{
//    NSLog(@" -- %@", noti.userInfo[@"DeleteXid"]);
    
    deleteXid = noti.userInfo[@"DeleteXid"];
    if (deleteXid != nil && self.conversationListDataSource.count != 0) {
        
//        NSLog(@"self.conversationListDataSource -- %@", self.conversationListDataSource);
        
        for (RCConversationModel *model in self.conversationListDataSource) {
            if ([model.targetId isEqualToString:deleteXid]) {
                
                replyListArray = [NSMutableArray arrayWithArray:self.conversationListDataSource];
                
                NSInteger index = [self.conversationListDataSource indexOfObject:model];
                
                [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
                [replyListArray removeObjectAtIndex:index];
                
                
                self.conversationListDataSource = replyListArray;
                NSLog(@"nnnn %@", self.conversationListDataSource);
                
                [self.conversationListTableView reloadData];
                [[XXERCDataManager shareManager] refreshBadgeValue];
                
            }
        }
    }

}


- (BOOL)removeConversation:(RCConversationType)conversationType
                  targetId:(NSString *)targetId{

    return YES;
}



- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"delete" object:nil];
}

/*!
 接收消息的回调方法
 *
 */
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{

    for (RCUserInfo *userInfo in [AppDelegate shareAppDelegate].friendsArray) {
        if ([message.senderUserId isEqualToString:userInfo.userId]) {
    
            NSLog(@" onRCIMReceiveMessage %@",message.content);
            [[XXERCDataManager shareManager] refreshBadgeValue];
            [self.conversationListTableView reloadData];
        }
    }
    
}
    
#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"RCConnectionStatus = %ld",(long)status);
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"您的帐号已在别的设备上登录，\n您被迫下线！"
                              delegate:self
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];

        
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[RCIMClient sharedRCIMClient] disconnect:YES];
    }];
    
    
}
#pragma mark
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    self.navigationController.title=@"会话列表";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.conversationListTableView.tableFooterView = [UIView new];
    
    [self  setNavigation];
}

- (void)setNavigation {
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"rcim3.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenu:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.tabBarController.navigationItem.rightBarButtonItem= rightItem;
    
    self.tabBarController.navigationItem.title=@"聊天";
}

#pragma mark - 导航栏的按钮点击
- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems = @[[KxMenuItem menuItem:@"添加好友" image:[UIImage imageNamed:@"tianjiahaoyou"] target:self action:@selector(pushAddFriend:)]];//[KxMenuItem menuItem:@"发起群聊" image:[UIImage imageNamed:@"faqiqunliao"] target:self action:@selector(pushGroupChat:)],
    CGRect targetFrame = self.tabBarController.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y +15;
    [KxMenu showMenuInView:self.tabBarController.navigationController.navigationBar.superview fromRect:targetFrame menuItems:menuItems];
}


//#pragma mark - 发起群聊---添加好友
//- (void)pushGroupChat:(UIButton *)sender
//{
//    NSLog(@"发起群聊");
//
//}

- (void)pushAddFriend:(UIButton *)sender
{
    //    NSLog(@"添加好友");
    XXERongCloudAddFriendsListViewController *rongCloudAddFriendsListVC = [[XXERongCloudAddFriendsListViewController alloc] init];
    
    [self.navigationController pushViewController:rongCloudAddFriendsListVC animated:YES];
}

#pragma mark
#pragma mark 禁止右滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
    [[XXERCDataManager shareManager] refreshBadgeValue];
}
//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyyMMdd";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
    
}
-(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
#pragma mark
#pragma mark onSelectedTableRow
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    //点击cell，拿到cell对应的model，然后从model中拿到对应的RCUserInfo，然后赋值会话属性，进入会话
    //先 判断 身份
    
    otherXid = model.targetId;
    [self judgePosition:model];
    
}

- (void)judgePosition:(RCConversationModel *)model{
    XXERongCloudJudgePositionApi *rongCloudJudgePositionApi = [[XXERongCloudJudgePositionApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXid];
    [rongCloudJudgePositionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
                      NSLog(@"2222---   %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        /*
         ★其他结果需提醒用户
         code:5	//不是好友,不能发起聊天,是否要添加好友?(触发添加好友请求接口)
         code:6	//对方设置了不接受您的消息!无法发起聊天!
         code:7	//你不在对方的好友名单中,是否要添加好友?
         */
        if ([codeStr isEqualToString:@"1"]) {
            
            [self startChart:model];
        }else if ([codeStr isEqualToString:@"5"]) {
            [SVProgressHUD showInfoWithStatus:@"不是好友,不能发起聊天!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addFriendRequest];
            });
            
        }else if ([codeStr isEqualToString:@"6"]) {
            [SVProgressHUD showInfoWithStatus:@"对方设置了不接受您的消息!无法发起聊天!"];
            
        }else if ([codeStr isEqualToString:@"7"]) {
            [SVProgressHUD showInfoWithStatus:@"你不在对方的好友名单中,不能发起聊天!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addFriendRequest];
            });
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [SVProgressHUD showInfoWithStatus:@"数据请求失败!"];
    }];
}

- (void)startChart:(RCConversationModel *)model{
    if (model.conversationType==ConversationType_PRIVATE) {//单聊
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        RCUserInfo *aUserInfo = [[XXERCDataManager shareManager] currentUserInfoWithUserId:model.targetId];
        _conversationVC.title =aUserInfo.name;
        [self.navigationController pushViewController:_conversationVC animated:YES];
        
    }else if (model.conversationType==ConversationType_GROUP){//群聊
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else if (model.conversationType==ConversationType_DISCUSSION){//讨论组
        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else if (model.conversationType==ConversationType_CHATROOM){//聊天室
        
    }else if (model.conversationType==ConversationType_APPSERVICE){//客服
        
    }
    
    
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
    
    XXERongCloudAddFriendRequestApi *rongCloudAddFriendRequestApi = [[XXERongCloudAddFriendRequestApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXid];
    [rongCloudAddFriendRequestApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //      NSLog(@"2222---   %@", request.responseJSONObject);
        
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
            [SVProgressHUD showInfoWithStatus:@"请求发送成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [SVProgressHUD showInfoWithStatus:@"不能请求自己!"];
            
        }else if ([codeStr isEqualToString:@"5"]) {
            [SVProgressHUD showInfoWithStatus:@"对方已经是您的好友!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addFriendRequest];
            });
        }else if ([codeStr isEqualToString:@"6"]) {
            [SVProgressHUD showInfoWithStatus:@"对方在我的黑名单中,无法发起请求!"];
            
        }else if ([codeStr isEqualToString:@"7"]) {
            [SVProgressHUD showInfoWithStatus:@"您已经在对方黑名单中,无法发起请求!"];
        }else if ([codeStr isEqualToString:@"8"]) {
            [SVProgressHUD showInfoWithStatus:@"不能重复对同一个人发起请求!"];
        }else if ([codeStr isEqualToString:@"9"]) {
            [SVProgressHUD showInfoWithStatus:@"对方已同意,可以直接聊天了!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"10"]) {
            [SVProgressHUD showInfoWithStatus:@"添加成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [SVProgressHUD showInfoWithStatus:@"请求发送失败!"];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [SVProgressHUD showInfoWithStatus:@"数据请求失败!"];
    }];
    
}

-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//        NSLog(@"KKKK%@", self.conversationListDataSource);
    XXERCCustomCellTableViewCell *cell = (XXERCCustomCellTableViewCell *)[[XXERCCustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXERCCustomCellTableViewCell"];
    
    if (self.conversationListDataSource.count && indexPath.row < self.conversationListDataSource.count) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
//     NSString *flagStr = @"0";
//NSLog(@"[AppDelegate shareAppDelegate].friendsArray  -----====--  %@", [AppDelegate shareAppDelegate].friendsArray);
        for (RCUserInfo *userInfo in [AppDelegate shareAppDelegate].friendsArray) {
            if ([model.targetId isEqualToString:userInfo.userId]) {
//                flagStr = @"1";
                
                NSLog(@"名称   %@", userInfo.name);
                NSLog(@"头像   %@", userInfo.portraitUri);
                NSLog(@"id     %@", userInfo.userId);
                
                [[XXERCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
                    
                    //            NSLog(@"rcConversationListTableView 名字 ＝ %@  ID ＝ %@ 头像 = %@",userInfo.name,userInfo.userId, userInfo.portraitUri);
                }];
                
                //======================= 时间 ==================
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.receivedTime/1000];
                NSString *timeString = [[self stringFromDate:date] substringToIndex:10];
                NSString *temp = [self getyyyymmdd];
                NSString *nowDateString = [NSString stringWithFormat:@"%@-%@-%@",[temp substringToIndex:4],[temp substringWithRange:NSMakeRange(4, 2)],[temp substringWithRange:NSMakeRange(6, 2)]];
                
                if ([timeString isEqualToString:nowDateString]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSString *showtimeNew = [formatter stringFromDate:date];
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@",showtimeNew];
                    
                }else{
                    cell.timeLabel.text = [NSString stringWithFormat:@"%@",timeString];
                }
                
                //================== 新消息 提示 图标 ================
                NSInteger unreadCount = model.unreadMessageCount;
                cell.ppBadgeView.dragdropCompletion = ^{
                    NSLog(@"VC = FFF ，ID ＝ %@",model.targetId);
                    
                    [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:model.targetId];
                    model.unreadMessageCount = 0;
                    NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
                    
                    long tabBarCount = ToatalunreadMsgCount-model.unreadMessageCount;
                    
                    if (tabBarCount > 0) {
                        [AppDelegate shareAppDelegate].tabbarVC.selectedViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",tabBarCount];
                    }
                    else {
                        [AppDelegate shareAppDelegate].tabbarVC.selectedViewController.tabBarItem.badgeValue = nil;
                    }
                };
                if (unreadCount==0) {
                    cell.ppBadgeView.text = @"";
                    
                }else{
                    if (unreadCount>=100) {
                        cell.ppBadgeView.text = @"99+";
                    }else{
                        cell.ppBadgeView.text = [NSString stringWithFormat:@"%li",(long)unreadCount];
                        
                    }
                }

                
                cell.nameLabel.text = [NSString stringWithFormat:@"%@",userInfo.name];
                if ([userInfo.portraitUri isEqualToString:@""]||userInfo.portraitUri==nil) {
                    cell.avatarIV.image = [UIImage imageNamed:@"headplaceholder"];
                    [cell.contentView bringSubviewToFront:cell.avatarIV];
                }else{
                    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
                }
                
                if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
                    cell.contentLabel.text = [model.lastestMessage valueForKey:@"content"];
                    
                }else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
                    
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
                        }else{
                            cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
                            
                        }
                    }else{
                        
                        cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",userInfo.name] ;
                    }
                    
                }else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
                            
                        }else{
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
                        }
                    }else{
                        cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",userInfo.name];
                    }
                }
                else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
                        }else{
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
                        }
                    }else{
                        cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",userInfo.name];
                    }
                }
                
            }
        }
        
        return cell;
    }else{
        
        return nil;
    }
    
    
}


#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    
    if ([message.content isMemberOfClass:[RCMessageContent class]]) {
        if (message.conversationType == ConversationType_PRIVATE) {
            NSLog(@"好友消息要发系统消息！！！");
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
        }
        RCConversationModel *customModel = [RCConversationModel new];
        //自定义cell的type
        customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        customModel.senderUserId = message.senderUserId;
        customModel.lastestMessage = message.content;
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            
        });
        
    }else if (message.conversationType == ConversationType_PRIVATE){
        //获取接受到会话
        RCConversation *receivedConversation = [[RCIMClient sharedRCIMClient] getConversation:message.conversationType targetId:message.targetId];
        
        //转换新会话为新会话模型
        RCConversationModel *customModel = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION conversation:receivedConversation extend:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            //[super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            NSNumber *left = [notification.userInfo objectForKey:@"left"];
            if (0 == left.integerValue) {
                [super refreshConversationTableViewIfNeeded];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //        super会调用notifyUpdateUnreadMessageCount
        });
    }
    [[XXERCDataManager shareManager] getUserInfoWithUserId:message.senderUserId completion:^(RCUserInfo *userInfo) {
//        NSLog(@"didReceiveMessageNotification 名字 ＝ %@  ID ＝ %@",userInfo.name,userInfo.userId);
    }];
    [self refreshConversationTableViewIfNeeded];
}

#pragma &&&&&&&&&&&&&& 显示 消息 条数 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return  self.conversationListDataSource.count;
}

- (void)showEmptyConversationView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
   UIImageView *placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

#pragma mark 删除会话的回调

/*!
 删除会话的回调
 @param model   会话Cell的数据模型
 */
//- (void)didDeleteConversationCell:(RCConversationModel *)model{
//
//    [self.conversationListDataSource removeObject:model];
//    [self.conversationListTableView reloadData];
//}



- (void) updateBadgeValueForTabBarItem{


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
