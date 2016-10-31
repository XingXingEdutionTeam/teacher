//
//  XXECreateCourseOrderApi.h
//  teacher
//
//  Created by Mac on 16/10/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECreateCourseOrderApi : YTKRequest

/*
 【猩课堂--确认支付课程(生成订单)】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/xkt_create_course_order
 传参:
	course_id		//课程id
	buy_num			//购买数量(报名人数)
	baby_name		//孩子名字,多个用逗号隔开
	parent_phone		//手机号
	deduct_coin		//抵扣猩币数
	deduct_price		//抵扣金额
	pay_price		//实付金额
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id course_id:(NSString *)course_id buy_num:(NSString *)buy_num baby_name:(NSString *)baby_name parent_phone:(NSString *)parent_phone deduct_coin:(NSString *)deduct_coin deduct_price:(NSString *)deduct_price pay_price:(NSString *)pay_price;


@end
