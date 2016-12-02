//
//  SystemModel+CoreDataProperties.m
//  
//
//  Created by Mac on 2016/12/2.
//
//  This file was automatically generated and should not be edited.
//

#import "SystemModel+CoreDataProperties.h"

@implementation SystemModel (CoreDataProperties)

+ (NSFetchRequest<SystemModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SystemModel"];
}

@dynamic alert;
@dynamic badge;
@dynamic notice_id;
@dynamic sound;
@dynamic type;

@end
