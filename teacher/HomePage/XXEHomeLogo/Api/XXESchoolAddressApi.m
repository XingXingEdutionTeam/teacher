

//
//  XXESchoolAddressProvinceApi.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAddressApi.h"

#define URL @"http://www.xingxingedu.cn/Global/provinces_city_area"

@interface XXESchoolAddressApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;
@property (nonatomic, copy) NSString *action_type;
@property (nonatomic, copy) NSString *fatherID;

@end

@implementation XXESchoolAddressApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type action_type:(NSString *)action_type fatherID:(NSString *)fatherID{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _action_type = action_type;
        _fatherID = fatherID;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return [NSString stringWithFormat:@"%@", URL];
    
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
             @"action_type":_action_type,
             @"fatherID":_fatherID
             };
    
}

@end
