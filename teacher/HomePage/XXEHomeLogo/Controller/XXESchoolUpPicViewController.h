//
//  XXESchoolUpPicViewController.h
//  teacher
//
//  Created by Mac on 16/8/28.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXESchoolUpPicViewController : XXEBaseViewController

@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;

@property (nonatomic, assign)NSInteger t;

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, copy) NSString *vedioName;


@end
