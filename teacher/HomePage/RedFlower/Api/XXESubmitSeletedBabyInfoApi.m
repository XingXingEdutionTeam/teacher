

//
//  XXESubmitSeletedBabyInfoApi.m
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESubmitSeletedBabyInfoApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/action_give_flower"

@interface XXESubmitSeletedBabyInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *baby_info;
@property (nonatomic, copy) NSString *con;

@end


@implementation XXESubmitSeletedBabyInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type position:(NSString *)position baby_info:(NSString *)jsonString con:(NSString *)con{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _position = position;
        _baby_info = jsonString;
        _con = con;
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
             @"position":_position,
             @"baby_info":_baby_info,
             @"con":_con
             };
    
}


@end
