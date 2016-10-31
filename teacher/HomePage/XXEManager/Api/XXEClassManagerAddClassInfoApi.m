

//
//  XXEClassManagerAddClassInfoApi.m
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerAddClassInfoApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/add_class"


@interface XXEClassManagerAddClassInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *school_type;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *classNum;
@property (nonatomic, copy) NSString *num_up;
@property (nonatomic, copy) NSString *teacher_boss;

@end


@implementation XXEClassManagerAddClassInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_type:(NSString *)school_type school_id:(NSString *)school_id position:(NSString *)position grade:(NSString *)grade class:(NSString *)classNum num_up:(NSString *)num_up teacher_boss:(NSString *)teacher_boss{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        
        _school_type = school_type;
        _school_id = school_id;
        _position = position;
        
        _grade = grade;
        _classNum = classNum;
        _num_up = num_up;
        _teacher_boss = teacher_boss;
        
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
             @"school_type":_school_type,
             @"school_id":_school_id,
             @"position":_position,
             @"grade": _grade,
             @"class": _classNum,
             @"num_up": _num_up,
             @"teacher_boss": _teacher_boss
             };
    
}


@end
