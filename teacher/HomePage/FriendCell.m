//
//  FriendCell.m
//  RCIM
//
//  Created by codeDing on 16/2/26.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "FriendCell.h"
#import "XXEfriendListMdoel.h"

@implementation FriendCell

- (void)awakeFromNib {
    // Initialization code
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



- (void)xxe_rootFriendListMessage:(XXEfriendListMdoel *)model
{
    NSLog(@"%@",model.head_img);
    NSString *headUrl = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
    self.portraitImageView.layer.cornerRadius = self.portraitImageView.bounds.size.width/2;
    self.portraitImageView.layer.masksToBounds = YES;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.userNameLabel.text = model.nickname;
    self.QQLabel.text = model.xid;
    self.sexLabel.text = model.age;
}










- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
