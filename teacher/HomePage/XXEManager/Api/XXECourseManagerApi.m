
//
//  XXECourseManagerApi.m
//  teacher
//
//  Created by Mac on 16/9/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/edit_course_list"


@interface XXECourseManagerApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *condit;
@property (nonatomic, copy) NSString *page;

@end

@implementation XXECourseManagerApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id condit:(NSString *)condit page:(NSString *)page{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _condit = condit;
        _page = page;
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
             @"condit":_condit,
             @"page":_page
             };
    
}


@end
