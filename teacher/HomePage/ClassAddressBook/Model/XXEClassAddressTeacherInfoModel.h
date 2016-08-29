//
//  XXEClassAddressTeacherInfoModel.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassAddressTeacherInfoModel : JSONModel

/*
 老师
 
 {
 "head_img" = "app_upload/text/teacher/1.jpg";
 "head_img_type" = 0;
 id = 1;
 "teach_course" = "\U8bed\U6587,\U97f3\U4e50";
 tname = "\U6881\U7ea2\U6c34";
 xid = 18886389;
 }
 */

@property (nonatomic, copy) NSString *teacher_id;
@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *teach_course;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *xid;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
