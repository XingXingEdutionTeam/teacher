//
//  XXESchoolPhoneNumModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolPhoneNumModifyViewController : XXEBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;


@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@property (weak, nonatomic) IBOutlet UIButton *checkCodeButton;


@property (nonatomic, strong) NSString *schoolId;


//如果  是 从 "我的"跳转 进来  fromMyselfInfo
@property (nonatomic, copy) NSString *flagStr;






@end
