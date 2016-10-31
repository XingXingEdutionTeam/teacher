//
//  XXERongCloudSearchFriendDetailInfoViewController.h
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERongCloudSearchFriendDetailInfoViewController : XXEBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, copy) NSString *nicknameStr;
@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *xidStr;


@end
