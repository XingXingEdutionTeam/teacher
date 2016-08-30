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
    NSString *_position;
}

- (id)initReviwerNameSchoolId:(NSString *)schoolId  PositionID:(NSString *)positionId
{
    self = [super init];
    if (self) {
        _school_id = schoolId;
        _position = positionId;
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
             @"position":_position,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_type":USER_TYPE
             };
}

@end
