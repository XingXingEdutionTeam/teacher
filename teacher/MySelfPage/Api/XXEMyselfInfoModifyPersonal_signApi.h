//
//  XXEMyselfInfoModifyPersonal_signApi.h
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoModifyPersonal_signApi : YTKRequest

/*
 【编辑我的资料】
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/edit_my_info
 
 传参:
	personal_sign		//个性签名
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type personal_sign:(NSString *)personal_sign;

@end
