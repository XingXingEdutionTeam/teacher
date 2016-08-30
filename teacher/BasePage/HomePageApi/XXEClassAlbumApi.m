//
//  XXEClassAlbumApi.m
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassAlbumApi.h"


@implementation XXEClassAlbumApi{
    NSString *_schoolId;
    NSString *_classId;
}

- (id)initWithClassAlbumSchoolID:(NSString *)schoolId classID:(NSString *)classId
{
    self = [super init];
    if (self) {
        _schoolId = schoolId;
        _classId = classId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEClassAlubmUrl];
}

- (id)requestArgument
{
    return @{@"school_id":_schoolId,
             @"class_id":_classId,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":USER_ID,
             @"user_type":USER_TYPE,
             @"xid":XID
             };
}

@end
