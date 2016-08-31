//
//  XXESchoolAddressModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnStrBlock) (NSString *str);

@interface XXESchoolAddressModifyViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;

//学校地址
@property (nonatomic, copy) NSString *schoolAddressStr;

@property (weak, nonatomic) IBOutlet UITextView *schoolAddressTextView;


- (IBAction)submitButton:(UIButton *)sender;

- (void)returnStr:(ReturnStrBlock)block;

@end
