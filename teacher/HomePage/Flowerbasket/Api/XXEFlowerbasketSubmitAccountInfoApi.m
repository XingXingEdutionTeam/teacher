
//
//  XXEFlowerbasketSubmitAccountInfoApi.m
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketSubmitAccountInfoApi.h"

@interface XXEFlowerbasketSubmitAccountInfoApi()

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *user_id;

@end


@implementation XXEFlowerbasketSubmitAccountInfoApi{

    NSString *_account_id;
    NSString *_num;
}



- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type account_id:(NSString *)account_id num:(NSString *)num{
    
    if (self = [super init]) {
        _xid = xid;
        _user_id = user_id;
        _account_id = account_id;
        _num = num;
    }
    return self;
}


- (NSString *)requestUrl{
    
    return [NSString stringWithFormat:@"http://www.xingxingedu.cn/Teacher/fbasket_withdraw_action"];
    
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
             @"account_id":_account_id,
             @"num":_num
             };
    
}


@end
