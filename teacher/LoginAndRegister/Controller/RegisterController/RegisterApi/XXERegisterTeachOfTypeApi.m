//
//  XXERegisterTeachOfTypeApi.m
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterTeachOfTypeApi.h"

@implementation XXERegisterTeachOfTypeApi{
    NSString *_schoolType;
}

- (id)initWithRegisTeachTypeSchoolType:(NSString *)schoolType
{
    self = [super init];
    if (self) {
        _schoolType = schoolType;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXERegisTeachTypeUrl];
}


- (id)requestArgument
{
    return @{@"school_type":_schoolType,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE};
}

@end
