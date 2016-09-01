//
//  XXEMyClassAlbumTableViewCell.m
//  teacher
//
//  Created by codeDing on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyClassAlbumTableViewCell.h"

@implementation XXEMyClassAlbumTableViewCell

- (void)configerGetClassAlubmMessage:(XXEMySelfAlbumModel *)model
{
    NSString *picUrl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.album_pic];
    
    [self.classAlubmImgeView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@""]];
    NSString *times = [XXETool dateAboutStringFromNumberTimer:model.date_tm];
    self.classAlubmTimeLabel.text = times;
    self.classAlubmNameLabel.text = model.album_name;
    self.classAlubmPageLabel.text = [NSString stringWithFormat:@"共%@张",model.pic_num];
    
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
