//
//  XXESchoolIntroductionDetailViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolIntroductionDetailViewController : XXEBaseViewController


@property (weak, nonatomic) IBOutlet UITextView *introductionDetailTextView;


- (IBAction)submitButton:(UIButton *)sender;


@end
