

//
//  XXERongCloudSearchFriendApi.m
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudSearchFriendApi.h"


#define URL @"http://www.xingxingedu.cn/Global/search_user"


@interface XXERongCloudSearchFriendApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *search_con;


@end


@implementation XXERongCloudSearchFriendApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id search_con:(NSString *)search_con{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _search_con = search_con;
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
             @"search_con":_search_con
             };
    
}


@end
