
//
//  XXEMyselfInfoModifyGraduateSchoolNameApi.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoModifyGraduateSchoolNameApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/edit_my_info"

@interface XXEMyselfInfoModifyGraduateSchoolNameApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *graduate_sch_id;


@end

@implementation XXEMyselfInfoModifyGraduateSchoolNameApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id graduate_sch_id:(NSString *)graduate_sch_id{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _graduate_sch_id = graduate_sch_id;
        
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
             @"graduate_sch_id":_graduate_sch_id
             };
    
}


@end
