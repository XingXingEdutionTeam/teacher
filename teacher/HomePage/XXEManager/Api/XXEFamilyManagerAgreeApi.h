//
//  XXEFamilyManagerAgreeApi.h
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEFamilyManagerAgreeApi : YTKRequest

/*
 【家长管理->审核通过】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/manage_parent_agree_action
 传参:
	examine_id	//审核通知id
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id examine_id:(NSString *)examine_id;

@end
