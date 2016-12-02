//
//  XXERecipeModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERecipeModifyViewController : XXEBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mealIconImageView;


@property (weak, nonatomic) IBOutlet UILabel *mealNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *upPicImageView;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *cookbook_idStr;
@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, copy) NSString *position;

- (IBAction)certainButton:(UIButton *)sender;



@end
