


//
//  XXETeacherManagerDeleteApi.m
//  teacher
//
//  Created by Mac on 2016/12/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETeacherManagerDeleteApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/manage_teacher_delete"


@interface XXETeacherManagerDeleteApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *examine_id;

@property (nonatomic, copy) NSString *return_param_all;

@end


@implementation XXETeacherManagerDeleteApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id examine_id:(NSString *)examine_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _class_id = class_id;
        _examine_id = examine_id;
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
             @"examine_id":_examine_id,
             @"return_param_all":@""
             };
    
}


@end
