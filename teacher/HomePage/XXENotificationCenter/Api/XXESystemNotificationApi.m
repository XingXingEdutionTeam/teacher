

//
//  XXESystemNotificationApi.m
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESystemNotificationApi.h"

#define URL @"http://www.xingxingedu.cn/Global/official_notice"

@interface XXESystemNotificationApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *app_type;
@property (nonatomic, copy) NSString *page;

@end


@implementation XXESystemNotificationApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id app_type:(NSString *)app_type page:(NSString *)page{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _app_type = app_type;
        _page = page;
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
             @"app_type":_app_type,
             @"page":_page
             };
}


@end
