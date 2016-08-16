

//
//  XXERedFlowerSentHistoryApi.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERedFlowerSentHistoryApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/give_flower_msg"


@interface XXERedFlowerSentHistoryApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *page;


@end


@implementation XXERedFlowerSentHistoryApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type page:(NSString *)page{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _page = page;
    }
    return self;
}


- (NSString *)requestUrl{
    
//    return @"http://www.xingxingedu.cn/Teacher/give_flower_msg";
    return URL;
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
    
}


/*
 return @{@"url":_url,
 @"appkey":_appkey,
 @"backtype":_backtype,
 @"xid":_xid,
 @"user_id":_user_id,
 @"user_type":_user_type,
 @"page":_page
 };
 */

- (id)requestArgument{
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"page":_page
             };
    
}


@end
