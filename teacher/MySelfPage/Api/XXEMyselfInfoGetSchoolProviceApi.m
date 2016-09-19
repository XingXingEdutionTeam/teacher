

//
//  XXEMyselfInfoGetSchoolProviceApi.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoGetSchoolProviceApi.h"

#define URL @"http://www.xingxingedu.cn/Global/provinces_city_area"

@interface XXEMyselfInfoGetSchoolProviceApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *action_type;
@property (nonatomic, copy) NSString *fatherID;


@end

@implementation XXEMyselfInfoGetSchoolProviceApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id action_type:(NSString *)action_type fatherID:(NSString *)fatherID{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _action_type = action_type;
        _fatherID = fatherID;
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
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"action_type":_action_type,
             @"fatherID":_fatherID
             };
}
@end
