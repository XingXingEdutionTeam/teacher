//
//  SystemModel+CoreDataProperties.m
//  teacher
//
//  Created by codeDing on 16/12/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
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
