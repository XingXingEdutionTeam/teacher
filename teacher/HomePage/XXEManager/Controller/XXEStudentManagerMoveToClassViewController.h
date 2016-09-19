//
//  XXEStudentManagerMoveToClassViewController.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEStudentManagerMoveToClassViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;


//只针对 校长和管理员
//当前 选中 学生所在的班级
@property (nonatomic, strong) NSString *currentSelectedClassId;

@property (nonatomic, copy) NSString *schoolType;

@property (nonatomic, copy) NSString *babyId;

@end
