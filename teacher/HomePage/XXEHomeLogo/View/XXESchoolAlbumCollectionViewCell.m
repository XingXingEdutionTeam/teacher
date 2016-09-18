
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
    [self updateCheckImage];
}


- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    [self updateCheckImage];
}

- (void)updateCheckImage {
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

//    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    myImageView.tag = 11;
//    
//    CGFloat checkX = myImageView.frame.size.width - 25;
//    CGFloat checkY = myImageView.frame.size.height - 25;
//    CGFloat checkWidth = 25;
//    CGFloat checkHeight = 25;
//
//    _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(checkX, checkY, checkWidth, checkHeight)];
//    _checkImageView.image = [UIImage imageNamed:@"home_logo_pic_seleted_icon"];
//    [myImageView addSubview:_checkImageView];
//    
//    self.checkImageView.hidden = !self.selected;
//    
//    [self.contentView addSubview:myImageView];
        self.size = CGSizeMake((KScreenWidth - 4 * 10) / 3, (KScreenWidth - 4 * 10) / 3);
}




@end
