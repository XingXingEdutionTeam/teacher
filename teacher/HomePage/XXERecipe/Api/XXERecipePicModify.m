
//
//  XXERecipePicModify.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipePicModify.h"


#define URL @"http://www.xingxingedu.cn/Teacher/school_cookbook_edit"

@interface XXERecipePicModify()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *cookbook_id;
@property (nonatomic, copy) NSString *meal_type;
@property (nonatomic, copy) NSString *meal_name;
@property (nonatomic, copy) NSString *url_group;

@end


@implementation XXERecipePicModify

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position cookbook_id:(NSString *)cookbook_id meal_type:(NSString *)meal_type meal_name:(NSString *)meal_name url_group:(NSString *)url_group{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        
        _school_id = school_id;
        _position = position;
        _cookbook_id = cookbook_id;
        _meal_type = meal_type;
        _meal_name = meal_name;
        _url_group = url_group;
 
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
             @"cookbook_id":_cookbook_id,
             @"meal_type":_meal_type,
             @"meal_name":_meal_name,
             @"url_group":_url_group
             };
    
    
}

@end
