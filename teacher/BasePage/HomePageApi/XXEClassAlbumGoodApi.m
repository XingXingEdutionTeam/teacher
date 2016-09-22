//
//  XXEClassAlbumGoodApi.m
//  teacher
//
//  Created by codeDing on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassAlbumGoodApi.h"

@implementation XXEClassAlbumGoodApi{
    NSString *_userXid;
    NSString *_userId;
    NSString *_picId;
}

- (id)initWithHomePageClassAblumGoodUserXid:(NSString *)userXid UserId:(NSString *)userId PicId:(NSString *)picId
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
        _picId = picId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEClassAlbumGoodUrl];
}

- (id)requestArgument
{
    return @{@"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_type":USER_TYPE,
             @"xid":_userXid,
             @"user_id":_userId,
             @"pic_id":_picId
             };
}

@end
