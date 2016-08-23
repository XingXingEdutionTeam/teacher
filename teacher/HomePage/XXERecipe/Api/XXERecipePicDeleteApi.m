

//
//  XXERecipePicDeleteApi.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipePicDeleteApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/cookbook_pic_delete"

@interface XXERecipePicDeleteApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *pic_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *cookbook_id;


@end


@implementation XXERecipePicDeleteApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type pic_id:(NSString *)pic_id position:(NSString *)position cookbook_id:(NSString *)cookbook_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _pic_id = pic_id;
        _position = position;
        _cookbook_id = cookbook_id;
        
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
             @"pic_id":_pic_id,
             @"position":_position,
             @"cookbook_id":_cookbook_id
             };
    
}


@end
