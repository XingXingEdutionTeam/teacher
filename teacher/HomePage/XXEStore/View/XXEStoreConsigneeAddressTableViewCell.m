

//
//  XXEStoreConsigneeAddressTableViewCell.m
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreConsigneeAddressTableViewCell.h"

@implementation XXEStoreConsigneeAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    _phoneLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    _defaultAddressLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    _addressLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
