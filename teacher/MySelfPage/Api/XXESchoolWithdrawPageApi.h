//
//  XXESchoolWithdrawPageApi.h
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESchoolWithdrawPageApi : YTKRequest
/*
 【学校提现->钱包首页】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/school_withdraw_page
 传参:
	school_id	//学校id
    position
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id position:(NSString *)position;
@end
