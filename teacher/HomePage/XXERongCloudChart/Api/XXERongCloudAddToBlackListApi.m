
//
//  XXERongCloudAddToBlackListApi.m
//  teacher
//
//  Created by Mac on 16/10/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudAddToBlackListApi.h"

#define URL @"http://www.xingxingedu.cn/Global/user_add_black"


@interface XXERongCloudAddToBlackListApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *other_xid;


@end

@implementation XXERongCloudAddToBlackListApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id other_xid:(NSString *)other_xid{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _other_xid = other_xid;
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
             @"other_xid":_other_xid
             };
    
}


@end
