//
//  XXEHomePageClassModel.h
//  teacher
//
//  Created by codeDing on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol XXEHomePageClassModel

@end

@interface XXEHomePageClassModel : JSONModel
/** 班级名称 */
@property (nonatomic, copy)NSString <Optional>*class_name;
/** 班级Id */
@property (nonatomic, copy)NSString <Optional>*class_id;
/** 职教身份: 1.教师/2.班主任/3.管理/4.校长 */
@property (nonatomic, copy)NSString <Optional>*position;


@end
