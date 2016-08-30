//
//  XXETeacherGradeModel.h
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXETeacherGradeModel : JSONModel

/** 课程id */
@property (nonatomic, copy)NSString <Optional>*course_id;
/** 学校ID */
@property (nonatomic, copy)NSString <Optional>*school_id;
/** 班级名称 */
@property (nonatomic, copy)NSString <Optional>*grade;
@end
