//
//  XXEIdentityListModel.h
//  teacher
//
//  Created by codeDing on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEIdentityListModel : JSONModel

/** 班级名称 */
@property (nonatomic, copy)NSString <Optional>*class_name;
/** 教学内容 比如 语文 音乐 */
@property (nonatomic, copy)NSString <Optional>*teach_course;
/** 学校Id */
@property (nonatomic, copy)NSString <Optional>*school_id;
/** 学校类型 */
@property (nonatomic, copy)NSString <Optional>*school_type;
/** 学校名称 */
@property (nonatomic, copy)NSString <Optional>*school_name;
/** 学校Logo */
@property (nonatomic, copy)NSString <Optional>*school_logo;
/** 状态 0为未审核 1为已审核 */
@property (nonatomic, copy)NSString <Optional>*condit;
/** 审核人 */
@property (nonatomic, copy)NSString <Optional>*examiner_name;
/** 证书 */
@property (nonatomic, strong)NSArray *certificate;

@end
