


//
//  XXEFlowerbasketSentHistoryApi.m
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketSentHistoryApi.h"

@interface XXEFlowerbasketSentHistoryApi()

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *appkey;
@property (nonatomic, copy) NSString *backtype;
@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *page;

@end


@implementation XXEFlowerbasketSentHistoryApi

- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type page:(NSString *)page{
    
    if (self = [super init]) {
        _url = url;
        _appkey = appkey;
        _backtype = backtype;
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _page = page;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return @"http://www.xingxingedu.cn/Teacher/fbasket_withdraw_record";
    
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
             @"page":_page
             };
    
}


@end
