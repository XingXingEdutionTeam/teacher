


//
//  XXEMyselfInfoCollectionCommentApi.m
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionCommentApi.h"

#define URL @"http://www.xingxingedu.cn/Global/col_tea_com_list"

@interface XXEMyselfInfoCollectionCommentApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *page;

@end

@implementation XXEMyselfInfoCollectionCommentApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id page:(NSString *)page{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
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
             @"page":_page
             };
    
}


@end
