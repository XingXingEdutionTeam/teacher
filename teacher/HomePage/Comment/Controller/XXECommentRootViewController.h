//
//  XXECommentRootViewController.h
//  teacher
//
//  Created by Mac on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXECommentRootViewController : UIViewController

@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, strong) NSMutableArray *childViews;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end
