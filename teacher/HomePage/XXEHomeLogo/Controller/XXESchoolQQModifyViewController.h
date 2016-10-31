//
//  XXESchoolQQModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"


typedef void(^ReturnStrBlock) (NSString *str);

@interface XXESchoolQQModifyViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;

@property (nonatomic, copy) NSString *qqStr;
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) NSString *position;

@property (weak, nonatomic) IBOutlet UITextField *QQTextField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (void)returnStr:(ReturnStrBlock)block;

@end
