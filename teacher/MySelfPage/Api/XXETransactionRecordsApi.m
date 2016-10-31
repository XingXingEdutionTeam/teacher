

//
//  XXETransactionRecordsApi.m
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETransactionRecordsApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/school_money_msg"

@interface XXETransactionRecordsApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *page;

@end

@implementation XXETransactionRecordsApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id school_id:(NSString *)school_id page:(NSString *)page{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _school_id = school_id;
        _page = page;
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
             @"page":_page
             };
    
}


@end
