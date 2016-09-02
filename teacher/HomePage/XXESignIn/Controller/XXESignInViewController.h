//
//  XXESignInViewController.h
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

#import "QHNavSliderMenu.h"

@interface XXESignInViewController : XXEBaseViewController

@property (nonatomic) QHNavSliderMenuType menuType;

@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, copy) NSString *schoolType;


@end
