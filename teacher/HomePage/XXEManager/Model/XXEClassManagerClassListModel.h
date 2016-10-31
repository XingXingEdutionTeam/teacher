//
//  XXEClassManagerClassListModel.h
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEClassManagerClassListModel : JSONModel

/*
 (
 [id] => 1
 [school_type] => 2
 [school_id] => 1
 [grade] => 1
 [class] => 1
 [num_up] => 50
 [num_actual] => 0
 [teacher_boss] => 		//班主任姓名
 [graduate_tm] => 1627747200
 [condit] => 1		//0:待审核  1:审核通过
 [class_name] => 一年级一班
 [school_logo] => 
 )
 */

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *school_type;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *classNum;
@property (nonatomic, copy) NSString *num_up;
@property (nonatomic, copy) NSString *num_actual;
@property (nonatomic, copy) NSString *teacher_boss;
@property (nonatomic, copy) NSString *graduate_tm;
@property (nonatomic, copy) NSString *condit;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *school_logo;


+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;



@end
