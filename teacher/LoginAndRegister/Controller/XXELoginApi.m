//
//  XXELoginApi.m
//  teacher
//
//  Created by codeDing on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXELoginApi.h"

@implementation XXELoginApi{
    NSString *_userName;
    NSString *_password;
}
- (id)initLoginWithUserName:(NSString *)userName PassWord:(NSString *)password
{
    self = [super init];
    if (self) {
        _userName = userName;
        _password = password;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXELoginUrl];
}

- (id)requestArgument
{
    return @{@"account":_userName,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"pass":_password,
             @"lng":@"121.63251801",
             @"lat":@"31.28547800",
             @"login_type":@"1"
             };
}

@end
