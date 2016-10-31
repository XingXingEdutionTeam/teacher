//
//  XXEXingClassRoomSearchApi.h
//  teacher
//
//  Created by Mac on 16/10/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEXingClassRoomSearchApi : YTKRequest

/*
 【猩课堂--显示热门关键词(老师,课程,机构通用)】
 接口类型:1
 接口:
 http://www.xingxingedu.cn/Global/xkt_top_keywords
 传参:
	date_type		//需要查询的数据类型,填数字 1: 老师  2:课程 3:机构
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id date_type:(NSString *)date_type;


@end
