//
//  XXERongCloudSeeNearUserListModel.h
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXERongCloudSeeNearUserListModel : JSONModel

/*
 (
 [id] => 4
 [xid] => 18886177
 [nickname] => 晴雨
 [sex] => 女
 [head_img] => app_upload/text/p_head4.jpg
 [head_img_type] => 0
 [distance] => 1.12		//距离,单位公里
 )
 */

@property (nonatomic, copy) NSString <Optional> *nearUserId;
@property (nonatomic, copy) NSString <Optional> *xid;
@property (nonatomic, copy) NSString <Optional> *sex;
@property (nonatomic, copy) NSString <Optional> *distance;
@property (nonatomic, copy) NSString <Optional>*nickname;
@property (nonatomic, copy) NSString <Optional>*head_img;
@property (nonatomic, copy) NSString <Optional>*head_img_type;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
