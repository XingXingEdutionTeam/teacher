

//
//  XXESchoolTimetableCourseDeleteApi.m
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableCourseDeleteApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/schedule_teacher_delete"

@interface XXESchoolTimetableCourseDeleteApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *schedule_id;

@end

@implementation XXESchoolTimetableCourseDeleteApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id schedule_id:(NSString *)schedule_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _schedule_id = schedule_id;
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
             @"schedule_id":_schedule_id
             };
    
}


@end
