

//
//  XXEFeedbackProblemApi.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFeedbackProblemApi.h"

#define URL @"http://www.xingxingedu.cn/Global/suggestion_sub"

@interface XXEFeedbackProblemApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *con;

@end


@implementation XXEFeedbackProblemApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id con:(NSString *)con{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _con = con;
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
             @"con":_con
             };
    
}


@end
