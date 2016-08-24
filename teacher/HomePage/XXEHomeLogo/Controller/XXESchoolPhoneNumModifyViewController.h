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




- (IBAction)checkCodeButton:(UIButton *)sender;


- (IBAction)submitButton:(UIButton *)sender;






@end
