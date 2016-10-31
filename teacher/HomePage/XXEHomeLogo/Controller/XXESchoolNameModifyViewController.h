//
//  XXESchoolNameModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnStrBlock) (NSString *str);

@interface XXESchoolNameModifyViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;

//学校名称
@property (nonatomic, copy) NSString *schoolNameStr;
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) NSString *position;

@property (weak, nonatomic) IBOutlet UITextView *schoolNameTextView;


- (IBAction)submitButton:(UIButton *)sender;

- (void)returnStr:(ReturnStrBlock)block;

@end
