//
//  XXERecipeDetailViewController.h
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERecipeDetailViewController : XXEBaseViewController

//school_id	//学校id
@property (nonatomic, strong) NSString *schoolId;

@property (nonatomic, strong) NSMutableArray *mealPicDataSource;
//date_tm		//日期,例:2016-08-16
@property (nonatomic, copy) NSString *date_tm;
//meal_type	//餐类型,传数字(1:早餐  2:午餐  3:晚餐)
@property (nonatomic, copy) NSString *meal_type;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *cookbook_idStr;

@property (nonatomic, copy) NSString *position;


@end
