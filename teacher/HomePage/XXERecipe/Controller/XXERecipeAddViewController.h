//
//  XXERecipeAddViewController.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERecipeAddViewController : XXEBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;


@property (weak, nonatomic) IBOutlet UITextView *breakfastTextView;

@property (weak, nonatomic) IBOutlet UITextView *lunchTextView;

@property (weak, nonatomic) IBOutlet UITextView *dinnerTextView;


@property (weak, nonatomic) IBOutlet UIView *breakfastUpImageView;

@property (weak, nonatomic) IBOutlet UIView *lunchUpImageView;

@property (weak, nonatomic) IBOutlet UIView *dinnerUpImageView;





@property (nonatomic, strong) NSString *schoolId;



- (IBAction)certainButton:(UIButton *)sender;




@end
