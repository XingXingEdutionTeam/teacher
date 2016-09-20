


//
//  XXETeacherManagerRefuseApi.m
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETeacherManagerRefuseApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/manage_teacher_refuse_action"


@interface XXETeacherManagerRefuseApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *examine_id;

@end

@implementation XXETeacherManagerRefuseApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id examine_id:(NSString *)examine_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _examine_id = examine_id;
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
             @"examine_id":_examine_id
             };
    
}


@end
