//
//  XXEHomePageCollectionPhotoApi.m
//  teacher
//
//  Created by codeDing on 16/8/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageCollectionPhotoApi.h"

@implementation XXEHomePageCollectionPhotoApi{
    NSString *_imageUrl;
}

- (id)initHomePageCollectionPhontImageAddress:(NSString *)imageAddress
{
    self = [super init];
    
    if (self) {
        _imageUrl  = imageAddress;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEHomeCollectionPhotoUrl];
}

- (id)requestArgument
{
    return @{@"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_type":USER_TYPE,
             @"xid":XID,
             @"user_id":USER_ID,
             @"url":_imageUrl};
}

@end
