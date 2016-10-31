//
//  XXEMyselfInfoDecollectionApi.h
//  teacher
//
//  Created by Mac on 16/10/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEMyselfInfoDecollectionApi : YTKRequest

/*
 【删除/取消收藏】通用于各种取消收藏
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Global/deleteCollect
 
 传参:
	collect_id	//收藏id (如果是收藏用户,这里是xid)
	collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵 7:图片
 
 return_param_all
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id collect_id:(NSString *)collect_id collect_type:(NSString *)collect_type return_param_all:(NSString *)return_param_all;

@end
