//
//  XXEGlobalPermissionSettingApi.m
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEGlobalPermissionSettingApi.h"

#define URL @"http://www.xingxingedu.cn/Global/right_set_action"

@interface XXEGlobalPermissionSettingApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *other_xid;
@property (nonatomic, copy) NSString *action_name;
@property (nonatomic, copy) NSString *action_num;

@end

@implementation XXEGlobalPermissionSettingApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id other_xid:(NSString *)other_xid action_name:(NSString *)action_name action_num:(NSString *)action_num{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _other_xid = other_xid;
        _action_name = action_name;
        _action_num = action_num;
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
             @"other_xid":_other_xid,
             @"action_name":_action_name,
             @"action_num":_action_num
             };
    
}


@end
