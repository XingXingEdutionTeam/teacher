//
//  XXERegisterGradeSchoolApi.h
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXERegisterGradeSchoolApi : YTKRequest

- (id)initWithGetOutSchoolGradeSchoolId:(NSString *)schoolId SchoolType:(NSString *)schoolType;

@end
