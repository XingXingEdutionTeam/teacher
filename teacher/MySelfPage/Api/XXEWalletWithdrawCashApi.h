//
//  XXEalletWithdrawCashApi.h
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEWalletWithdrawCashApi : YTKRequest

/*
 【学校提现->提现提交】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/school_withdraw_action
 传参:
	position	//身份
	school_id 	//学校id
	account_id 	//提现账号id
	all_money 	//提现金额
 return_param_all  测试 1
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id position:(NSString *)position account_id:(NSString *)account_id all_money:(NSString *)all_money return_param_all:(NSString *)return_param_all;


@end
