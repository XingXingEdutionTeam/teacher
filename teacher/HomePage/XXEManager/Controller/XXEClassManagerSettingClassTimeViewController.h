//
//  XXEClassManagerSettingClassTimeViewController.h
//  teacher
//
//  Created by Mac on 16/9/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnStrBlock) (NSString *str);

@interface XXEClassManagerSettingClassTimeViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, copy) NSString *schoolType;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;


@property (weak, nonatomic) IBOutlet UITextField *startMonthTextField1;

@property (weak, nonatomic) IBOutlet UITextField *startMonthTextField2;

@property (weak, nonatomic) IBOutlet UITextField *endMonthTextField1;

@property (weak, nonatomic) IBOutlet UITextField *endMonthTextField2;


- (IBAction)submitButton:(UIButton *)sender;

- (void)returnStr:(ReturnStrBlock)block;

@end
