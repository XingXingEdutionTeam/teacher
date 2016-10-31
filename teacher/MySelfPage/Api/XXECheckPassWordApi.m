

//
//  XXECheckPassWordApi.m
//  teacher
//
//  Created by Mac on 16/10/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECheckPassWordApi.h"


#define URL @"http://www.xingxingedu.cn/Global/pay_pass_verify"

@interface XXECheckPassWordApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *pass;

@end

@implementation XXECheckPassWordApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id pass:(NSString *)pass{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _pass = pass;
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
             @"pass":_pass
             };
    
}


@end
