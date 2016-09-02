//
//  XXEStudentSignInManagerAndHeadmasterViewController.h
//  teacher
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEStudentSignInManagerAndHeadmasterViewController : XXEBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIButton *unsignNumButton;

@property (weak, nonatomic) IBOutlet UIButton *signNumButton;

@property (weak, nonatomic) IBOutlet UIView *upBgView;

@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, copy) NSString *schoolType;

@end
