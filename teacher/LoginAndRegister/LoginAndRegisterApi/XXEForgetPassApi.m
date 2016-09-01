//
//  XXEForgetPassApi.m
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEForgetPassApi.h"

@implementation XXEForgetPassApi{
    
    NSString *_user_type;
    NSString *_phone;
    NSString *_new_pass;
}

- (id)initWithForgetPassWordUserType:(NSString *)user_type Phone:(NSString *)phone NewPass:(NSString *)newPass
{
    self = [super init];
    if (self) {
        _user_type = user_type;
        _phone = phone;
        _new_pass = newPass;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEForgetPassUrl];
}

- (id)requestArgument
{
    return @{@"user_type":_user_type,
             @"phone":_phone,
             @"new_pass":_new_pass,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE
             };
}
@end
