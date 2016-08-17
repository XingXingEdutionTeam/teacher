//
//  XXEVerifySMSApi.m
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEVerifySMSApi.h"

@implementation XXEVerifySMSApi{
    
    NSString *_phoneNum;
    NSString *_verifyNum;
}

- (id)initWithVerifySMSPhoneNum:(NSString *)phoneNum VerifyNum:(NSString *)verifyNum
{
    self = [super init];
    if (self) {
        _phoneNum = phoneNum;
        _verifyNum = verifyNum;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEVerifySMSUrl];
}

- (id)requestArgument
{
    return @{@"phone":_phoneNum,
             @"appkey":FreeSMSAPPKey,
             @"zone":@"86",
             @"code":_verifyNum
             };
}

@end
