//
//  XXEMyselfAblumAddApi.m
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfAblumAddApi.h"

@implementation XXEMyselfAblumAddApi{
    NSString *_schoolId;
    NSString *_classId;
    NSString *_albumname;
}

- (id)initWithAddMyselfAblumSchoolId:(NSString *)schoolId ClassId:(NSString *)classId AlbumName:(NSString *)albumname
{
    self = [super init];
    if (self) {
        _schoolId = schoolId;
        _classId = classId;
        _albumname = albumname;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEMySelfAlubmAddUrl];
}

- (id)requestArgument
{
    return @{@"school_id":_schoolId,
             @"class_id":_classId,
             @"album_name":_albumname,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":USER_ID,
             @"user_type":USER_TYPE,
             @"xid":XID
             };
}

@end
