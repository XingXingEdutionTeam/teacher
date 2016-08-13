

//
//  XXEFlowerbasketWithdrawCashApi.m
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketWithdrawCashApi.h"

@interface XXEFlowerbasketWithdrawCashApi()

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *appkey;
@property (nonatomic, copy) NSString *backtype;
@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;


@end


@implementation XXEFlowerbasketWithdrawCashApi

- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type{
    
    if (self = [super init]) {
        _url = url;
        _appkey = appkey;
        _backtype = backtype;
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return @"http://www.xingxingedu.cn/Teacher/fbasket_withdraw_page";
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}


- (id)requestArgument{
    
    return @{@"url":_url,
             @"appkey":_appkey,
             @"backtype":_backtype,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type
             };
    
}



@end
