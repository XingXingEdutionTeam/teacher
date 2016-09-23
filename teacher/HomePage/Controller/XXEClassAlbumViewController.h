//
//  XXEClassAlbumViewController.h
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXEClassAlbumViewController : XXEBaseViewController
/** 学校的ID是不一样的 */
@property (nonatomic, strong)NSString *schoolID;
/** 班级的ID是不一样的 */
@property (nonatomic, strong)NSString *classID;

/** 身份 */
@property (nonatomic, copy)NSString *userIdentifier;
@end
