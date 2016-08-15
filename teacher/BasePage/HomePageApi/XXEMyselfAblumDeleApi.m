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
}

- (id)initWithDeleMyselfAblumId:(NSString *)ablumId
{
    self = [super init];
    if (self) {
        _ablumId = ablumId;
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
             @"user_id":USER_ID,
             @"user_type":USER_TYPE,
             @"xid":XID
             };
}





@end
