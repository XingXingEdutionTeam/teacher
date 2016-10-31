//
//  XXECourseManagerCourseSettingViewController.h
//  teacher
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnArrayBlock) (NSArray *resultArray);

@interface XXECourseManagerCourseSettingViewController : XXEBaseViewController

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) ReturnArrayBlock returnArrayBlock;

- (void)returnStr:(ReturnArrayBlock)block;

@end
