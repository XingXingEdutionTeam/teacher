//
//  XXESearchUNModel.h
//  teacher
//
//  Created by codeDing on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESearchUNModel : JSONModel

/** 学校的ID */
@property (nonatomic, copy)NSString <Optional>*schoolId;
/** 学校的名字 */
@property (nonatomic, copy)NSString <Optional>*schoolName;
/** 学校的省 */
@property (nonatomic, copy)NSString <Optional>*schoolProvince;
/** 学校的市 */
@property (nonatomic, copy)NSString <Optional>*schoolCity;
/** 学校的区 */
@property (nonatomic, copy)NSString <Optional>*schoolDistrict;

@end
