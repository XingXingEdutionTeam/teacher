//
//  XXEFlowerbasketSubmitAccountInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEFlowerbasketSubmitAccountInfoApi : YTKRequest

/*
 【花篮->提现提交】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/fbasket_withdraw_action
 传参:
	account_id	//提现账号id
	num		//需要提现的花篮数量
 */

- (instancetype)initWithUrlString:(NSString *)url appkey:(NSString *)appkey backtype:(NSString *)backtype xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type account_id:(NSString *)account_id num:(NSString *)num;


@end
