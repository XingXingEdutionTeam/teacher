

//
//  XXEReplyTextInfoApi.m
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReplyTextInfoApi.h"


#define URL @"http://www.xingxingedu.cn/Teacher/request_comment_action"


@interface XXEReplyTextInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *com_con;
@property (nonatomic, copy) NSString *url_group;

@end



@implementation XXEReplyTextInfoApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type class_id:(NSString *)class_id comment_id:(NSString *)comment_id com_con:(NSString *)com_con url_group:(NSString *)url_group{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _class_id = class_id;
        _comment_id = comment_id;
        _com_con = com_con;
        _url_group = url_group;
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
             @"comment_id":_comment_id,
             @"com_con":_com_con,
             @"url_group":_url_group
             };
    
}

@end
