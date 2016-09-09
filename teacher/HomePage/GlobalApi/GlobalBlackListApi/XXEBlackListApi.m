

//
//  XXEBlackListApi.m
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBlackListApi.h"

#define URL @"http://www.xingxingedu.cn/Global/black_user_list"

@interface XXEBlackListApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@end


@implementation XXEBlackListApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
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
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE
             };
    
}


@end
