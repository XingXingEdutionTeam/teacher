//
// SettingPersonInfoViewController.h
//  Created by codeDing on 16/1/16.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "XXEBaseViewController.h"
#import <Availability.h>

@interface SettingPersonInfoViewController : XXEBaseViewController 
@property(nonatomic,strong) NSArray *relationArray;//与学生关系
@property (nonatomic,strong) UIView *comBackView;

@property(nonatomic,strong) NSArray *parentsIDCardArray;//家长身份证号
@property (nonatomic,strong) UIView *parentsIDCardComBackView;

@property(nonatomic,strong) NSArray *studentIDCardArray;//学生身份证号
@property (nonatomic,strong) UIView *studentIDCardComBackView;


@property(nonatomic ,copy)NSString * phone;
@property(nonatomic ,copy)NSString * pwd;

/** 用户的电话号码 */
@property (nonatomic, copy)NSString *userSettingPhoneNum;
/** 用户的密码 */
@property (nonatomic, copy)NSString *userSettingPassWord;
/** 登录类型 */
@property (nonatomic, copy)NSString *login_type;


@end
