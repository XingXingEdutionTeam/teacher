
//
//  XXESchoolTimetableCourseModifyApi.m
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableCourseModifyApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/schedule_teacher_edit"

@interface XXESchoolTimetableCourseModifyApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *week_date;
@property (nonatomic, copy) NSString *schedule_id;
@property (nonatomic, copy) NSString *wd;
@property (nonatomic, copy) NSString *lesson_start_tm;
@property (nonatomic, copy) NSString *lesson_end_tm;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, copy) NSString *teacher_name;
@property (nonatomic, copy) NSString *classroom;
@property (nonatomic, copy) NSString *notes;

@end

@implementation XXESchoolTimetableCourseModifyApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id week_date:(NSString *)week_date schedule_id:(NSString *)schedule_id wd:(NSString *)wd lesson_start_tm:(NSString *)lesson_start_tm lesson_end_tm:(NSString *)lesson_end_tm course_name:(NSString *)course_name teacher_name:(NSString *)teacher_name classroom:(NSString *)classroom notes:(NSString *)notes{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _week_date = week_date;
        _schedule_id = schedule_id;
        _wd = wd;
        _lesson_start_tm = lesson_start_tm;
        _lesson_end_tm = lesson_end_tm;
        _course_name = course_name;
        _teacher_name = teacher_name;
        _classroom = classroom;
        _notes = notes;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return URL;
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}


- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"week_date":_week_date,
             @"schedule_id":_schedule_id,
             @"wd":_wd,
             @"lesson_start_tm":_lesson_start_tm,
             @"lesson_end_tm":_lesson_end_tm,
             @"course_name":_course_name,
             @"teacher_name":_teacher_name,
             @"classroom":_classroom,
             @"notes":_notes
             };
    
}



@end
