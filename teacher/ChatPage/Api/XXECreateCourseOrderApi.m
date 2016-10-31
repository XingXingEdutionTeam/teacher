
//
//  XXECreateCourseOrderApi.m
//  teacher
//
//  Created by Mac on 16/10/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECreateCourseOrderApi.h"

#define URL @"http://www.xingxingedu.cn/Global/xkt_create_course_order"

@interface XXECreateCourseOrderApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *course_id;
@property (nonatomic, copy) NSString *buy_num;
@property (nonatomic, copy) NSString *baby_name;
@property (nonatomic, copy) NSString *parent_phone;
@property (nonatomic, copy) NSString *deduct_coin;
@property (nonatomic, copy) NSString *deduct_price;
@property (nonatomic, copy) NSString *pay_price;


@end

@implementation XXECreateCourseOrderApi

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id course_id:(NSString *)course_id buy_num:(NSString *)buy_num baby_name:(NSString *)baby_name parent_phone:(NSString *)parent_phone deduct_coin:(NSString *)deduct_coin deduct_price:(NSString *)deduct_price pay_price:(NSString *)pay_price{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _course_id = course_id;
        _buy_num = buy_num;
        _baby_name = baby_name;
        _parent_phone = parent_phone;
        _deduct_coin = deduct_coin;
        _deduct_price = deduct_price;
        _pay_price = pay_price;
        
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
             @"course_id":_course_id,
             @"buy_num":_buy_num,
             @"baby_name":_baby_name,
             @"parent_phone":_parent_phone,
             @"deduct_coin":_deduct_coin,
             @"deduct_price":_deduct_price,
             @"pay_price":_pay_price
             
             };
    
}


@end
