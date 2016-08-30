//
//  XXERegisterClassSchoolApi.m
//  teacher
//
//  Created by codeDing on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterClassSchoolApi.h"

@implementation XXERegisterClassSchoolApi{
    NSString *_schoolId;
    NSString *_grade;
    NSString *_courseId;
}

- (id)initWithClassMessageSchoolId:(NSString *)schoolId Grade:(NSString *)grade CourseId:(NSString *)courseId
{
    self = [super init];
    if (self) {
        _schoolId = schoolId;
        _grade = grade;
        _courseId = courseId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXESearchClassUrl];
}

- (id)requestArgument
{
    return @{@"school_id":_schoolId,
             @"grade":_grade,
             @"course_id":_courseId,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE
             };
}

@end
