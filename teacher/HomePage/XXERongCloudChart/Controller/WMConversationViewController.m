



//
//  WMConversationViewController.m
//  RCIM
//
//  Created by codeDing on 16/3/6.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "WMConversationViewController.h"
#import "XXERongCloudReplyListDetailViewController.h"


@interface WMConversationViewController ()

@end

@implementation WMConversationViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSLog(@"WMConversationViewController  ---   聊天界面 ----");
}

/*!
 点击Cell中头像的回调
 
 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    
    XXERongCloudReplyListDetailViewController *rongCloudReplyListDetailVC = [[XXERongCloudReplyListDetailViewController alloc] init];
    
    rongCloudReplyListDetailVC.other_xid = userId;
    
    [self.navigationController pushViewController:rongCloudReplyListDetailVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
