//
//  XXERootFriendListApi.m
//  teacher
//
//  Created by codeDing on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERootFriendListApi.h"

@implementation XXERootFriendListApi{
    NSString *_userXid;
    NSString *_userId;
}

- (id)initWithRootFriendListUserXid:(NSString *)userXid UserId:(NSString *)userId
{
    self = [super init];
    if (self) {
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
    return [NSString stringWithFormat:@"http://www.xingxingedu.cn/Global/friend_list"];
}

- (id)requestArgument
{
    return @{@"xid":_userXid,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"user_id":_userId,
             @"user_type":USER_TYPE
             };
}

@end
