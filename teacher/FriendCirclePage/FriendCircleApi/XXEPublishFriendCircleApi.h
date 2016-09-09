//
//  XXEPublishFriendCircleApi.h
//  teacher
//
//  Created by codeDing on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEPublishFriendCircleApi : YTKRequest

- (id)initWithPublishFriendCirclePosition:(NSString *)position FileType:(NSString *)fileType Words:(NSString *)words File:(NSString *)file UserXid:(NSString *)userXid UserId:(NSString *)userId;

@end
