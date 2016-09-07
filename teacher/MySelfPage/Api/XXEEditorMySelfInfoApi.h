//
//  XXEEditorMySelfInfoApi.h
//  teacher
//
//  Created by codeDing on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "YTKRequest.h"

@interface XXEEditorMySelfInfoApi : YTKRequest

- (id)initWithEditorInfoUserXid:(NSString *)userXid UserID:(NSString *)userId NickName:(NSString *)nickName Phone:(NSString *)phone Email:(NSString *)email TeachLife:(NSString *)teachLife TeachFeel:(NSString *)teachFeel GraduateSchoolId:(NSString *)graduateSchoolId Specialyt:(NSString *)specialty ExperYear:(NSString *)experYear PersonalSign:(NSString *)personalSign file:(NSString *)file;

@end
