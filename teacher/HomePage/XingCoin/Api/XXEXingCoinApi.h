//
//  XXEXingCoinApi.h
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEXingCoinApi : YTKRequest

/*
 【猩猩商城--签到】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Global/check_in
 
 传参:
 */

- (instancetype)initWithUrlString:(NSString *)url xid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type;


@end
