
//
//  XXESchoolAlbumCollectionViewCell.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAlbumCollectionViewCell.h"

@implementation XXESchoolAlbumCollectionViewCell


- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
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
    
}

- (void)updateCheckImage {
    
    self.checkImageView.hidden = !self.selected;
}

- (void)setUser:(XXESchoolAlbumModel *)user {
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



@end
