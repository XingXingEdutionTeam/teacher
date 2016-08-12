

//
//  XXEFlowerbasketAddAccountApi.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketAddAccountApi.h"

@interface XXEFlowerbasketAddAccountApi()


@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *appkey;
@property (nonatomic, copy) NSString *backtype;
@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

//姓名
@property (nonatomic, copy) NSString *tname;
//账号
@property (nonatomic, copy) NSString *account;
//账号类型, 当前只有支付宝, 填:1 (将来或许会增加其他账号类型)
@property (nonatomic, copy) NSString *type;

@end


@implementation XXEFlowerbasketAddAccountApi

- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type tname:(NSString *)tname account:(NSString *)account type:(NSString *)type{
    
    if (self = [super init]) {
        _url = url;
        _appkey = appkey;
        _backtype = backtype;
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _tname = tname;
        _account = account;
        _type = type;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return @"http://www.xingxingedu.cn/Teacher/financial_account_add";
    
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
             @"user_type":_user_type,
             @"tname":_tname,
             @"account":_account,
             @"type":_type
             };
    
}



@end
