//
//  XXEManagerHeadmasterPrivateViewController.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
#import "QHNavSliderMenu.h"

@interface XXEManagerHeadmasterPrivateViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, copy) NSString *schoolType;

@property (nonatomic)QHNavSliderMenuType menuType;

@end
