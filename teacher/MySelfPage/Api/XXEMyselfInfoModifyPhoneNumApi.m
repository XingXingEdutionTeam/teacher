
//
//  XXEMyselfInfoModifyPhoneNumApi.m
//  teacher
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoModifyPhoneNumApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/edit_my_info"

@interface XXEMyselfInfoModifyPhoneNumApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *phone;


@end


@implementation XXEMyselfInfoModifyPhoneNumApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type phone:(NSString *)phone{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _phone = phone;
        
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
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"phone":_phone
             };
    
}


@end
