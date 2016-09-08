

//
//  XXERecipeSingleMealDetailInfoApi.m
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeSingleMealDetailInfoApi.h"

#define URL @"http://www.xingxingedu.cn/Parent/school_cookbook_single_meal"

@interface XXERecipeSingleMealDetailInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *meal_type;

@end

@implementation XXERecipeSingleMealDetailInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id date_tm:(NSString *)date_tm meal_type:(NSString *)meal_type{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        
        _school_id = school_id;
        _date_tm = date_tm;
        _meal_type = meal_type;        
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
             @"school_id":_school_id,
             @"meal_type":_meal_type,
             @"date_tm":_date_tm
             };
    
    
}



@end
