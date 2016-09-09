//
//  XXEBatchRemoveFromBlackListApi.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEBatchRemoveFromBlackListApi : YTKRequest

/*
 【黑名单--批量移除拉黑单(融云也移除)】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Global/cancle_black_user
 
 传参:
	other_xid		//需要移除的xid,多个用逗号隔开,比如:18886386,18886387
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id other_xid:(NSString *)other_xid;

@end
