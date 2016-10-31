
//
//  XXECourseManagerSupportAndRefuseApi.m
//  teacher
//
//  Created by Mac on 16/9/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerSupportAndRefuseApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/course_examine_action"


@interface XXECourseManagerSupportAndRefuseApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *course_id;
@property (nonatomic, copy) NSString *action_type;

@end

@implementation XXECourseManagerSupportAndRefuseApi


- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id position:(NSString *)position school_id:(NSString *)school_id course_id:(NSString *)course_id action_type:(NSString *)action_type{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _position = position;
        _school_id = school_id;
        _course_id = course_id;
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
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"position":_position,
             @"school_id":_school_id,
             @"course_id":_course_id,
             @"action_type":_action_type
             };
    
}


@end
