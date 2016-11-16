//
//  XXEStoreIconSentToOtherModel.h
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEStoreIconSentToOtherModel : JSONModel

/*
 [xid] => 18886144
 [tname] => 顾曾
 */

@property (nonatomic, copy) NSString <Optional>*xid;
@property (nonatomic, copy) NSString <Optional>*tname;

+ (NSArray*)parseResondsData:(id)respondObject;

@end
