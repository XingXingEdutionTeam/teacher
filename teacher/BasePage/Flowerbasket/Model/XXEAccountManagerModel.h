//
//  XXEAccountManagerModel.h
//  teacher
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEAccountManagerModel : JSONModel

/*
 [id] => 1		//此id操作提现时作为传参(account_id)
 [xid] => 18886389
 [date_tm] => 1469436100
 [type] => 1
 [tname] => 李晓晓
 [account] => lixiaoxiao@126.com
 */

@property(nonatomic, copy)NSString *idStr;
@property(nonatomic, copy)NSString *xid;
@property(nonatomic, copy)NSString *date_tm;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *tname;
@property(nonatomic, copy)NSString *account;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
