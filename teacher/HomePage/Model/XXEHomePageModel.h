//
//  XXEHomePageModel.h
//  teacher
//
//  Created by codeDing on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEHomePageSchoolModel.h"

@interface XXEHomePageModel : JSONModel
/** 年龄 */
@property (nonatomic, copy)NSString <Optional> *age;
/** 头像 */
@property (nonatomic, copy)NSString <Optional>*head_img;
/** 用户图像的来源 0 为上传图像 1为第三方图像 */
@property (nonatomic, copy)NSString <Optional>*head_img_type;
/** 用户姓名 */
@property (nonatomic, copy)NSString <Optional>*tname;
/** 性别 */
@property (nonatomic, copy)NSString <Optional>*sex;
/** 个性签名 */
@property (nonatomic, copy)NSString <Optional>*personal_sign;
/** 等级 */
@property (nonatomic, copy)NSString <Optional>*lv;
/** 可用星币 */
@property (nonatomic, copy)NSString <Optional>*coin_able;
/** 当前猩币总数 */
@property (nonatomic, copy)NSString <Optional>*coin_total;
/** 升级下一级需要猩币数 */
@property (nonatomic, copy)NSString <Optional>*next_grade_coin;
/** 可用花篮 */
@property (nonatomic, copy)NSString <Optional>*fbasket_able;
/** 可用花朵 */
@property (nonatomic, copy)NSString <Optional>*flower_able;
/** 学校logo */
@property (nonatomic, copy)NSString <Optional>*school_logo;
/** 学校数组 */
@property (nonatomic, strong)NSArray <XXEHomePageSchoolModel>*school_info;


@end
