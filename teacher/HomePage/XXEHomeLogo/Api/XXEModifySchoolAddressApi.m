


//
//  XXEModifySchoolAddressApi.m
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEModifySchoolAddressApi.h"



#define URL @"http://www.xingxingedu.cn/Teacher/school_edit"

@interface XXEModifySchoolAddressApi()

/*
 province		//省
	city			//市
	district		//区
	address			//详细地址
 */

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *address;


@end

@implementation XXEModifySchoolAddressApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type school_id:(NSString *)school_id position:(NSString *)position province:(NSString *)province city:(NSString *)city district:(NSString *)district address:(NSString *)address{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _school_id = school_id;
        _position = position;
        
        _province = province;
        _city = city;
        _district = district;
        _address = address;
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
             @"province":_province,
             @"city":_city,
             @"district":_district,
             @"address":_address
             };
    
}

@end
