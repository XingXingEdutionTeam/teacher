//
//  XXEContentAlbumCollectionViewCell.m
//  teacher
//
//  Created by codeDing on 16/8/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEContentAlbumCollectionViewCell.h"

@implementation XXEContentAlbumCollectionViewCell

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _contentImageView.contentMode = UIViewContentModeScaleToFill;
        _contentImageView.backgroundColor = XXEBackgroundColor;
    }
    return _contentImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView addSubview:self.contentImageView];
}


@end
