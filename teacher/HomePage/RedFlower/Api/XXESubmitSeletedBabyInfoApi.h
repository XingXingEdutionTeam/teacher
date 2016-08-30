//
//  XXESubmitSeletedBabyInfoApi.h
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXESubmitSeletedBabyInfoApi : YTKRequest

/*
 【小红花->点击赠送】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/action_give_flower
 
 传参:
 position	//教职身份
 baby_info	//★二维数组的json数据,每一维数组含baby_id,school_id,class_id (请使用孩子列表获得的数据)
 con		//赠言
 
 file	//批量上传图片,app上漏写了上传图片
 */

- (id)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type position:(NSString *)position baby_info:(NSString *)jsonString con:(NSString *)con;


@end
