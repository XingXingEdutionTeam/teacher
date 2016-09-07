//
//  XXESearchUnApi.h
//  teacher
//
//  Created by codeDing on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXESearchUnApi : YTKRequest

- (id)initWithUserXid:(NSString *)userXid UserId:(NSString *)userId Province:(NSString *)province City:(NSString *)city District:(NSString *)district SearchWords:(NSString *)searchWords;

@end
