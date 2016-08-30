//
//  XXEFlowerbasketAddAccountApi.h
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEFlowerbasketAddAccountApi : YTKRequest

/*
 【花篮->新增提现账号】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/financial_account_add
 
 传参:
 
 tname		//姓名
 account	//账号
 type		//账号类型, 当前只有支付宝, 填:1 (将来或许会增加其他账号类型)
 */

- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type tname:(NSString *)tname account:(NSString *)account type:(NSString *)type;

@end
