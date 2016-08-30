//
//  XXEMyselfAblumUpDataApi.h
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEMyselfAblumUpDataApi : YTKRequest

- (id)initWithAblumSchoolId:(NSString *)schoolId ClassId:(NSString *)classId AblumId:(NSString *)ablumId ImageArray:(UIImage *)imageArray;

@end
