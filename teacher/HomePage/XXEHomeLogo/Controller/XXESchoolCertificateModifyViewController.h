//
//  XXESchoolCertificateModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolCertificateModifyViewController : XXEBaseViewController


@property (weak, nonatomic) IBOutlet UITextView *certificateTextView;

@property (weak, nonatomic) IBOutlet UIView *upPicBgView;


- (IBAction)submitButton:(UIButton *)sender;


@end
