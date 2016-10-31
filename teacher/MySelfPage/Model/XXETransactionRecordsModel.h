//
//  XXETransactionRecordsModel.h
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXETransactionRecordsModel : JSONModel

/*
 [id] => 15
 [date_tm] => 1476430363
 [school_id] => 10
 [money] => -1000.00
 [class] => 3
 [con] => 4
 [type_name] => 提现
 */
@property (nonatomic, copy) NSString *transactionRecordsId;
@property (nonatomic, copy) NSString *date_tm;
@property (nonatomic, copy) NSString *school_id;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *type_name;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;


@end
