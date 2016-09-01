
//
//  XXESchoolAlbumCollectionViewCell.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolAlbumCollectionViewCell.h"

@implementation XXESchoolAlbumCollectionViewCell


//- (void)awakeFromNib {
//    // Initialization code
//    [self updateCheckImage];
//}
//
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    
//    self.model = nil;
//    self.disabled = NO;
//    
//    [self updateCheckImage];
//}
//
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    
//    [self updateCheckImage];
//}
//
//- (void)setDisabled:(BOOL)disabled {
//    if (_disabled == disabled) {
//        return;
//    }
//    _disabled = disabled;
//    
////    [self updateViews];
//}
//
//- (void)updateCheckImage {
//    self.checkImageView.hidden = !self.selected;
//}
//
//- (void)setModel:(XXESchoolAlbumModel *)model{
//    if (_model == model) {
//        return;
//    }
//    _model = model;
//    
////    [self updateViews];
//}

//- (void)updateViews {
//    [self updateUserView];
//}

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];

    }

    return self;
}
-(void)createSubViews{

    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myImageView.tag = 11;
    
    CGFloat checkX = myImageView.frame.size.width - 25;
    CGFloat checkY = myImageView.frame.size.height - 25;
    CGFloat checkWidth = 25;
    CGFloat checkHeight = 25;

    UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(checkX, checkY, checkWidth, checkHeight)];
    checkImageView.image = [UIImage imageNamed:@"home_logo_pic_seleted_icon"];
    [myImageView addSubview:checkImageView];
    
    [self.contentView addSubview:myImageView];
}



- (void)setSchoolPicName:(NSString *)schoolPicName{
    _schoolPicName = schoolPicName;
    UIImageView *iconImageView = [self viewWithTag:11];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_schoolPicName] placeholderImage:nil];

}



@end
