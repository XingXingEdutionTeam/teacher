

//
//  XXEHomeworkIssueTextInfoApi.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeworkIssueTextInfoApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/teacher_comment_action"

@interface XXEHomeworkIssueTextInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *teach_course;
@property (nonatomic, copy) NSString *date_end_tm;


@end


@implementation XXEHomeworkIssueTextInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id title:(NSString *)title con:(NSString *)con teach_course:(NSString *)teach_course date_end_tm:(NSString *)date_end_tm{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _school_id = school_id;
        _class_id = class_id;
        _title = title;
        _con = con;
        _teach_course = teach_course;
        _date_end_tm = date_end_tm;
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
             @"user_type":_user_type,
             @"school_id":_school_id,
             @"class_id":_class_id,
             @"title":_title,
             @"con":_con,
             @"teach_course":_teach_course,
             @"date_end_tm":_date_end_tm
             };
    
    
}



@end
