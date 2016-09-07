
//
//  XXEStudentSignInListApi.m
//  teacher
//
//  Created by Mac on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentSignInListApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/sign_part_list"


@interface XXEStudentSignInListApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *sign_type;


@end

@implementation XXEStudentSignInListApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id class_id:(NSString *)class_id school_id:(NSString *)school_id date_tm:(NSString *)date_tm sign_type:(NSString *)sign_type{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _class_id = class_id;
        _school_id = school_id;
        _date_tm = date_tm;
        _sign_type = sign_type;
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
             @"user_type":USER_TYPE,
             @"class_id":_class_id,
             @"school_id":_school_id,
             @"date_tm":_date_tm,
             @"sign_type":_sign_type
             };
}


@end
