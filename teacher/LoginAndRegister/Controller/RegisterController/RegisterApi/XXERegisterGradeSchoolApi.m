//
//  XXERegisterGradeSchoolApi.m
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterGradeSchoolApi.h"

@implementation XXERegisterGradeSchoolApi{
    
    NSString *_school_id;
    NSString *_school_type;
}

- (id)initWithGetOutSchoolGradeSchoolId:(NSString *)schoolId SchoolType:(NSString *)schoolType
{
    self = [super init];
    if (self) {
        _school_id = schoolId;
        _school_type = schoolType;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXESearchGradeUrl];
}

- (id)requestArgument
{
    return @{@"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"school_id":_school_id,
             @"school_type":_school_type
             };
}




@end
