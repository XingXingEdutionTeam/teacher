


//
//  XXEChiefAndTeacherApi.m
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEChiefAndTeacherApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/baby_list_oneclass"

@interface XXEChiefAndTeacherApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;


@end


@implementation XXEChiefAndTeacherApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _school_id = school_id;
        _class_id = class_id;
    }
    return self;
}


- (NSString *)requestUrl{

    return URL;
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}


/*
 return @{@"url":_url,
 @"appkey":_appkey,
 @"backtype":_backtype,
 @"xid":_xid,
 @"user_id":_user_id,
 @"user_type":_user_type,
 @"page":_page
 };
 */

- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"school_id":_school_id,
             @"class_id":_class_id
             };
    
}


@end
