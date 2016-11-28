//
//  XXECourseOrderListModel.h
//  teacher
//
//  Created by Mac on 2016/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXECourseOrderListModel : JSONModel


/*
 (
 [id] => 2						//订单id
 [course_id] => 7
 [school_id] => 10
 [order_index] => 236457342				//订单号
 [date_tm] => 1463645734				//时间
 [pay_price] => 1800.00				//金额
 [pic] => app_upload/text/course/lesson4.jpg		//首图
 [school_name] => 上海长青树				//机构名称
 [course_name] => 新概念英语初级			//课程名
 )
 */
@property (nonatomic, copy) NSString *course_order_Id;
@property (nonatomic, copy) NSString *course_id;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *order_index;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *pay_price;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *school_name;
@property (nonatomic, copy) NSString *course_name;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
