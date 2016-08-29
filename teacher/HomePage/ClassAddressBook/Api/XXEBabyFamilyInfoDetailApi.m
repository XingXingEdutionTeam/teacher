

//
//  XXEBabyFamilyInfoDetailApi.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBabyFamilyInfoDetailApi.h"

#define URL @"http://www.xingxingedu.cn/Parent/parent_detail"


@interface XXEBabyFamilyInfoDetailApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *baby_id;

@property (nonatomic, copy) NSString *parent_id;

@end


@implementation XXEBabyFamilyInfoDetailApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type baby_id:(NSString *)baby_id parent_id:(NSString *)parent_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _baby_id = baby_id;
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
             @"user_type":_user_type,
             @"baby_id":_baby_id,
             @"parent_id":_parent_id
             };
    
}


@end
