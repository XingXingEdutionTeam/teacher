//
//  XXEHomeIdentityApi.h
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEHomeIdentityApi : YTKRequest

- (id)initWithHomeIdentityUserXid:(NSString *)userXid UserId:(NSString *)userId;

@end
