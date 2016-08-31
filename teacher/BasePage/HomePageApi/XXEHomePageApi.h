//
//  XXEHomePageApi.h
//  teacher
//
//  Created by codeDing on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEHomePageApi : YTKRequest

- (id)initWithHomePageXid:(NSString *)xid UserType:(NSString *)userType UserId:(NSString *)userId;

@end
