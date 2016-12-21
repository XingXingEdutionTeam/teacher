//
//  XXESchoolIntroductionDetailViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnStrBlock) (NSString *str);

@interface XXESchoolIntroductionDetailViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;

//学校 特点
@property (nonatomic, copy) NSString *schoolIntroductionStr;
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) NSString *position;

@property (weak, nonatomic) IBOutlet UITextView *introductionDetailTextView;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;



- (void)returnStr:(ReturnStrBlock)block;

@end
