//
//  XXECommentReplyViewController.h
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXECommentReplyViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *comment_id;

@property (nonatomic, copy) NSString *babyName;
@property (nonatomic, copy) NSString *askContent;
@property (nonatomic, copy) NSString *askTime;

@property (weak, nonatomic) IBOutlet UILabel *babyNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *askContentTextView;

@property (weak, nonatomic) IBOutlet UILabel *askTimeLabel;

@property (weak, nonatomic) IBOutlet UITextView *replyTextField;


@property (weak, nonatomic) IBOutlet UILabel *replyNumLabel;
@property (weak, nonatomic) IBOutlet UIView *upImageView;



- (IBAction)certainButton:(UIButton *)sender;


@end
