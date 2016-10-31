//
//  XXECourseManagerCoursePicModel.h
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//#import "XXECourseManagerCoursePicModel.h"
//
//@protocol  XXECourseManagerCoursePicModel
//
//@end

@interface XXECourseManagerCoursePicModel : JSONModel

/*
 [id] => 29		//图片id
 [pic] => app_upload/course_detail/2016/08/09/20160809143917_8123.jpg
 */

@property (nonatomic, copy) NSString *course_pic_id;
@property (nonatomic, copy) NSString *pic;

+ (NSArray*)parseResondsData:(id)respondObject;

+(JSONKeyMapper*)keyMapper;

@end
