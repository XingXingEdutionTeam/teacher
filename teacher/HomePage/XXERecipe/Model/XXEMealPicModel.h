//
//  XXEMealPicModel.h
//  teacher
//
//  Created by Mac on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol XXEMealPicModel

@end


@interface XXEMealPicModel : JSONModel

/*
 [0] => Array(
 [id] => 89
 [pic] => app_upload/text/school_food/1010.jpg
 )
 */

@property (nonatomic, copy) NSString *picIdStr;
@property (nonatomic, copy) NSString *pic;


+ (JSONKeyMapper *)keyMapper;

@end
