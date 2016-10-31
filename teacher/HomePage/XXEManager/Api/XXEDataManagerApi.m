
//
//  XXEDataManagerApi.m
//  teacher
//
//  Created by Mac on 16/10/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEDataManagerApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/manage_data"


@interface XXEDataManagerApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *school_type;
@property (nonatomic, copy) NSString *data_type;

@end

@implementation XXEDataManagerApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id school_type:(NSString *)school_type data_type:(NSString *)data_type{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        
        _school_id = school_id;
        _school_type = school_type;
        _data_type = data_type;
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
             @"data_type":_data_type
             };
    
}


@end
