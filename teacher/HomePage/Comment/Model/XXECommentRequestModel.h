//
//  XXECommentRequestModel.h
//  teacher
//
//  Created by Mac on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXECommentRequestModel : JSONModel

/*
 
 (
 [id] => 20			//点评id
 [class_id] => 1		//班级id
 [type] => 1			//点评类型  1:老师主动点评,2:家长请求点评
 [condit] => 1		//点评状态  0:家长发送的请求 (待老师点评), 1:老师已点评
 [baby_id] => 15		//孩子id
 [puser_id] => 0		//家长id
 [ask_tm] => 0		//家长发送请求时间戳
 [ask_con] => 		//请求内容
 [tuser_id] => 1		//老师id
 [com_tm] => 1469760938	//老师点评时间戳
 [com_con] => 表现棒棒的	//老师点评内容
 [com_pic] => app_upload/class_album/2016/07/29/20160729105538_3449.jpg	//点评图片,多个逗号隔开
 [baby_tname] => 李小红	//孩子姓名
 [head_img] => app_upload/text/baby_head/baby_head1.jpg	//孩子头像
 [relation_name] => 		//家长发起的请求才有关系称呼
 [collect_condit] => 2	//1:是收藏过这个商品  2:未收藏过
 )
 */

@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *condit;
@property (nonatomic, copy) NSString *baby_id;
@property (nonatomic, copy) NSString *puser_id;
@property (nonatomic, copy) NSString *ask_tm;
@property (nonatomic, copy) NSString *ask_con;
@property (nonatomic, copy) NSString *tuser_id;
@property (nonatomic, copy) NSString *com_tm;
@property (nonatomic, copy) NSString *com_con;
@property (nonatomic, copy) NSString *com_pic;
@property (nonatomic, copy) NSString *baby_tname;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *relation_name;
@property (nonatomic, copy) NSString *collect_condit;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
