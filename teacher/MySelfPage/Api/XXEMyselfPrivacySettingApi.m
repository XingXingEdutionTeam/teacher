
//
//  XXEMyselfPrivacySettingApi.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfPrivacySettingApi.h"

#define URL @"http://www.xingxingedu.cn/Global/secret_set"

@interface XXEMyselfPrivacySettingApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *show_phone;
@property (nonatomic, copy) NSString *show_tname;
@property (nonatomic, copy) NSString *search_phone;
@property (nonatomic, copy) NSString *search_xid;
@property (nonatomic, copy) NSString *search_nearby;
@property (nonatomic, copy) NSString *add_friend_set;


@end

@implementation XXEMyselfPrivacySettingApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id show_tname:(NSString *)show_tname show_phone:(NSString *)show_phone search_nearby:(NSString *)search_nearby search_xid:(NSString *)search_xid search_phone:(NSString *)search_phone add_friend_set:(NSString *)add_friend_set{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _show_tname = show_tname;
        _show_phone = show_phone;
        _search_phone = search_phone;
        _search_xid = search_xid;
        _search_nearby = search_nearby;
        _add_friend_set = add_friend_set;
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
             @"show_tname":_show_tname,
             @"show_phone":_show_phone,
             @"search_phone":_search_phone,
             @"search_xid":_search_xid,
             @"search_nearby":_search_nearby,
             @"add_friend_set":_add_friend_set
             };
    
}


@end
