

//
//  XXEFamilyManagerApi.m
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFamilyManagerApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/manage_parent_list"


@interface XXEFamilyManagerApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *school_type;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *position;

@end


@implementation XXEFamilyManagerApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id school_type:(NSString *)school_type class_id:(NSString *)class_id position:(NSString *)position{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _school_type = school_type;
        _class_id = class_id;
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
             @"school_type":_school_type,
             @"class_id":_class_id,
             @"position":_position
             };
    
}


@end
