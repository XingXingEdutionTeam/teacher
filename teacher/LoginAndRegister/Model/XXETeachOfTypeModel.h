//
//  XXETeachOfTypeModel.h
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXETeachOfTypeModel : JSONModel

/** 教学类型ID */
@property (nonatomic, copy)NSString <Optional>*teachTypeId;
/** 教学类型名称 */
@property (nonatomic, copy)NSString <Optional>*teachTypeName;
@end
