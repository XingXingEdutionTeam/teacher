
//
//  XXEMyselfInfoGraduateInstitutionsApi.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoGraduateInstitutionsApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/get_university"

@interface XXEMyselfInfoGraduateInstitutionsApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *search_words;

@end

@implementation XXEMyselfInfoGraduateInstitutionsApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id province:(NSString *)province search_words:(NSString *)search_words{
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _province = province;

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
    
    return @{
             @"appkey":APPKEY,
             @"backtype":BACKTYPE,
             @"xid":_xid,
             @"user_id":_user_id,
             @"user_type":USER_TYPE,
             @"province":_province,
             @"search_words":_search_words
                 
             };
    
}


@end
