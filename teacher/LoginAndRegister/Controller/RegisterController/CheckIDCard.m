//
//  CheckIDCard.m
//  xingxingEdu
//
//  Created by codeDing on 16/1/18.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "CheckIDCard.h"

@implementation CheckIDCard
+(BOOL)checkIDCard:(NSString * )idCard{

    
NSString *urlStr = [NSString stringWithFormat:@"http://apicloud.mob.com/idcard/query?key=ec9c9a472b8c&cardno=%@",idCard];
 NSURL *url = [NSURL URLWithString:urlStr];
NSData *data = [NSData dataWithContentsOfURL:url];
//NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
NSError *error;
NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if([dict[@"msg"] isEqualToString:@"success"]){
        return YES;
    }else{
        return NO;
        
    }
}

+(BOOL)checkIDCardSexMan:(NSString * )idCard{
    NSString *urlStr = [NSString stringWithFormat:@"http://apicloud.mob.com/idcard/query?key=ec9c9a472b8c&cardno=%@",idCard];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
       NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary * infoDict=dict[@"result"];
    if([infoDict[@"sex"] isEqualToString:@"男"]){
        return YES;
    }else{
        return NO;
        
    }

}

@end
