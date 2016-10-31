
//
//  XXEXingClassRoomSearchApi.m
//  teacher
//
//  Created by Mac on 16/10/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomSearchApi.h"

#define URL @"http://www.xingxingedu.cn/Global/xkt_top_keywords"

@interface XXEXingClassRoomSearchApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *date_type;


@end


@implementation XXEXingClassRoomSearchApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id date_type:(NSString *)date_type{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _date_type = date_type;
        
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
             @"date_type":_date_type

             };
    
}


@end
