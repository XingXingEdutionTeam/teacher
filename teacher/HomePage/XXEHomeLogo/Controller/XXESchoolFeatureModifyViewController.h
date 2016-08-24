//
//  XXESchoolFeatureModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolFeatureModifyViewController : XXEBaseViewController


@property (weak, nonatomic) IBOutlet UITextView *featureTextView;

- (IBAction)submitButton:(UIButton *)sender;



@end
