//
//  XXEFlowerAccountDeleteApi.h
//  teacher
//
//  Created by Mac on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEFlowerAccountDeleteApi : YTKRequest

/*
 【花篮->删除提现账号】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/financial_account_delete
 传参:
 account_id		//账号id
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type account_id:(NSString *)account_id;


@end
