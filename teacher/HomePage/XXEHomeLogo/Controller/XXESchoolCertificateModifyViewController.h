//
//  XXESchoolCertificateModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolCertificateModifyViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;


@property (weak, nonatomic) IBOutlet UIView *upPicBgView;


- (IBAction)submitButton:(UIButton *)sender;


@end
