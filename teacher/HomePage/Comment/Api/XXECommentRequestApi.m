



//
//  XXECommentRequestApi.m
//  teacher
//
//  Created by Mac on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECommentRequestApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/teacher_com_msg"


@interface XXECommentRequestApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *require_con;
@property (nonatomic, copy) NSString *page;


@end



@implementation XXECommentRequestApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type class_id:(NSString *)class_id require_con:(NSString *)require_con page:(NSString *)page{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _class_id = class_id;
        _require_con = require_con;
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
    
    return @{@"url":URL,
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":_user_type,
             @"class_id":_class_id,
             @"require_con":_require_con,
             @"page":_page
             };
    
}


@end
