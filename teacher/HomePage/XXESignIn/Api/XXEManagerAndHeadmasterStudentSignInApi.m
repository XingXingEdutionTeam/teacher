

//
//  XXEManagerAndHeadmasterStudentSignInApi.m
//  teacher
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEManagerAndHeadmasterStudentSignInApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/sign_in_school_count"


@interface XXEManagerAndHeadmasterStudentSignInApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *school_id;

@end


@implementation XXEManagerAndHeadmasterStudentSignInApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type date_tm:(NSString *)date_tm school_id:(NSString *)school_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _date_tm = date_tm;
        _school_id = school_id;
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
             @"date_tm":_date_tm,
             @"school_id":_school_id
             };
}


@end
