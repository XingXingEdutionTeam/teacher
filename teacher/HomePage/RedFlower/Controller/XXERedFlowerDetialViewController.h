//
//  XXERedFlowerDetialViewController.h
//  teacher
//
//  Created by Mac on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXERedFlowerDetialViewController : UIViewController

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


@end
