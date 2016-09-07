//
//  XXEMyselfAblumDeleApi.m
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfAblumDeleApi.h"

@implementation XXEMyselfAblumDeleApi{
    NSString *_ablumId;
    NSString *_userXid;
    NSString *_userId;
}

- (id)initWithDeleMyselfAblumId:(NSString *)ablumId UserXid:(NSString *)userXid UserId:(NSString *)userId;
{
    self = [super init];
    if (self) {
        _ablumId = ablumId;
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
    return [NSString stringWithFormat:@"%@",XXEAlbumDelegateUrl];
}

- (id)requestArgument
{
    return @{
             @"album_id":_ablumId,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE,
             @"xid":_userXid
             };
}





@end
