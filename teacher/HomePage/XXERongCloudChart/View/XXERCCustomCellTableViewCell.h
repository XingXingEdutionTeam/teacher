//
//  XXERCCustomCellTableViewCell.h
//  teacher
//
//  Created by Mac on 16/10/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "PPDragDropBadgeView.h"
#define kCellHeight 80


@interface XXERCCustomCellTableViewCell : RCConversationBaseCell

///头像
@property (nonatomic,retain) UIImageView *avatarIV;
///真实姓名
@property (nonatomic,retain) UILabel *nameLabel;
///时间
@property (nonatomic,retain) UILabel *timeLabel;
///内容
@property (nonatomic,retain) UILabel *contentLabel;
///角标（UIView）
@property (nonatomic,retain) PPDragDropBadgeView *ppBadgeView;


@end
