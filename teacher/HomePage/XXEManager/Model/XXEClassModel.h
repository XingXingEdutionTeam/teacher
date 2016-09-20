//
//  XXEClassModel.h
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEStudentModel.h"

@interface XXEClassModel : JSONModel

/*
 [class_id] => 1
 [class_name] => 一年级一班
 [num] => 10			//班级人数
 [baby_list] => Array
 */
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, strong) NSMutableArray<XXEStudentModel> *baby_list;

+ (NSArray*)parseResondsData:(id)respondObject;


@end
