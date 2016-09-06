//
//  XXEFriendCirclegoodApi.m
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFriendCirclegoodApi.h"

@implementation XXEFriendCirclegoodApi{
    NSString *_userXid;
    NSString *_userId;
    NSString *_talkId;
}

- (id)initWithFriendCircleGoodOrCancelUerXid:(NSString *)userXid UserID:(NSString *)userId TalkId:(NSString *)talkId
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
        _talkId = talkId;
    }
    return self;
}



@end
