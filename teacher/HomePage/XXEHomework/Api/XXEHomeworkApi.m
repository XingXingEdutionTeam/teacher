


//
//  XXEHomeworkApi.m
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeworkApi.h"


#define URL @"http://www.xingxingedu.cn/Parent/class_homework_list"

@interface XXEHomeworkApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *teach_course;
@property (nonatomic, copy) NSString *month;

@end


@implementation XXEHomeworkApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id class_id:(NSString *)class_id page:(NSString *)page teach_course:(NSString *)teach_course month:(NSString *)month{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _school_id = school_id;
        _class_id = class_id;
        _page = page;
        _teach_course = teach_course;
        _month = month;
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
             @"page":_page,
             @"teach_course":_teach_course,
             @"month":_month
             };
    
}



@end
