//
//  XXEVertifyTimesApi.m
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEVertifyTimesApi.h"

@implementation XXEVertifyTimesApi{
    
    NSString *_actionPage;
    NSString *_phoneNum;
}

- (id)initWithVertifyTimesActionPage:(NSString *)actionPage PhoneNum:(NSString *)phoneNum
{
    self =[super init];
    if (self) {
        _actionPage = actionPage;
        _phoneNum = phoneNum;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEVerifyTimesUrl];
}

- (id)requestArgument
{
    return @{@"action_page":_actionPage,
             @"phone":_phoneNum,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE
             };
}
@end
