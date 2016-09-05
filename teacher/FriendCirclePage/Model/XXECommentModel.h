//
//  XXECommentModel.h
//  teacher
//
//  Created by codeDing on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol XXECommentModel

@end

@interface XXECommentModel : JSONModel
/** 评论的Id */
@property (nonatomic, copy)NSString <Optional>*commentId;
/** 评论人的xid */
@property (nonatomic, copy)NSString <Optional>*commentXid;
/** 评论人的昵称 */
@property (nonatomic, copy)NSString <Optional>*commentNicknName;
/** to_who_xid */
@property (nonatomic, copy)NSString <Optional>*to_who_xid;
/** to_who_nickname */
@property (nonatomic, copy)NSString <Optional>*to_who_nickname;
/** 评论类型 1为评论 2为回复别人 */
@property (nonatomic, copy)NSString <Optional>*com_type;
/** 评论的内容 */
@property (nonatomic, copy)NSString <Optional>*con;
@end
