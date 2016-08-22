//
//  XXEHomeworkIssueViewController.h
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEHomeworkIssueViewController : XXEBaseViewController


@property (weak, nonatomic) IBOutlet UIView *subjectBgView;


@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UITextField *submitTextField;

@property (weak, nonatomic) IBOutlet UIView *upImageView;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (nonatomic, copy) NSString *subjectStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *timeStr;


@property (nonatomic, copy) NSString *schoolId;

@property (nonatomic, copy) NSString *classId;


- (IBAction)certainButton:(id)sender;



@end
