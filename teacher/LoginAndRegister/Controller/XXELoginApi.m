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
    NSString *_login_type;
    NSString *_lng;
    NSString *_lat;
}
- (id)initLoginWithUserName:(NSString *)userName PassWord:(NSString *)password LoginType:(NSString *)loginType Lng:(NSString *)lng Lat:(NSString *)lat
{
    self = [super init];
    if (self) {
        _userName = userName;
        _password = password;
        _login_type = loginType;
        _lng = lng;
        _lat = lat;
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
             @"lng":_lng,
             @"lat":_lat,
             @"login_type":_login_type
             };
}

@end
