//
//  XXERegisterTeacherHeadApi.h
//  teacher
//
//  Created by codeDing on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXERegisterTeacherHeadApi : YTKRequest

- (id)initWithRegisterTeacherLoginType:(NSString *)loginType PhoneNum:(NSString *)phoneNum Password:(NSString *)password UserName:(NSString *)userName IDCard:(NSString *)idCard PassPort:(NSString *)passport Age:(NSString *)age Sex:(NSString *)sex Position:(NSString *)position TeachId:(NSString *)teachId SchoolId:(NSString *)schoolId ClassId:(NSString *)classId SchoolType:(NSString *)schoolType ExamineId:(NSString *)examineId Code:(NSString *)code HeadImage:(UIImage *)headImage;

@end
