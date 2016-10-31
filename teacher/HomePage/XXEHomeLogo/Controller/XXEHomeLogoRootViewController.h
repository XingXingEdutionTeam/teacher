//
//  XXEHomeLogoRootViewController.h
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEHomeLogoRootViewController : XXEBaseViewController


@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, strong) NSMutableArray *childViews;

@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) NSString *position;

@property (nonatomic, strong) NSMutableArray *buttonArray;




@end
