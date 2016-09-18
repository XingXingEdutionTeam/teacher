

//
//  XXENotificationAgainstOrSupportApi.m
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXENotificationAgainstOrSupportApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/school_notice_action"

@interface XXENotificationAgainstOrSupportApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *notice_id;
@property (nonatomic, copy) NSString *action_type;


@end


@implementation XXENotificationAgainstOrSupportApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id notice_id:(NSString *)notice_id action_type:(NSString *)action_type{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _notice_id = notice_id;
        _action_type = action_type;

    }
    return self;
}


- (NSString *)requestUrl{
    return URL;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}

- (id)requestArgument{
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"notice_id":_notice_id,
             @"action_type":_action_type
             };
}


@end
