
//
//  XXEMyselfInfoCollectionRedFlowerApi.m
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionRedFlowerApi.h"

#define URL @"http://www.xingxingedu.cn/Global/col_flower_list"

@interface XXEMyselfInfoCollectionRedFlowerApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *return_param_all;


@end

@implementation XXEMyselfInfoCollectionRedFlowerApi
- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id page:(NSString *)page return_param_all:(NSString *)return_param_all{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _page = page;
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
             @"page":_page,
             @"return_param_all":_return_param_all
             };
    
}

@end
