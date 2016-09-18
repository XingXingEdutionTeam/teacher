//
//  XXEDeleteSchoolPicApi.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXEDeleteSchoolPicApi : YTKRequest

/*
 【学校相册->删除图片】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/delete_school_pic
 传参:
	school_id		//学校id(必须传参)
	position		//身份 (必须传参),只允许管理和校长才可以修改学校信息
	pic_id_str		//图片id (如果是批量删除,多个多号隔开)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id school_id:(NSString *)school_id position:(NSString *)position pic_id_str:(NSString *)pic_id_str;


@end
