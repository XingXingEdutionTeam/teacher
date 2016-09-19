
//
//  XXEStudentManagerMoveApi.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentManagerMoveApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/manage_baby_move"


@interface XXEStudentManagerMoveApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *move_class_id;

@end


@implementation XXEStudentManagerMoveApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id class_id:(NSString *)class_id baby_id:(NSString *)baby_id move_class_id:(NSString *)move_class_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _class_id = class_id;
        _baby_id = baby_id;
        _move_class_id = move_class_id;
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
             @"baby_id":_baby_id,
             @"move_class_id":_move_class_id
             };
    
}


@end
