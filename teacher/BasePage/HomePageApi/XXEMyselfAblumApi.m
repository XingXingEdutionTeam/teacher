//
//  XXEMyselfAblumApi.m
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfAblumApi.h"

@implementation XXEMyselfAblumApi{
    NSString *_school_id;
    NSString *_class_id;
    NSString *_teacher_id;
    NSString *_albumXid;
    NSString *_albumUserId;
    NSString *_position;
}

- (id)initWithMyselfAblumSchoolId:(NSString *)schollId ClassId:(NSString *)classId TeacherId:(NSString *)teacherId AlbumXid:(NSString *)albumXid AlbumUserId:(NSString *)albumUserId;
{
    self = [super init];
    if (self) {
        _school_id = schollId;
        _class_id = classId;
        _teacher_id = teacherId;
        _albumXid = albumXid;
        _albumUserId = albumUserId;
      
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEMySelfAlubmUrl];
}

- (id)requestArgument
{
    return @{@"school_id":_school_id,
             @"class_id":_class_id,
             @"teacher_id":_teacher_id,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_albumUserId,
             @"user_type":USER_TYPE,
             @"xid":_albumXid
             };
}



@end
