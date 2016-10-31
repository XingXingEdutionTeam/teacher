//
//  XXECheckPassWordApi.h
//  teacher
//
//  Created by Mac on 16/10/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECheckPassWordApi : YTKRequest

/*
 【支付密码验证】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/pay_pass_verify
 传参:
	pass	//密码
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id pass:(NSString *)pass;

@end
