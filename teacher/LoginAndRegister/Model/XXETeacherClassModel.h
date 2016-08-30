//
//  XXETeacherClassModel.h
//  teacher
//
//  Created by codeDing on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXETeacherClassModel : JSONModel

/** 获取班级Id */
@property (nonatomic, copy)NSString <Optional>*class_id;
/** 获取班级名称 */
@property (nonatomic, copy)NSString <Optional>*className;

@end
