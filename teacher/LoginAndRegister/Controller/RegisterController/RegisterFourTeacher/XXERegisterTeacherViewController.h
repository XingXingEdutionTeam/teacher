//
//  XXERegisterTeacherViewController.h
//  teacher
//
//  Created by codeDing on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERegisterTeacherViewController : XXEBaseViewController

/** 用户的姓名 */
@property (nonatomic, copy)NSString *userName;
/** 用户性别 */
@property (nonatomic, copy)NSString *userSex;
/** 用户年龄 */
@property (nonatomic, copy)NSString *userAge;
/** 用户的身份证号 */
@property (nonatomic, copy)NSString *userIDCarNum;
/** 用户护照 */
@property (nonatomic, copy)NSString *teacherPassport;
/** 用户的身份 */
@property (nonatomic, copy)NSString *userIdentifier;
/** 用户名 */
@property (nonatomic, copy)NSString *userPhoneNum;
/** 用户密码 */
@property (nonatomic, copy)NSString *userPassword;
/** 用户头像 */
@property (nonatomic, copy)UIImage *userAvatarImage;
/** 登录类型 */
@property (nonatomic, copy)NSString *login_type;

@end
