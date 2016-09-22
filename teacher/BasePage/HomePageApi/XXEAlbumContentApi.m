//
//  XXEAlbumContentApi.m
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEAlbumContentApi.h"

@implementation XXEAlbumContentApi{
    NSString *_album_id;
    NSString *_userXid;
    NSString *_userId;
}

- (id)initWithAlbumContentAlbumId:(NSString *)albumId UserXid:(NSString *)userXid UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _album_id = albumId;
        _userXid = userXid;
        _userId = userId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEAblumPhotoUrl];
}

- (id)requestArgument
{
    return @{
             @"album_id":_album_id,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE,
             @"xid":_userXid
             };
}


@end
