//
//  XXEBabyFamilyInfoDetailViewController.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEBabyFamilyInfoDetailViewController : XXEBaseViewController

@property (nonatomic, copy) NSString *baby_id;

@property (nonatomic, copy) NSString *parent_id;

//家人 是否 收藏
@property (nonatomic) BOOL isCollected;

@property (nonatomic, copy) NSString *fromFlagStr;


@end
