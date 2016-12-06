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
    [self updateCheckImage];
}


- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.user = nil;
    self.disabled = NO;
    
    [self updateCheckImage];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self updateCheckImage];
}

- (void)setDisabled:(BOOL)disabled {
    if (_disabled == disabled) {
        return;
    }
    _disabled = disabled;
    
    //    [self updateViews];
}

- (void)updateCheckImage {
    self.checkImageView.hidden = !self.selected;
}

- (void)setUser:(XXEAlbumDetailsModel *)user {
    if (_model == user) {
        return;
    }
    _model = user;
    
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
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"album_icon"]];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.clipsToBounds = YES;
}

@end
