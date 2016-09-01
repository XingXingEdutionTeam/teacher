//
//  XXEHomeIdentityApi.m
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeIdentityApi.h"

@implementation XXEHomeIdentityApi{
    NSString *_userXid;
    NSString *_userId;
}

- (id)initWithHomeIdentityUserXid:(NSString *)userXid UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _userXid = userXid;
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
    return [NSString stringWithFormat:@"%@",XXEHomePageIdentityUrl];
}

- (id)requestArgument
{
    return @{@"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_type":USER_TYPE,
             @"xid":_userXid,
             @"user_id":_userId};
}

@end
