
//
//  XXESchoolTimetableCourseApi.m
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableCourseApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/schedule_detail"

@interface XXESchoolTimetableCourseApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *week_date;
@property (nonatomic, copy) NSString *parame_data;

@end


@implementation XXESchoolTimetableCourseApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id week_date:(NSString *)week_date parame_data:(NSString *)parame_data{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _week_date = week_date;
        _parame_data = parame_data;
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
             @"week_date":_week_date,
             @"parame_data":_parame_data
             };
    
}


@end
