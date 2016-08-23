//
//  XXERecipePicDeleteApi.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERecipePicDeleteApi : YTKRequest

/*
 【食谱->删除图片】
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/cookbook_pic_delete
 
 
 传参:
	position	//身份,传数字(1教师/2班主任/3管理/4校长)
	cookbook_id	//食谱id
	pic_id		//图片id
 */
- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type pic_id:(NSString *)pic_id position:(NSString *)position cookbook_id:(NSString *)cookbook_id;


@end
