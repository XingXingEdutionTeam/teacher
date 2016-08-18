//
//  XXECommentStudentViewController.h
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXECommentStudentViewController : XXEBaseViewController


@property (weak, nonatomic) IBOutlet UITextView *contentTextField;

@property (weak, nonatomic) IBOutlet UILabel *contentNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UIView *upPicImageView;


@property (nonatomic, copy) NSString *schoolId;

@property (nonatomic, copy) NSString *classId;

- (IBAction)addButtonClick:(UIButton *)sender;


- (IBAction)certenButtonClick:(UIButton *)sender;

@end
