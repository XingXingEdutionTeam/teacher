

//
//  XXEXingCoinApi.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingCoinApi.h"


@interface XXEXingCoinApi()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;


@end

@implementation XXEXingCoinApi

- (instancetype)initWithUrlString:(NSString *)url xid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type{
    
    if (self = [super init]) {
        _url = url;
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return @"http://www.xingxingedu.cn/Global/check_in";
    
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
             @"user_type":_user_type
             };
    
}



@end
