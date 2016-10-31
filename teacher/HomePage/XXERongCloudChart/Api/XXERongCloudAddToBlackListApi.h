//
//  XXERongCloudAddToBlackListApi.h
//  teacher
//
//  Created by Mac on 16/10/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudAddToBlackListApi : YTKRequest

/*
 【黑名单--拉黑(融云也拉黑)】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/user_add_black
 传参:
	other_xid	//对方xid (家人,班级通讯录,陌生人都可以拉黑)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id other_xid:(NSString *)other_xid;


@end
