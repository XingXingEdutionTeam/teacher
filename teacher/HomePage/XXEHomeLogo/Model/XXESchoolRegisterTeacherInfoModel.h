//
//  XXESchoolRegisterTeacherInfoModel.h
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESchoolRegisterTeacherInfoModel : JSONModel



/*
 {
 age = 28;
 certification = 0;         //0 :没认证  1:已认证
 "collect_condit" = 2;      //1代表收藏过, 2代表未收藏
 "exper_year" = 2;                              //教龄
 "head_img" = "app_upload/text/teacher/8.jpg";
 "head_img_type" = 0;
 id = 8;
 "score_num" = 4;                               //评分
 "teach_course" = "\U8bed\U6587,\U97f3\U4e50";  //授课
 tname = "\U6c88\U7490\U7490";
 xid = 18886396;
 }
 */

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *certification;
@property (nonatomic, copy) NSString *collect_condit;
@property (nonatomic, copy) NSString *exper_year;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *registerTeacherId;
@property (nonatomic, copy) NSString *score_num;
@property (nonatomic, copy) NSString *teach_course;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *xid;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
