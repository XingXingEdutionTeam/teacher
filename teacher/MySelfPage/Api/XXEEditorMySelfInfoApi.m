//
//  XXEEditorMySelfInfoApi.m
//  teacher
//
//  Created by codeDing on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEEditorMySelfInfoApi.h"

@implementation XXEEditorMySelfInfoApi{
    
    NSString *_userXid;
    NSString *_userId;
    NSString *_nickname;
    NSString *_phone;
    NSString *_email;
    NSString *_teach_life;
    NSString *_teach_feel;
    NSString *_graduate_sch_id;
    NSString *_specialty;
    NSString *_exper_year;
    NSString *_personal_sign;
    NSString *_file;
}

- (id)initWithEditorInfoUserXid:(NSString *)userXid UserID:(NSString *)userId NickName:(NSString *)nickName Phone:(NSString *)phone Email:(NSString *)email TeachLife:(NSString *)teachLife TeachFeel:(NSString *)teachFeel GraduateSchoolId:(NSString *)graduateSchoolId Specialyt:(NSString *)specialty ExperYear:(NSString *)experYear PersonalSign:(NSString *)personalSign file:(NSString *)file
{
    self = [super init];
    if (self) {
        _userXid = userXid;
        _userId = userId;
        _nickname = nickName;
        _email = email;
        _phone = phone;
        _teach_life = teachLife;
        _teach_feel = teachFeel;
        _graduate_sch_id = graduateSchoolId;
        _specialty = specialty;
        _exper_year = experYear;
        _personal_sign = personalSign;
        _file = file;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXEEditMessURL];
}

- (id)requestArgument
{
    return @{@"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_userXid,
             @"user_id":_userId,
             @"user_type":USER_TYPE,
             @"nickname":_nickname,
             @"phone":_phone,
             @"email":_email,
             @"teach_life":_teach_life,
             @"teach_feel":_teach_feel,
             @"graduate_sch_id":_graduate_sch_id,
             @"specialty":_specialty,
             @"exper_year":_exper_year,
             @"personal_sign":_personal_sign,
             @"file":_file
             };
}

@end
