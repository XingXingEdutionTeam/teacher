//
//  XXEManagerAndHeadmasterViewController.h
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^ReturnArrayBlock)(NSMutableArray *selectedBabyInfoArray);

@interface XXEManagerAndHeadmasterViewController : XXEBaseViewController

@property (nonatomic, copy) NSString *schoolId;


@property (nonatomic, copy) ReturnArrayBlock ReturnArrayBlock;


- (void)returnArray:(ReturnArrayBlock)block;

@end
