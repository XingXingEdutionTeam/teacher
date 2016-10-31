//
//  XXECommentHistoryDetailInfoViewController.h
//  teacher
//
//  Created by Mac on 16/8/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface XXECommentHistoryDetailInfoViewController : XXEBaseViewController


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ask_con;
@property (nonatomic, copy) NSString *ask_time;
@property (nonatomic, copy) NSString *com_con;
@property (nonatomic, copy) NSString *picString;

//[type] => 1			//点评类型  1:老师主动点评,2:家长请求点评
@property (nonatomic, copy) NSString *type;


//照片墙 照片数组
@property (nonatomic, strong) NSArray *picWallArray;

@property (nonatomic, copy) NSString *collect_conditStr;
@property (nonatomic, copy) NSString *collect_id;

@property (nonatomic, copy) NSString *fromFlagStr;
@property (nonatomic, copy) NSString *comment_id;


@end
