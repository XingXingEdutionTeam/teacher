//
//  XXEFlowerbasketSentHistoryApi.h
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEFlowerbasketSentHistoryApi : YTKRequest

/*
 【花篮->花篮提现记录】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Teacher/fbasket_withdraw_record
 
 传参:
 */
- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type page:(NSString *)page;

@end
