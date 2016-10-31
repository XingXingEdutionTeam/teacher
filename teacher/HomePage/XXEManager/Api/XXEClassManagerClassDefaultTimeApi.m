
//
//  XXEClassManagerClassDefaultTimeApi.m
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerClassDefaultTimeApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/school_term_tm"


@interface XXEClassManagerClassDefaultTimeApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;

@end

@implementation XXEClassManagerClassDefaultTimeApi


- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id position:(NSString *)position{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        
        _school_id = school_id;
        _position = position;
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
             @"school_id":_school_id,
             @"position":_position
             };
    
}


@end
