//
//  XXESchoolAddressModifyViewController.h
//  teacher
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolAddressModifyViewController : XXEBaseViewController


//学校地址
@property (nonatomic, copy) NSString *schoolAddressStr;

@property (weak, nonatomic) IBOutlet UITextView *schoolAddressTextView;


- (IBAction)submitButton:(UIButton *)sender;



@end
