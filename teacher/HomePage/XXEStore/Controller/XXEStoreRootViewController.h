//
//  XXEStoreRootViewController.h
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEStoreRootViewController : UIViewController
//背景 scrollview
@property (nonatomic, strong) UIScrollView *myScrollView;
//子视图 数组
@property (nonatomic, strong) NSMutableArray *childViews;

//toolBar 上 控制器按钮 数组
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end
