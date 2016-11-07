//
//  XXESchoolTimetableCourseDetailViewController.h
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"
#import "XXESchoolTimetableModel.h"



typedef void(^ReturnArrayBlock)(NSMutableArray *modifyArray);

@interface XXESchoolTimetableCourseDetailViewController : XXEBaseViewController

/*
 course_id => 1			//下个接口用
 [type] => 3			//类型,3是自定义,允许修改
 [wd] => saturday		//下个接口用
 */
@property (nonatomic, copy) NSString *week_date;
@property (nonatomic, copy) NSString *schedule_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *wd;

@property (nonatomic, strong) XXESchoolTimetableModel *model;

@property (nonatomic, copy) ReturnArrayBlock ReturnArrayBlock;

- (void)returnArray:(ReturnArrayBlock)block;


@end
