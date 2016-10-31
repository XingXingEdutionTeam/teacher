

//
//  XXESchoolTimetableTimeApi.m
//  teacher
//
//  Created by Mac on 16/10/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableTimeApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/schedule_time"

@interface XXESchoolTimetableTimeApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *week_date;

@end

@implementation XXESchoolTimetableTimeApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id week_date:(NSString *)week_date{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _week_date = week_date;
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
             @"week_date":_week_date
             };
    
}


@end
