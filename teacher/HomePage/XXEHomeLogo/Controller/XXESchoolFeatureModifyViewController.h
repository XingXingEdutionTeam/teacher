//
//  XXESchoolFeatureModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnStrBlock) (NSString *str);

@interface XXESchoolFeatureModifyViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;

//学校 特点
@property (nonatomic, copy) NSString *schoolfeatureStr;
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *flagStr;

@property (weak, nonatomic) IBOutlet UITextView *featureTextView;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;



- (void)returnStr:(ReturnStrBlock)block;

@end
