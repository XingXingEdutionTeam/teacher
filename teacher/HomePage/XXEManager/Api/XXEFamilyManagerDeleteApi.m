
//
//  XXEFamilyManagerDeleteApi.m
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFamilyManagerDeleteApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/manage_parent_delete"


@interface XXEFamilyManagerDeleteApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *parent_id;

@end

@implementation XXEFamilyManagerDeleteApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id parent_id:(NSString *)parent_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _class_id = class_id;
        _parent_id = parent_id;
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
             @"class_id":_class_id,
             @"parent_id":_parent_id
             };
    
}


@end
