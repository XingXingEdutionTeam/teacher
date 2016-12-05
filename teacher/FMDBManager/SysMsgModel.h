//
//  SysMsgModel.h
//  teacher
//
//  Created by codeDing on 16/12/5.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysMsgModel : NSObject
@property (nullable, nonatomic, copy) NSString *alert;
@property (nullable, nonatomic, copy) NSString *badge;
@property (nullable, nonatomic, copy) NSString *sound;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *notice_id;
@end
