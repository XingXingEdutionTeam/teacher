//
//  DFTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"

#import "DFBaseTimeLineViewController.h"

@interface DFTimeLineViewController : DFBaseTimeLineViewController

//添加到末尾
-(void) addItem:(DFBaseLineItem *) item;

//添加到头部
-(void) addItemTop:(DFBaseLineItem *) item;

//根据ID删除
-(void) deleteItem:(long long) itemId;

//赞
-(void) addLikeItem:(DFLineLikeItem *) likeItem itemId:(long long) itemId;

//取消点赞
- (void)cancelLikeItem:(DFLineLikeItem *)likeItem itemId:(long long)itemId;

//评论
-(void) addCommentItem:(DFLineCommentItem *) commentItem itemId:(long long) itemId replyCommentId:(long long) replyCommentId;
//删除评论
-(void)cancelCommentItem:(DFLineCommentItem *)commentItem itemId:(long long)itemId replyCommentId:(long long)replyCommentId;

//回调评论的时候的被评论人的XID
- (void)xxe_friendCirclePageCommentToWhoXid:(NSInteger)toWhoXid;

//发送图文
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images;

//选择地点
- (void)locationMessageText:(NSString *)text;
//选择给谁看
- (void)xxe_whoCanLookMessage:(NSString *)personLook;

//发送视频消息
-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *) screenShot;

@end
