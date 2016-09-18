

//
//  XXESchoolNotificationApi.m
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolNotificationApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/school_notice"

@interface XXESchoolNotificationApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *page;

@end

@implementation XXESchoolNotificationApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id class_id:(NSString *)class_id school_id:(NSString *)school_id position:(NSString *)position page:(NSString *)page{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _class_id = class_id;
        _school_id = school_id;
        _position = position;
        _page = page;
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
             @"class_id":_class_id,
             @"school_id":_school_id,
             @"position":_position,
             @"page":_page
             };
}


@end
