

//
//  XXEModifyCodeApi.m
//  teacher
//
//  Created by Mac on 16/10/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEModifyCodeApi.h"

#define URL @"http://www.xingxingedu.cn/Global/edit_pass"

@interface XXEModifyCodeApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *old_pass;
@property (nonatomic, copy) NSString *nowPass;
@property (nonatomic, copy) NSString *action_type;

@end


@implementation XXEModifyCodeApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id old_pass:(NSString *)old_pass new_pass:(NSString *)new_pass action_type:(NSString *)action_type{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _old_pass = old_pass;
        _nowPass = new_pass;
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
             @"old_pass":_old_pass,
             @"new_pass":_nowPass,
             @"action_type":_action_type
             };
    
}


@end
