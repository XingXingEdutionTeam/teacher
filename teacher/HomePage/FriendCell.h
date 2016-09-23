//
//  FriendCell.h
//  RCIM
//
//  Created by codeDing on 16/2/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXEfriendListMdoel;
@interface FriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;



@property (weak, nonatomic) IBOutlet UILabel *sexLabel;


@property (weak, nonatomic) IBOutlet UILabel *QQLabel;

- (void)xxe_rootFriendListMessage:(XXEfriendListMdoel *)model;


@end
