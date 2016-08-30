//
//  XXERegisterTeacherFileApi.m
//  teacher
//
//  Created by codeDing on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERegisterTeacherFileApi.h"

@implementation XXERegisterTeacherFileApi{
    UIImage *_fileImage;
    NSString *_login_type;
    NSString *_phone;
    NSString *_pass;
    NSString *_tname;
    NSString *_id_card;
    NSString *_passport;
    NSString *_age;
    NSString *_sex;
    NSString *_position;
    NSString *_teach_course_id;
    NSString *_school_id;
    NSString *_class_id;
    NSString *_school_type;
    NSString *_examine_id;
    NSString *_code;
}

- (id)initWithRegisterTeacherLoginType:(NSString *)loginType PhoneNum:(NSString *)phoneNum Password:(NSString *)password UserName:(NSString *)userName IDCard:(NSString *)idCard PassPort:(NSString *)passport Age:(NSString *)age Sex:(NSString *)sex Position:(NSString *)position TeachId:(NSString *)teachId SchoolId:(NSString *)schoolId ClassId:(NSString *)classId SchoolType:(NSString *)schoolType ExamineId:(NSString *)examineId Code:(NSString *)code FileImage:(UIImage *)fileImage;
{
    self = [super init];
    if (self) {
        _fileImage = fileImage;
        _login_type = loginType;
        _phone = phoneNum;
        _pass = password;
        _tname = userName;
        _id_card = idCard;
        _passport = passport;
        _age = age;
        _sex = sex;
        _position = position;
        _teach_course_id = teachId;
        _school_id = schoolId;
        _class_id = classId;
        _school_type = schoolType;
        _examine_id = examineId;
        _code = code;
        
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@",XXERegisterTeacherUrl];
}

-(AFConstructingBlock)constructingBodyBlock
{
    return ^(id<AFMultipartFormData> formData){
        int i = 1;
        NSData *data = UIImageJPEGRepresentation(_fileImage, 0.5);
        NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
        NSString *formKey = [NSString stringWithFormat:@"file%d",i];
        NSString *type = @"image/jpeg/png/jpg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}

- (id)requestArgument
{
    return @{@"login_type":_login_type,
             @"phone":_phone,
             @"pass":_pass,
             @"tname":_tname,
             @"id_card":_id_card,
             @"passport":_passport,
             @"age":_age,
             @"sex":_sex,
             @"position":_position,
             @"teach_course_id":_teach_course_id,
             @"school_id":_school_id,
             @"class_id":_class_id,
             @"school_type":_school_type,
             @"examine_id":_examine_id,
             @"code":_code,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE
             };
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"imageId"];
}

@end
