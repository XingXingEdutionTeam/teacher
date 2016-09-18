//
//  XXESchoolAlbumModel.h
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXESchoolAlbumModel : JSONModel

/*
 {
 "good_num" = 1;
 id = 2;
 url = "app_upload/text/school/z1.jpg";
 }
 */

@property (nonatomic, copy) NSString *good_num;
@property (nonatomic, copy) NSString *schoolPicId;
@property (nonatomic, copy) NSString *pic;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
