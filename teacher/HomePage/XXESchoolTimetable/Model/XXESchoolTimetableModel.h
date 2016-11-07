//
//  XXESchoolTimetableModel.h
//  teacher
//
//  Created by Mac on 16/11/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESchoolTimetableModel : JSONModel

/*
 [id] => 1			//下个接口用
 [week_date] => 1466956800
 [course_name] => 奥数
 [classroom] => 暑假班奥数
 [teacher_name] => 何青光
 [lesson_start_tm] => 13:00
 [lesson_end_tm] => 14:30
 [notes] => 不能迟到
 [type] => 3			//类型,3是自定义,允许修改
 [wd] => saturday		//下个接口用 */

@property (nonatomic, copy) NSString<Optional> *schedule_id;
@property (nonatomic, copy) NSString<Optional> *week_date;
@property (nonatomic, copy) NSString<Optional> *course_name;
@property (nonatomic, copy) NSString<Optional> *classroom;
@property (nonatomic, copy) NSString<Optional> *teacher_name;
@property (nonatomic, copy) NSString<Optional> *lesson_start_tm;
@property (nonatomic, copy) NSString<Optional> *lesson_end_tm;
@property (nonatomic, copy) NSString<Optional> *notes;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *wd;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
