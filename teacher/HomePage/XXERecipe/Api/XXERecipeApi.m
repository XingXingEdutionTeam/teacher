



//
//  XXERecipeApi.m
//  teacher
//
//  Created by Mac on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeApi.h"

#define URL @"http://www.xingxingedu.cn/Parent/school_cookbook"

@interface XXERecipeApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;



@end


@implementation XXERecipeApi

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
