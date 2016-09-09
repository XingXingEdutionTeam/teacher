//
//  XXEPublishFriendCircleApi.m
//  teacher
//
//  Created by codeDing on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEPublishFriendCircleApi.h"

@implementation XXEPublishFriendCircleApi{
    
    NSString *_position;
    NSString *_file_type;
    NSString *_words;
    NSString *_file;
    NSString *_userXid;
    NSString *_userId;
}

- (id)initWithPublishFriendCirclePosition:(NSString *)position FileType:(NSString *)fileType Words:(NSString *)words File:(NSString *)file UserXid:(NSString *)userXid UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _position = position;
        _file_type = fileType;
        _file = file;
        _userXid = userXid;
        _userId = userId;
        _words = words;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEPublishFriendCircleUrl];
}

- (id)requestArgument
{
    return @{@"xid":_userXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE,
             @"position":_position,
             @"file_type":_file_type,
             @"words":_words,
             @"file":_file
             };
}

@end
