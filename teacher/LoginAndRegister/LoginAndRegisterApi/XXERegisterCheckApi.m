//
//  XXERegisterCheckApi.m
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterCheckApi.h"

@implementation XXERegisterCheckApi{
    
    NSString *_phoneNumber;
}

- (id)initWithChechPhoneNumber:(NSString *)phoneNumber
{
    self = [super init];
    if (self) {
        _phoneNumber = phoneNumber;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXERegisterCheckUrl];
}

- (id)requestArgument
{
    return @{
             @"phone":_phoneNumber,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             
             };
}

@end
