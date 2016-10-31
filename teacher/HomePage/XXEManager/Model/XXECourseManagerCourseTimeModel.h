//
//  XXECourseManagerCourseTimeModel.h
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//#import "XXECourseManagerCourseTimeModel.h"
//
//@protocol  XXECourseManagerCourseTimeModel
//
//@end

@interface XXECourseManagerCourseTimeModel : JSONModel

/*
 [id] => 46
 [week_date] => 7
 [week_date_name] => 星期天
 [sch_tm_start] => 18:30
 [sch_tm_end] => 19:45
 [complete_str] =>星期天 18:30~19:45
 */

@property (nonatomic, copy) NSString *course_time_id;
@property (nonatomic, copy) NSString *week_date;
@property (nonatomic, copy) NSString *week_date_name;
@property (nonatomic, copy) NSString *sch_tm_start;
@property (nonatomic, copy) NSString *sch_tm_end;
@property (nonatomic, copy) NSString *complete_str;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
