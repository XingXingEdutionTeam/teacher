//
//  XXERootFriendListApi.h
//  teacher
//
//  Created by codeDing on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXERootFriendListApi : YTKRequest

- (id)initWithRootFriendListUserXid:(NSString *)userXid UserId:(NSString *)userId;

@end
