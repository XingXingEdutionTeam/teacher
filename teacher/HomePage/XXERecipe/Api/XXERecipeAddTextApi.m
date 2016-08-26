

//
//  XXERecipeAddTextApi.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeAddTextApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/school_cookbook_publish"

@interface XXERecipeAddTextApi()

/*
 breakfast_file	//早餐图片(批量上传图片)
	lunch_file	//午餐图片(批量上传图片)
	dinner_file	//晚餐图片(批量上传图片)
 */

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *breakfast_name;
@property (nonatomic, copy) NSString *lunch_name;
@property (nonatomic, copy) NSString *dinner_name;
@property (nonatomic, copy) NSString *breakfast_url;
@property (nonatomic, copy) NSString *lunch_url;
@property (nonatomic, copy) NSString *dinner_url;


@end


@implementation XXERecipeAddTextApi


- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position date_tm:(NSString *)date_tm breakfast_name:(NSString *)breakfast_name lunch_name:(NSString *)lunch_name dinner_name:(NSString *)dinner_name breakfast_url:(NSString *)breakfast_url lunch_url:(NSString *)lunch_url dinner_url:(NSString *)dinner_url{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _school_id = school_id;
        _position = position;
        _date_tm = date_tm;
        _breakfast_name = breakfast_name;
        _lunch_name = lunch_name;
        _dinner_name = dinner_name;
        
        _breakfast_url = breakfast_url;
        _lunch_url = lunch_url;
        _dinner_url = dinner_url;
        
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
             @"position":_position,
             @"date_tm":_date_tm,
             @"breakfast_name":_breakfast_name,
             @"lunch_name":_lunch_name,
             @"dinner_name":_dinner_name,
             @"breakfast_url":_breakfast_url,
             @"lunch_url":_lunch_url,
             @"dinner_url":_dinner_url
             };
    
    
}



@end
