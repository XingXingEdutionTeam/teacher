//
//  XXESchoolCourseModel.h
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESchoolCourseModel : JSONModel

/*
 (
 [id] => 4					//课程id
 [course_name] => 对外汉语初级班		//课程名称
 [need_num] => 8				//开班人数
 [now_num] => 3				//已招人数
 [original_price] => 3500			//原价
 [now_price] => 3100				//现价
 [coin] => 0					//0:不允许猩币抵扣 1:允许猩币抵扣
 [allow_return] => 1				//0:不允许退货 1:允许退货
 [course_pic] => app_upload/text/course/lesson3.jpg	//课程首图
 [teacher_tname_group] => Array		//负责课程的老师
 (
 [0] => 梁红水
 [1] => 丁梦近
 )
 )
 
 */

@property (nonatomic, copy) NSString<Optional> *courseId;
@property (nonatomic, copy) NSString<Optional> *course_name;
@property (nonatomic, copy) NSString<Optional> *need_num;
@property (nonatomic, copy) NSString<Optional> *now_num;
@property (nonatomic, copy) NSString<Optional> *original_price;
@property (nonatomic, copy) NSString<Optional> *now_price;
@property (nonatomic, copy) NSString<Optional> *coin;
@property (nonatomic, copy) NSString<Optional> *allow_return;
@property (nonatomic, copy) NSString<Optional> *course_pic;
@property (nonatomic, strong) NSArray<Optional> *teacher_tname_group;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
