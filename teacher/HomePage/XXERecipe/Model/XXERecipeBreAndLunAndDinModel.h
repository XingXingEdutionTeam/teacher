//
//  XXERecipeBreAndLunAndDinModel.h
//  teacher
//
//  Created by Mac on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEMealModel.h"


@interface XXERecipeBreAndLunAndDinModel : JSONModel


/*
 [date_tm] => 1470412800
 [breakfast] => Array
 [lunch] => Array
 [dinner] => Array
 */
/*
 @protocol ProductModel
 @end
 
 @interface ProductModel : JSONModel
 @property (assign, nonatomic) int id;
 @property (strong, nonatomic) NSString* name;
 @property (assign, nonatomic) float price;
 @end
 
 @implementation ProductModel
 @end
 
 @interface OrderModel : JSONModel
 @property (assign, nonatomic) int order_id;
 @property (assign, nonatomic) float total_price;
 @property (strong, nonatomic) NSArray<ProductModel>* products;
 @end
 
 @implementation OrderModel
 @end
 */




//年-月-日 星期 几
@property (nonatomic, copy) NSString *date_tm;
//早餐
@property (strong, nonatomic) NSArray<XXEMealModel>* breakfastArray;
//午餐
@property (strong, nonatomic) NSArray<XXEMealModel>* lunchArray;
//晚餐
@property (strong, nonatomic) NSArray<XXEMealModel>* dinnerArray;


@end
