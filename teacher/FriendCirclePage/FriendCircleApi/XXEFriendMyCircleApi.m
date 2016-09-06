//
//  XXEFriendMyCircleApi.m
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendMyCircleApi.h"

@implementation XXEFriendMyCircleApi{
    NSString *_otherXid;
    NSString *_page;
    NSString *_userId;
}

- (id)initWithChechFriendCircleOtherXid:(NSString *)otherXid page:(NSString *)page UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _otherXid = otherXid;
        _page = page;
        _userId = userId;
    }
    return self;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXECheckFriendCircleUrl];
}

- (id)requestArgument
{
    return @{@"page":_page,
             @"xid":_otherXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE
             };
}

@end
