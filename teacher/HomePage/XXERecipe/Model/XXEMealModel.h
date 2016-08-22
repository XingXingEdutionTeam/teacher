//
//  XXEMealModel.h
//  teacher
//
//  Created by Mac on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEMealPicArrModel.h"


@protocol XXEMealModel

@end

@interface XXEMealModel : JSONModel

/*
 [title] => 豆浆,养身粥,面包
 [pic_arr] => Array
 (
 [0] => Array(
 [id] => 89
 [pic] => app_upload/text/school_food/1010.jpg
 )
 [2] => Array(
 [id] => 89
 [pic] => app_upload/text/school_food/1010.jpg
 )
 
 )
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic ,strong) NSArray <XXEMealPicArrModel> *mealPicArray;



@end
