//
//  XXESchoolEmailModiyfViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolEmailModiyfViewController : XXEBaseViewController



@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;


- (IBAction)checkCodeButton:(UIButton *)sender;



- (IBAction)submitButton:(UIButton *)sender;


@end
