//
//  XXEHomePageApi.m
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageApi.h"

@implementation XXEHomePageApi{

    NSString *_xid;
}

- (id)initWithHomePageXid:(NSString *)xid
{
    self = [super init];
    if (self) {
        _xid = xid;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEHomePageUrl];
}

- (id)requestArgument
{
    return @{@"xid":_xid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
//             @"login_type":@"1",//1为手机号 2 .3.4.5 分别为第三放登录
             @"user_id":@"1",
             @"user_type":@"2"
             };
}

@end
