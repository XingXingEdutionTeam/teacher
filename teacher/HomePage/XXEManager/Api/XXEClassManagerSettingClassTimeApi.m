//
//  XXEClassManagerSettingClassTimeApi.m
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerSettingClassTimeApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/edit_school_term_tm"


@interface XXEClassManagerSettingClassTimeApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *term_start_tm_s;
@property (nonatomic, copy) NSString *term_end_tm_s;
@property (nonatomic, copy) NSString *term_start_tm_a;
@property (nonatomic, copy) NSString *term_end_tm_a;

@end

@implementation XXEClassManagerSettingClassTimeApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id position:(NSString *)position term_start_tm_s:(NSString *)term_start_tm_s term_end_tm_s:(NSString *)term_end_tm_s term_start_tm_a:(NSString *)term_start_tm_a term_end_tm_a:(NSString *)term_end_tm_a{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _position = position;
        _term_start_tm_s = term_start_tm_s;
        _term_end_tm_s = term_end_tm_s;
        _term_start_tm_a = term_start_tm_a;
        _term_end_tm_a = term_end_tm_a;
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
             @"position":_position,
             @"term_start_tm_s": _term_start_tm_s,
             @"term_end_tm_s": _term_end_tm_s,
             @"term_start_tm_a": _term_start_tm_a,
             @"term_end_tm_a": _term_end_tm_a
             };
    
}


@end
