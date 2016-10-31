//
//  XXERongCloudSeeNearUserListApi.h
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERongCloudSeeNearUserListApi : YTKRequest

/*
 【聊天--附近用户列表】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/search_nearby_user
 传参:
	page	//页码,用于加载,不传值系统默认1
 
    lng	//经度
	lat	//纬度
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id page:(NSString *)page lng:(NSString *)lng lat:(NSString *)lat;

@end
