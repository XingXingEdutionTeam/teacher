//
//  XXEFriendCircleApi.h
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEFriendCircleApi : YTKRequest

- (id)initWithFriendCircleXid:(NSString *)xid CircleUserId:(NSString *)userId PageNumber:(NSString *)pageNum;

@end
