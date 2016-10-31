


//
//  XXECourseManagerCourseReleaseApi.m
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCourseReleaseApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/course_publish"


@interface XXECourseManagerCourseReleaseApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *publish_type;
@property (nonatomic, copy) NSString *course_id;
@property (nonatomic, copy) NSString *course_info;
@property (nonatomic, copy) NSString *course_tm;


@end

@implementation XXECourseManagerCourseReleaseApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id position:(NSString *)position school_id:(NSString *)school_id publish_type:(NSString *)publish_type course_id:(NSString *)course_id course_info:(NSString *)course_info course_tm:(NSString *)course_tm{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _position = position;
        _school_id = school_id;
        _publish_type = publish_type;
        _course_id = course_id;
        _course_info = course_info;
        _course_tm = course_tm;
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
             @"publish_type":_publish_type,
             @"course_id":_course_id,
             @"course_info":_course_info,
             @"course_tm":_course_tm
             };
    
}


@end
