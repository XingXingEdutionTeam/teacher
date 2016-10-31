//
//  XXETransactionRecordsApi.h
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXETransactionRecordsApi : YTKRequest

/*
 【学校提现->交易记录】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Teacher/school_money_msg
 传参:
	school_id 	//学校id
	page 		//翻页,默认1
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id page:(NSString *)page;


@end
