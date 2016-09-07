//
//  XXEMyselfAblumDeleApi.h
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEMyselfAblumDeleApi : YTKRequest

- (id)initWithDeleMyselfAblumId:(NSString *)ablumId UserXid:(NSString *)userXid UserId:(NSString *)userId;

@end
