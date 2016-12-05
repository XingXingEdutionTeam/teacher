//
//  SystemModel+CoreDataProperties.h
//  teacher
//
//  Created by codeDing on 16/12/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SystemModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SystemModel (CoreDataProperties)

+ (NSFetchRequest<SystemModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *alert;
@property (nullable, nonatomic, copy) NSString *badge;
@property (nullable, nonatomic, copy) NSString *notice_id;
@property (nullable, nonatomic, copy) NSString *sound;
@property (nullable, nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
