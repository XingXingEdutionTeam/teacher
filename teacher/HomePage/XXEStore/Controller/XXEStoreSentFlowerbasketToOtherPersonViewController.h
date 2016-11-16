//
//  XXEStoreSentFlowerbasketToOtherPersonViewController.h
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

typedef void(^returnArrayBlock)(NSMutableArray *returnArray);

@interface XXEStoreSentFlowerbasketToOtherPersonViewController : XXEBaseViewController

@property (nonatomic, copy) returnArrayBlock returnArrayBlock;


- (void)returnArrayBlock:(returnArrayBlock)block;

@end
