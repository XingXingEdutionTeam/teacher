//
//  XXEMyselfInfoModifyTeachingAgeApi.h
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoModifyTeachingAgeApi : YTKRequest

/*
 【编辑我的资料】
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/edit_my_info
 
 传参:
	exper_year		//教龄
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type exper_year:(NSString *)exper_year;

@end
