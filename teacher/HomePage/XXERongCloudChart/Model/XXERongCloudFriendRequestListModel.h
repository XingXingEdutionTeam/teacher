//
//  XXERongCloudFriendRequestListModel.h
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXERongCloudFriendRequestListModel : JSONModel

/*
 [id] => 5			//请求id,  agree_friend_request接口用
 [date_tm] => 1462884982
 [requester_xid] => 18886387
 [receiver_xid] => 18884982
 [notes] =>
 [nickname] => 唐唐
 [head_img] =>
 [head_img_type] => 0
 */

@property (nonatomic, copy) NSString <Optional> *agree_friend_request_id;
@property (nonatomic, copy) NSString <Optional> *date_tm;
@property (nonatomic, copy) NSString <Optional> *requester_xid;
@property (nonatomic, copy) NSString <Optional> *receiver_xid;
@property (nonatomic, copy) NSString <Optional>*nickname;
@property (nonatomic, copy) NSString <Optional>*head_img;
@property (nonatomic, copy) NSString <Optional>*head_img_type;
@property (nonatomic, copy) NSString <Optional>*notes;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
