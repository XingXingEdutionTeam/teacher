//
//  XXEFriendMyCircleViewController.h
//  teacher
//
//  Created by codeDing on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "DFTimelineView.h"

typedef void(^XXEFriendMyCircleViewControllerBlock)();

@interface XXEFriendMyCircleViewController : DFUserTimeLineViewController

@property (nonatomic, assign)NSInteger otherXid;
@property (nonatomic, copy) XXEFriendMyCircleViewControllerBlock friendCirccleRefreshBlock;

@end
