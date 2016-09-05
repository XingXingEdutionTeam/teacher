//
//  XXESchoolEmailModiyfViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnStrBlock) (NSString *str);


@interface XXESchoolEmailModiyfViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;

@property (nonatomic, copy) NSString *emailStr;
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;


@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (void)returnStr:(ReturnStrBlock)block;

//验证邮箱 ???
- (BOOL)validateEmail:(NSString *)email;


@end
