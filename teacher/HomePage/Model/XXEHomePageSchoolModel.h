//
//  XXEHomePageSchoolModel.h
//  teacher
//
//  Created by codeDing on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEHomePageClassModel.h"

@protocol XXEHomePageSchoolModel
@end

@interface XXEHomePageSchoolModel : JSONModel

/** 小学名称 */
@property (nonatomic, copy)NSString <Optional>*school_name;
/** 学校Id */
@property (nonatomic, copy)NSString <Optional>*school_id;
//学校 logo
@property (nonatomic, copy) NSString <Optional>*school_logo;
/** 学校类型:其他模块也都需要这个参数 */
@property (nonatomic, copy)NSString <Optional>*school_type;
/** 一个学校对应的班级 */
@property (nonatomic, strong)NSArray <XXEHomePageClassModel>*class_info;

@end
