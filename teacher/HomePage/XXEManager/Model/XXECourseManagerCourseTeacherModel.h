//
//  XXECourseManagerCourseTeacherModel.h
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//#import "XXECourseManagerCourseTeacherModel.h"
//
//@protocol  XXECourseManagerCourseTeacherModel
//
//@end

@interface XXECourseManagerCourseTeacherModel : JSONModel

/*
 [id] => 1		//教师id
 [tname] => 粱红水
 [head_img] => app_upload/text/teacher/1.jpg
 [head_img_type] => 0
 */

@property (nonatomic, copy) NSString *course_teacher_id;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
