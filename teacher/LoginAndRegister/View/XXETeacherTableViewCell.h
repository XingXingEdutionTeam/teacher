//
//  XXETeacherTableViewCell.h
//  teacher
//
//  Created by codeDing on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCommboxView.h"
@interface XXETeacherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teacherRegisLabel;
@property (weak, nonatomic) IBOutlet UITextField *teacherRegisTextField;
@property(nonatomic ,strong) WJCommboxView *commboxView;
//@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;

@end
