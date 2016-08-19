


//
//  XXECommentTextInfoApi.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentTextInfoApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/teacher_comment_action"

@interface XXECommentTextInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *com_con;

@end


@implementation XXECommentTextInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id baby_id:(NSString *)baby_id com_con:(NSString *)com_con{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _school_id = school_id;
        _class_id = class_id;
        _baby_id = baby_id;
        _com_con = com_con;
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
             @"school_id":_school_id,
             @"class_id":_class_id,
             @"baby_id":_baby_id,
             @"com_con":_com_con
             };

    
}


@end
