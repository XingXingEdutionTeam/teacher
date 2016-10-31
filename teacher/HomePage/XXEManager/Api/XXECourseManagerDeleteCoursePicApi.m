


//
//  XXECourseManagerDeleteCoursePicApi.m
//  teacher
//
//  Created by Mac on 16/9/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerDeleteCoursePicApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/course_pic_delete"


@interface XXECourseManagerDeleteCoursePicApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *course_id;
@property (nonatomic, copy) NSString *pic_id;

@end



@implementation XXECourseManagerDeleteCoursePicApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id course_id:(NSString *)course_id pic_id:(NSString *)pic_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _course_id = course_id;
        _pic_id = pic_id;
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
             @"course_id":_course_id,
             @"pic_id":_pic_id
             };
    
}



@end
