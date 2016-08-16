//
//  XXEFriendCircleApi.m
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendCircleApi.h"

@implementation XXEFriendCircleApi{
    NSString *_xid;
    NSString *_pageNum;
}

- (id)initWithFriendCircleXid:(NSString *)xid PageNumber:(NSString *)pageNum
{
    self = [super init];
    if (self) {
        _xid = xid;
        _pageNum = pageNum;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEFriendCircleUrl];
}

- (id)requestArgument
{
    return @{@"page":_pageNum,
             @"xid":XID,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":@"1",
             @"user_type":@"2"
             };
}

@end
