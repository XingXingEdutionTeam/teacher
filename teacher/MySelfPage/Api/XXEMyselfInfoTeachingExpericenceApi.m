

//
//  XXEMyselfInfoTeachingExpericenceApi.m
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoTeachingExpericenceApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/edit_my_info"

@interface XXEMyselfInfoTeachingExpericenceApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_type;

@property (nonatomic, copy) NSString *teach_life;

@end

@implementation XXEMyselfInfoTeachingExpericenceApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id user_type:(NSString *)user_type teach_life:(NSString *)teach_life{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _user_type = user_type;
        _teach_life = teach_life;
        
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
             @"user_type":_user_type,
             @"teach_life":_teach_life
             };
    
}


@end
