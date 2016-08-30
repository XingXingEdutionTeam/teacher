//
//  XXELoginApi.h
//  teacher
//
//  Created by codeDing on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXELoginApi : YTKRequest

- (id)initLoginWithUserName:(NSString *)userName PassWord:(NSString *)password LoginType:(NSString *)loginType Lng:(NSString *)lng Lat:(NSString *)lat;

@end
