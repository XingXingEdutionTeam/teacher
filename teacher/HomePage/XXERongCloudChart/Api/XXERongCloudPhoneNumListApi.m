
//
//  XXERongCloudPhoneNumListApi.m
//  teacher
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudPhoneNumListApi.h"

#define URL @"http://www.xingxingedu.cn/Global/phone_contact_book"


@interface XXERongCloudPhoneNumListApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *phone_group;
@property (nonatomic, copy) NSString *return_param_all;


@end


@implementation XXERongCloudPhoneNumListApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id phone_group:(NSString *)phone_group return_param_all:(NSString *)return_param_all{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _phone_group = phone_group;
        _return_param_all = return_param_all;
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
             @"phone_group":_phone_group,
             @"return_param_all":_return_param_all
             };
    
}


@end
