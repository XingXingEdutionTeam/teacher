



//
//  XXEXingCoinHistoryApi.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCoinHistoryApi.h"

@interface XXEXingCoinHistoryApi()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;
@property (nonatomic, copy) NSString *require_con;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *page;

@end


@implementation XXEXingCoinHistoryApi

- (instancetype)initWithUrlString:(NSString *)url xid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type require_con:(NSString *)require_con year:(NSString *)year{
    
    if (self = [super init]) {
        _url = url;
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _require_con = require_con;
        _year = year;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return @"http://www.xingxingedu.cn/Global/select_coin_msg";
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}


- (id)requestArgument{
    
    return @{@"url":_url,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"require_con":_require_con,
             @"year":_year
             };
    
}


@end
