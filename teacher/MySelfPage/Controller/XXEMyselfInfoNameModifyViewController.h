//
//  XXEMyselfInfoNameModifyViewController.h
//  teacher
//
//  Created by Mac on 16/9/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnStrBlock) (NSString *str);

@interface XXEMyselfInfoNameModifyViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;


@property (nonatomic, copy) NSString *nickNameStr;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


- (IBAction)submitButton:(UIButton *)sender;

- (void)returnStr:(ReturnStrBlock)block;


@end
