//
//  XXEMyselfBlackListModel.h
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMyselfBlackListModel : JSONModel

/*
 [xid] => 18886386
 [head_img] => app_upload/text/parent/p9.jpg
 [head_img_type] => 0
 [nickname] => 含笑半步颠
 [sex] => 女
 )
 */

@property (nonatomic, copy) NSString *xid;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *head_img_type;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *sex;

+ (NSArray*)parseResondsData:(id)respondObject;

@end
