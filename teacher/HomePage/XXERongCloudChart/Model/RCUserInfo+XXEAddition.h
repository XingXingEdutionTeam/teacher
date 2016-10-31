//
//  RCUserInfo+XXEAddition.h
//  teacher
//
//  Created by Mac on 16/10/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCUserInfo (XXEAddition)

/**
 用户信息类
 */
/** 用户ID */
@property(nonatomic, strong) NSString *userId;
/** 用户名*/
@property(nonatomic, strong) NSString *name;
/** 头像URL*/
@property(nonatomic, strong) NSString *portraitUri;
/** QQ*/
@property(nonatomic, strong) NSString *QQ;

/** sex*/
@property(nonatomic, strong) NSString *sex;

/** 用户头像的来源 */
//@property (nonatomic, copy)NSString *head_img_type;
/** 用户年龄 */
@property (nonatomic, copy)NSString *age;


/**
 
 指派的初始化方法，根据给定字段初始化实例
 
 @param userId          用户ID
 @param username        用户名
 @param portrait        头像URL
 @param phone           电话
 @param addressInfo     addressInfo
 */
- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)username portrait:(NSString *)portrait QQ:(NSString *)QQ sex:(NSString *)sex age:(NSString *)age;

@end
