//
//  XXEClassManagerClassReleaseViewController.h
//  teacher
//
//  Created by Mac on 16/9/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEClassManagerClassReleaseViewController : XXEBaseViewController


@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, copy) NSString *schoolType;

@property (nonatomic, copy) NSString *position;

@property (weak, nonatomic) IBOutlet UITextField *gradeTextField;

@property (weak, nonatomic) IBOutlet UITextField *classTextField;


@property (weak, nonatomic) IBOutlet UITextField *classNumTextField;

@property (weak, nonatomic) IBOutlet UITextField *teacherTextField;

- (IBAction)releaseButton:(UIButton *)sender;


@end
