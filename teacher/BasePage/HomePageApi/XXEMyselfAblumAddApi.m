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
    NSString *_albumXid;
    NSString *_albumUserId;
    NSString *_position;
}

- (id)initWithAddMyselfAblumSchoolId:(NSString *)schoolId ClassId:(NSString *)classId AlbumName:(NSString *)albumname AlbumXid:(NSString *)albumXid AlbumUserId:(NSString *)albumUserId position:(NSString *)position
{
    self = [super init];
    if (self) {
        _schoolId = schoolId;
        _classId = classId;
        _albumname = albumname;
        _albumXid = albumXid;
        _albumUserId = albumUserId;
        _position = position;
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
             @"user_id":_albumUserId,
             @"user_type":USER_TYPE,
             @"xid":_albumXid,
             @"position":_position
             };
}

@end
