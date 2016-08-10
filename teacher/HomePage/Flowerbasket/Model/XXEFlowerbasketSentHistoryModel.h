//
//  XXEFlowerbasketSentHistoryModel.h
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEFlowerbasketSentHistoryModel : JSONModel

/*
 [id] => 2
 [date_tm] => 1469528745
 [xid] => 18886389
 [num] => 2
 [money] => 594
 [commission] => 6.00
 [account] => lixiaoxiao@126.com	//请把账号和姓名也显示在记录中
 [tname] => 李晓晓
 [condit] => 0			//0:处理中  1:处理完成
 [pic] => app_upload/flower2.png
 */

@property(nonatomic, copy)NSString *idStr;
@property(nonatomic, copy)NSString *date_tm;
@property(nonatomic, copy)NSString *xid;
@property(nonatomic, copy)NSString *num;
@property(nonatomic, copy)NSString *money;
@property(nonatomic, copy)NSString *commission;
@property(nonatomic, copy)NSString *account;
@property(nonatomic, copy)NSString *tname;
@property(nonatomic, copy)NSString *condit;
@property(nonatomic, copy)NSString *pic;

+ (NSArray*)parseResondsData:(id)respondObject;


+(JSONKeyMapper*)keyMapper;




@end
