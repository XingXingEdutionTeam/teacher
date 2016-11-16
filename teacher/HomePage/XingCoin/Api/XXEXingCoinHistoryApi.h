//
//  XXEXingCoinHistoryApi.h
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEXingCoinHistoryApi : YTKRequest

/*
 【猩猩商城--查询猩币变更记录】
 
 接口类型:1
 
 接口:
 http://www.xingxingedu.cn/Global/select_coin_msg
 
 传参:
	require_con = "4"	//想要查询的内容,如果是空默认全部类型,4代表互赠
	year = "2016"		//可以查询某一年,如果是空,查询所有年份的猩币记录
 */

//- (instancetype)initWithUrlString:(NSString *)url xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type require_con:(NSString *)require_con year:(NSString *)year page:(NSString *)page;

- (instancetype)initWithXid:(NSString *)xid user_id:(NSString *)user_id  require_con:(NSString *)require_con year:(NSString *)year page:(NSString *)page;

@end
