

//
//  XXEClassManagerDeleteClassInfoApi.m
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerDeleteClassInfoApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/delete_class"


@interface XXEClassManagerDeleteClassInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;

@end


@implementation XXEClassManagerDeleteClassInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id class_id:(NSString *)class_id school_id:(NSString *)school_id position:(NSString *)position{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        
        _class_id = class_id;
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
             @"class_id":_class_id,
             @"school_id":_school_id,
             @"position":_position
             };
    
}

@end
