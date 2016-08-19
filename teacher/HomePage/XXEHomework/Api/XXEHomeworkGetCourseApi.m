
//
//  XXEHomeworkGetCourseApi.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeworkGetCourseApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/class_teacher_teach"

@interface XXEHomeworkGetCourseApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@end


@implementation XXEHomeworkGetCourseApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type page:(NSString *)page{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
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
             @"user_type":_user_type
             };
    
}


@end
