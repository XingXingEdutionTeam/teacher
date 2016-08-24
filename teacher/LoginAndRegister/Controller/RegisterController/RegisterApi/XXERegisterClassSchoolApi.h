//
//  XXERegisterClassSchoolApi.h
//  teacher
//
//  Created by codeDing on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXERegisterClassSchoolApi : YTKRequest
- (id)initWithClassMessageSchoolId:(NSString *)schoolId Grade:(NSString *)grade CourseId:(NSString *)courseId;

@end
