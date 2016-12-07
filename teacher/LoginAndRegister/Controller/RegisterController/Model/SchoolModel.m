//
//  SchoolModel.m
//  teacher
//
//  Created by codeDing on 16/12/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "SchoolModel.h"

@implementation SchoolModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (SchoolModel *)SchoolModelWithDictionary:(NSDictionary *)dic {
    SchoolModel *model = [[SchoolModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.schoolId = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"name"]) {
        self.schoolName = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"type"]) {
        
        NSInteger type = [value integerValue];
        switch (type) {
                case 1:
                self.schoolType = @"幼儿园";
                break;
                
                case 2:
                self.schoolType = @"小学";
                break;
                
                case 3:
                self.schoolType = @"中学";
                break;
                
                case 4:
                self.schoolType = @"培训机构";
                break;
                
            default:
                break;
        }
        
    }
    
    if ([key isEqualToString:@"province"])
    {
        self.province = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"city"])
    {
        self.city = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"district"])
    {
        self.district = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"address"])
    {
        self.address = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"tel"])
    {
        self.tel = [NSString stringWithFormat:@"%@", value];
    }
}
@end
