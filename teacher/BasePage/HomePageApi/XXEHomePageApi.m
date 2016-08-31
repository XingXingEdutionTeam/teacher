//
//  XXEHomePageApi.m
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageApi.h"

@implementation XXEHomePageApi{

    NSString *_UserXid;
    NSString *_userType;
    NSString *_userId;
}

- (id)initWithHomePageXid:(NSString *)xid UserType:(NSString *)userType UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _UserXid = xid;
        _userType = userType;
        _userId = userId;
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
    return @{@"xid":_UserXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":_userType
             };
}

@end
