//
//  XXERegisterSearchSchoolApi.m
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterSearchSchoolApi.h"

@implementation XXERegisterSearchSchoolApi{
    
    NSString *_schoolName;
}

- (id)initWithRegisterSearchSchoolName:(NSString *)schoolName{
    self = [super init];
    if (self) {
        _schoolName = schoolName;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXESearchSchoolUrl];
}

- (id)requestArgument
{
    return @{@"search_words":_schoolName,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE
             };
}

@end
