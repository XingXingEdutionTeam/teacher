//
//  SystemModel+CoreDataProperties.h
//  
//
//  Created by Mac on 2016/12/2.
//
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
