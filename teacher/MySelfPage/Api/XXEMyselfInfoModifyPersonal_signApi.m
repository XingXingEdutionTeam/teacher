

//
//  XXEMyselfInfoModifyPersonal_signApi.m
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoModifyPersonal_signApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/edit_my_info"

@interface XXEMyselfInfoModifyPersonal_signApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *personal_sign;

@end

@implementation XXEMyselfInfoModifyPersonal_signApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type personal_sign:(NSString *)personal_sign{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _personal_sign = personal_sign;
        
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
             @"user_type":_user_type,
             @"personal_sign":_personal_sign
             };
    
}


@end
