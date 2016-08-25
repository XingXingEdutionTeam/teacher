//
//  XXESchoolIntroductionViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolIntroductionViewController : XXEBaseViewController


@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;

@property (nonatomic, strong) NSMutableArray *contentArray;
//相册
@property (nonatomic) NSMutableArray *school_pic_groupArray;


@end
