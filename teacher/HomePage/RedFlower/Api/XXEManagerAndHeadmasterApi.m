


//
//  XXEManagerAndHeadmasterApi.m
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEManagerAndHeadmasterApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/baby_list_allclass"

@interface XXEManagerAndHeadmasterApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;
@property (nonatomic, copy) NSString *school_id;

@end


@implementation XXEManagerAndHeadmasterApi

/*
 //管理员和校长 调用 下面接口
 【学生列表(某个学校所有班级)】多个模块用到此接口
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/baby_list_allclass
 
 传参:
 
 school_id	//学校id
 */
- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
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
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"school_id":_school_id
             };
    
}


@end
