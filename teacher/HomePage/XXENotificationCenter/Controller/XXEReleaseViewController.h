//
//  XXEReleaseViewController.h
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEReleaseViewController : XXEBaseViewController


@property (nonatomic, copy) NSString *schoolId;

@property (nonatomic, copy) NSString *classId;

@property (nonatomic, copy) NSString *position;

@property (weak, nonatomic) IBOutlet UIView *scopeView;

@property (weak, nonatomic) IBOutlet UIView *auditView;

@property (weak, nonatomic) IBOutlet UIView *subjectView;

@property (weak, nonatomic) IBOutlet UILabel *scopeLabel;


@property (weak, nonatomic) IBOutlet UILabel *auditLabel;


@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;


@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *certainButton;



@end
