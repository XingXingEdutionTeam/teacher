

//
//  XXEStudentSingleSignApi.m
//  teacher
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentSingleSignApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/sign_in_one_action"


@interface XXEStudentSingleSignApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *position;

@end

@implementation XXEStudentSingleSignApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type class_id:(NSString *)class_id school_id:(NSString *)school_id baby_id:(NSString *)baby_id position:(NSString *)position{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _class_id = class_id;
        _school_id = school_id;
        _baby_id = baby_id;
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
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"class_id":_class_id,
             @"school_id":_school_id,
             @"baby_id":_baby_id,
             @"position":_position
             };
}


@end
