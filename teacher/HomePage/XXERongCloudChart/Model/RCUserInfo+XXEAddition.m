//
//  RCUserInfo+XXEAddition.m
//  teacher
//
//  Created by Mac on 16/10/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "RCUserInfo+XXEAddition.h"
#import <objc/runtime.h>


@implementation RCUserInfo (XXEAddition)

@dynamic QQ;
@dynamic sex;
@dynamic age;
- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)username portrait:(NSString *)portrait QQ:(NSString *)QQ sex:(NSString *)sex age:(NSString *)age{
    if (self = [super init]) {
        self.userId        =   userId;
        self.name          =   username;
        self.portraitUri   =   portrait;
        self.QQ         =   QQ;
        self.sex   =   sex;
        self.age   =   age;
    }
    return self;
}

//添加属性扩展set方法
static char* const QQ = "QQ";
static char* const SEX = "SEX";
static char* const AGE = "age";

-(void)setQQ:(NSString *)newQQ{
    
    objc_setAssociatedObject(self,QQ,newQQ,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(void)setSex:(NSString *)newSex{
    
    objc_setAssociatedObject(self,SEX,newSex,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)setAge:(NSString *)newAge{
    
    objc_setAssociatedObject(self,AGE,newAge,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

//添加属性扩展get方法
-(NSString *)QQ{
    return objc_getAssociatedObject(self,QQ);
}
-(NSString *)sex{
    return objc_getAssociatedObject(self,SEX);
}

- (NSString *)age{
    return objc_getAssociatedObject(self,AGE);
}

@end
