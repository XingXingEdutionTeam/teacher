//
//  XXEMySelfInfoAlbumModel.h
//  teacher
//
//  Created by Mac on 16/9/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEMySelfInfoAlbumModel : JSONModel

/*
 (
 [id] => 2
 [pic] => app_upload/text/teacher/pic/t2.jpg
 )
 */

@property (nonatomic, copy) NSString *myselfPicId;
@property (nonatomic, copy) NSString *pic;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
