//
//  XXEContentAlbumCollectionCell.m
//  teacher
//
//  Created by codeDing on 16/9/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEContentAlbumCollectionCell.h"

@implementation XXEContentAlbumCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [self updateCheckImageView];
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    [self updateCheckImageView];
}

- (void)updateCheckImageView {
    self.checkImageView.hidden = !self.selected;
}

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    
    return self;
}
-(void)createSubViews{
    self.size = CGSizeMake((KScreenWidth - 4 * 10) / 3, (KScreenWidth - 4 * 10) / 3);
}

- (void)configterContentAblumCellPicURl:(NSString *)picUrl
{
    NSURL *url = [NSURL URLWithString:picUrl];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
}

@end
