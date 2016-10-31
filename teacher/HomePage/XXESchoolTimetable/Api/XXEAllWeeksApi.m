

//
//  XXEAllWeeksApi.m
//  teacher
//
//  Created by Mac on 16/10/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAllWeeksApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/schedule_week_date"

@interface XXEAllWeeksApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;


@end

@implementation XXEAllWeeksApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
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

             };
    
}


@end
