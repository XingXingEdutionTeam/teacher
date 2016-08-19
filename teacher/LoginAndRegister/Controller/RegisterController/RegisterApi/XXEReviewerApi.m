//
//  XXEReviewerApi.m
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReviewerApi.h"

@implementation XXEReviewerApi{
    
    NSString *_school_id;
    NSString *_class_id;
}

- (id)initReviwerNameSchoolId:(NSString *)schoolId  classID:(NSString *)classID
{
    self = [super init];
    if (self) {
        _school_id = schoolId;
        _class_id = classID;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEReviewerUrl];
}

- (id)requestArgument
{
    return @{@"school_id":_school_id,
             @"class_id":_class_id,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE
             };
}

@end
