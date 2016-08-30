//
//  XXEVerificationApi.m
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEVerificationApi.h"

@implementation XXEVerificationApi{
    NSString *_acion_page;
    NSString *_phone;
}

- (id)initWithVerificationCodeActionPage:(NSString *)actionPage phoneNum:(NSString *)phoneNum
{
    self = [super init];
    if (self) {
        _acion_page = actionPage;
        _phone = phoneNum;
    }
    return self;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEVerifyNumUrl];
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    return @{@"action_page":_acion_page,
             @"phone":_phone,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             };
}

@end
