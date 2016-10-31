

//
//  XXEalletWithdrawCashApi.m
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEWalletWithdrawCashApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/school_withdraw_action"

@interface XXEWalletWithdrawCashApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *all_money;
@property (nonatomic, copy) NSString *return_param_all;


@end

@implementation XXEWalletWithdrawCashApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id position:(NSString *)position account_id:(NSString *)account_id all_money:(NSString *)all_money return_param_all:(NSString *)return_param_all{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _position = position;
        _account_id = account_id;
        _all_money = all_money;
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
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"school_id":_school_id,
             @"position":_position,
             @"account_id":_account_id,
             @"all_money":_all_money,
             @"return_param_all":_return_param_all
             };
    
}


@end
