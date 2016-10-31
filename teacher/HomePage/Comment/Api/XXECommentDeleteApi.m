

//
//  XXECommentDeleteApi.m
//  teacher
//
//  Created by Mac on 16/10/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentDeleteApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/delete_teacher_com"


@interface XXECommentDeleteApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *com_id;



@end

@implementation XXECommentDeleteApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id com_id:(NSString *)com_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _com_id = com_id;
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
             @"com_id":_com_id
             };
    
}


@end
