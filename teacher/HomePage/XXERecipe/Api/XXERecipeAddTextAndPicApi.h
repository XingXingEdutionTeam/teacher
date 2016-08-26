//
//  XXERecipeAddTextAndPicApi.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXERecipeAddTextAndPicApi : YTKRequest

/*
 【食谱->发布】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Teacher/school_cookbook_publish
 传参:
	school_id	//学校id
	position	//身份,传数字(1教师/2班主任/3管理/4校长)
	date_tm		//日期(格式:2016-08-02 ,注:没有时分秒)
	breakfast_name	//早餐名
	lunch_name	//午餐名
	dinner_name	//晚餐
 
 -----------------------------图片 可传 可不传-----------
	breakfast_file	//早餐图片(批量上传图片)
	lunch_file	//午餐图片(批量上传图片)
	dinner_file	//晚餐图片(批量上传图片)
 
 ★在原先用的批量上传图片的格式上再加一层数组,键名分别是breakfast_file,lunch_file,dinner_file
 ***********************************************************
 【上传文件】
 接口:
 http://www.xingxingedu.cn/Global/uploadFile
 ★注: 默认传参只要appkey和backtype
 接口类型:2
 传参
	file_type	//文件类型,1图片,2视频 			  (必须)
	page_origin	//页面来源,传数字 			  (必须)
 1					//头像,含老师,家长,孩子
 2	//老师证件和学校证件
 3	//老师个人相册
 4	//学校logo
 5	//学校相册
 6	//学校视频
 7	//学校食谱
 8	//班级相册
 9	//班级作业
 10	//老师点评
 11	//小红花
 12	//商城商品
 13	//课程详情
 14	//课程评价
 15	//圈子
 
	upload_format	//上传格式, 传数字,1:单个上传  2:批量上传 (必须)
	file		//文件数据的数组名 			  (必须)
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id user_type:(NSString *)user_type file_type:(NSString *)file_type page_origin:(NSString *)page_origin upload_format:(NSString *)upload_format upImage:(UIImage *)upImage;

@end
