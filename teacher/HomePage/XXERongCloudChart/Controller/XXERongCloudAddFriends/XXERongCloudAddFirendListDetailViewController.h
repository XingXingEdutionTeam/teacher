//
//  XXERongCloudAddFirendListDetailViewController.h
//  teacher
//
//  Created by Mac on 16/10/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXERongCloudAddFirendListDetailViewController : XXEBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *xidLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (weak, nonatomic) IBOutlet UIButton *addToBlackListButton;

@property (weak, nonatomic) IBOutlet UIButton *reportButton;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (nonatomic, copy) NSString *other_xid;
@property (nonatomic, copy) NSString *requestIdStr;

@end
