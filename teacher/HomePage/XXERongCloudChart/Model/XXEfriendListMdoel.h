//
//  XXEfriendListMdoel.h
//  teacher
//
//  Created by codeDing on 16/9/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEfriendListMdoel : JSONModel
/** 朋友列表的XID */
@property (nonatomic, copy)NSString <Optional> *xid;
/** 昵称 */
@property (nonatomic, copy)NSString <Optional>*nickname;
/** 用户头像 */
@property (nonatomic, copy)NSString <Optional>*head_img;
/** 用户头像的来源 */
@property (nonatomic, copy)NSString <Optional>*head_img_type;
/** 用户年龄 */
@property (nonatomic, copy)NSString <Optional>*age;


@end
