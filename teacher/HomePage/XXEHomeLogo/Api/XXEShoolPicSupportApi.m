
//
//  XXEShoolPicSupportApi.m
//  teacher
//
//  Created by Mac on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEShoolPicSupportApi.h"


#define URL @"http://www.xingxingedu.cn/Global/school_album_good"


@interface XXEShoolPicSupportApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *pic_id;

@end

@implementation XXEShoolPicSupportApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id pic_id:(NSString *)pic_id{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _pic_id = pic_id;
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
             @"pic_id":_pic_id
             };
    
}


@end
