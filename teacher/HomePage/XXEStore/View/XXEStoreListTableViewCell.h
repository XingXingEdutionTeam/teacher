//
//  XXEStoreListTableViewCell.h
//  teacher
//
//  Created by Mac on 16/11/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXEStoreListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;


@property (weak, nonatomic) IBOutlet UILabel *xingbiLabel;


@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;


@end
