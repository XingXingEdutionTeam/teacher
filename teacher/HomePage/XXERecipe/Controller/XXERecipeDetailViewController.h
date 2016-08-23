//
//  XXERecipeDetailViewController.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERecipeDetailViewController : XXEBaseViewController


@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSMutableArray *mealPicDataSource;

@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *cookbook_idStr;


@end
