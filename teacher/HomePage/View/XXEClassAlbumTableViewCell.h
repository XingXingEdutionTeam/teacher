//
//  XXEClassAlbumTableViewCell.h
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXEClassAlbumModel.h"

@interface XXEClassAlbumTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *LeftImageView;
@property (nonatomic, strong)UIImageView *MiddleImageView;
@property (nonatomic, strong)UIImageView *rightImageView;
@property (nonatomic, strong)UILabel *titleLabel;
- (void)getTheImageViewData:(NSArray *)model;

@end
