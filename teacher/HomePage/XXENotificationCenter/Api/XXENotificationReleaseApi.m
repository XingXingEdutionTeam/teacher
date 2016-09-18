
//
//  XXENotificationReleaseApi.m
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXENotificationReleaseApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/publish_school_notice"

@interface XXENotificationReleaseApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *notice_type;
@property (nonatomic, copy) NSString *examine_tid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *con;


@end

@implementation XXENotificationReleaseApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id position:(NSString *)position notice_type:(NSString *)notice_type examine_tid:(NSString *)examine_tid title:(NSString *)title con:(NSString *)con{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _class_id = class_id;
        _position = position;
        _notice_type = notice_type;
        _examine_tid = examine_tid;
        _title = title;
        _con = con;
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
             @"school_id":_school_id,
             @"class_id":_class_id,
             @"position":_position,
             @"notice_type":_notice_type,
             @"examine_tid":_examine_tid,
             @"title":_title,
             @"con":_con
             };
}


@end
