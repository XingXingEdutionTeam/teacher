
//
//  XXEMyselfInfoDecollectionApi.m
//  teacher
//
//  Created by Mac on 16/10/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoDecollectionApi.h"

#define URL @"http://www.xingxingedu.cn/Global/deleteCollect"

@interface XXEMyselfInfoDecollectionApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *collect_id;
@property (nonatomic, copy) NSString *collect_type;
@property (nonatomic, copy) NSString *return_param_all;

@end

@implementation XXEMyselfInfoDecollectionApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id collect_id:(NSString *)collect_id collect_type:(NSString *)collect_type return_param_all:(NSString *)return_param_all{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _collect_id = collect_id;
        _collect_type = collect_type;
        _return_param_all = return_param_all;
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
             @"user_type":USER_TYPE,
             @"collect_id":_collect_id,
             @"collect_type":_collect_type,
             @"return_param_all":_return_param_all
             };
    
}


@end
