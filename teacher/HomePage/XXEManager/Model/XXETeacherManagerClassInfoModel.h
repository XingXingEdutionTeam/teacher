//
//  XXETeacherManagerClassInfoModel.h
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXETeacherManagerPersonInfoModel.h"


@interface XXETeacherManagerClassInfoModel : JSONModel

/*
 [class_id] => 1
 [wait_num] => 1
 [num] => 1
 [class_name] => 一年级一班
 [teacher_list] => Array
 */

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *wait_num;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, strong) NSMutableArray<XXETeacherManagerPersonInfoModel> *teacher_list;

+ (NSArray*)parseResondsData:(id)respondObject;

@end
