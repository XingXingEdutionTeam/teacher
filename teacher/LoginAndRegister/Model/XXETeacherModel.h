//
//  XXETeacherModel.h
//  teacher
//
//  Created by codeDing on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXETeacherModel : JSONModel

/** 学校ID */
@property (nonatomic, copy)NSString <Optional>*schoolId;
/** 学校名字 */
@property (nonatomic, copy)NSString <Optional>*name;
/** 学校类型 */
@property (nonatomic, copy)NSString <Optional>*type;
/** 学校所在的省 */
@property (nonatomic, copy)NSString <Optional>*province;
/** 学校所在的城市 */
@property (nonatomic, copy)NSString <Optional>*city;
/** 学校所在的区 */
@property (nonatomic, copy)NSString <Optional>*district;
//详细地址
@property (nonatomic, copy)NSString <Optional>*address;
//电话
@property (nonatomic, copy)NSString <Optional>*tel;


@end
