//
//  XXEGlobalCollectApi.h
//  teacher
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEGlobalCollectApi : YTKRequest

/*
 【收藏】通用于各种收藏
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Global/collect
 
 传参:
	collect_id	//收藏id (如果是收藏用户,这里是xid)
	collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type collect_id:(NSString *)collect_id collect_type:(NSString *)collect_type;

@end
