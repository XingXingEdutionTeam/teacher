//
//  XXEMyselfInfoGraduateInstitutionsViewController.h
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnStrBlock) (NSString *str);

@interface XXEMyselfInfoGraduateInstitutionsViewController : XXEBaseViewController

@property (nonatomic, copy) ReturnStrBlock returnStrBlock;

- (void)returnStr:(ReturnStrBlock)block;

@end
