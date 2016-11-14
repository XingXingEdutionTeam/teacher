
//
//  XXEStoreStoreApi.m
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreStoreApi.h"


#define URL @"http://www.xingxingedu.cn/Global/coin_goods"

@interface XXEStoreStoreApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) NSString *search_words;


@end

@implementation XXEStoreStoreApi


- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id classID:(NSString *)classID search_words:(NSString *)search_words{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _classID = classID;
        _search_words = search_words;
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
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"class":_classID,
             @"search_words":_search_words
             };
    
}


@end
