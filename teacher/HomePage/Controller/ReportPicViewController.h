//
//  ReportPicViewController.h
//  XingXingEdu
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "XXEBaseViewController.h"

@interface ReportPicViewController : XXEBaseViewController

/** 举报图片地址 */
@property (nonatomic, copy) NSString *picUrlStr;
/** 举报内容来源 */
@property (nonatomic, copy) NSString *origin_pageStr;

/** 举报类型 1为举报用户 2为举报图片*/
@property (nonatomic, copy)NSString *report_type;

/** 被举报 人 other_xid */
@property (nonatomic, copy) NSString *other_xidStr;



@end
