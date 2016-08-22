//
//  XXEMealPicArrModel.h
//  teacher
//
//  Created by Mac on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "XXEMealPicModel.h"


@protocol XXEMealPicArrModel

@end


@interface XXEMealPicArrModel : JSONModel

@property (nonatomic, strong) NSArray<XXEMealPicModel > *mealDetailPicArr;

@end
