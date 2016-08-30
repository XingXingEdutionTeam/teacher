//
//  XXEVertifyTimesApi.h
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEVertifyTimesApi : YTKRequest

- (id)initWithVertifyTimesActionPage:(NSString *)actionPage PhoneNum:(NSString *)phoneNum;

@end
