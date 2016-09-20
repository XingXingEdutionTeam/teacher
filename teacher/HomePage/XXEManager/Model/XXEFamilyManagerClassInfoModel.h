//
//  XXEFamilyManagerClassInfoModel.h
//  teacher
//
//  Created by Mac on 16/9/20.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEFamilyManagerPersonInfoModel.h"

@interface XXEFamilyManagerClassInfoModel : JSONModel

/*
 [class_id] => 1
 [wait_num] => 1		//待审核数量
 [num] => 1			//班级已有的家长数量
 [class_name] => 一年级一班
 [parent_list] => Array
 */

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *wait_num;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, strong) NSMutableArray<XXEFamilyManagerPersonInfoModel> *parent_list;

+ (NSArray*)parseResondsData:(id)respondObject;

@end
