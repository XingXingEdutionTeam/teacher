//
//  XXEXingCoinHistoryApi.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCoinHistoryApi.h"

@interface XXEXingCoinHistoryApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *require_con;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *page;

@end


@implementation XXEXingCoinHistoryApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id  require_con:(NSString *)require_con year:(NSString *)year page:(NSString *)page{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _require_con = require_con;
        _year = year;
        _page = page;
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
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"require_con":_require_con,
             @"year":_year,
             @"page":_page
             };
    
}


@end
