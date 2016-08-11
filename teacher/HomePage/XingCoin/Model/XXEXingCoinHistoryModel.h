//
//  XXEXingCoinHistoryModel.h
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEXingCoinHistoryModel : JSONModel

/*
 [id] => 20
 [xid] => 18884982
 [type] => 1
 [date_tm] => 1461055776	//转增时间戳
 [coin_num] => -50		//新币数量
 [con] => 互赠		//分类
 [other_side] => 18886064
 [head_img] => app_upload/text/aisi3.jpg
 [head_img_type] => 0	//头像类型,0代表系统头像,需要加http头部(看前言),如果是1,是第三方头像
 [tname] => 杨子琪		//对方姓名 (只有互赠才有姓名)
 [pic] => http://www.xingxingedu.cn/Public/app_upload/text/aisi3.jpg	(历史记录为了各种类型头像统一用这个,http已经加上了)
 

 
 "coin_num" = 5;
 con = "\U7b7e\U5230";
 "date_tm" = 1470904207;
 id = 400;
 "msg_type" = 2;
 "other_side" = "\U7cfb\U7edf";
 pic = "http://www.xingxingedu.cn/Public/app_upload/app_logo.png";
 "user_type" = 2;
 xid = 18886389;
 
 
 */
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *xid;
//@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *coin_num;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *other_side;
//@property (nonatomic, copy) NSString *head_img;
//@property (nonatomic, copy) NSString *head_img_type;
//@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *user_type;
@property (nonatomic, copy) NSString *msg_type;



+ (NSArray*)parseResondsData:(id)respondObject;


+(JSONKeyMapper*)keyMapper;



@end
