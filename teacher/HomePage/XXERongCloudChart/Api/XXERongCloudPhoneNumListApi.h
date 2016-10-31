//
//  XXERongCloudPhoneNumListApi.h
//  teacher
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudPhoneNumListApi : YTKRequest

/*
 【聊天--手机通讯录列表】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/phone_contact_book
 传参:
	phone_group	//用户手机电话通讯录中的手机号,一维数组的json数据
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id phone_group:(NSString *)phone_group return_param_all:(NSString *)return_param_all;

@end
