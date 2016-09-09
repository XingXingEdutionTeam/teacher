//
//  XXERedFlowerDetialViewController.h
//  teacher
//
//  Created by Mac on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERedFlowerDetialViewController : XXEBaseViewController

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy) NSString *content;
 //照片墙 照片数组
@property (nonatomic, strong) NSArray *picWallArray;
//头像
@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *collect_conditStr;
@property (nonatomic, copy) NSString *collect_id;


@end
