//
//  XXECourseManagerCourseReleaseApi.h
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface XXECourseManagerCourseReleaseApi : YTKRequest

/*
 【课程管理->发布课程】
 
 ★注:
 1.关于3个类目(class),之前做猩课堂写过3级类目,能否用那个接口? 如果不行,我再从新写接口,一层一层调
 2.此接口的传参分4部分:
 一:零散的字符串传参
 ①传参第一部分:零散的字符串传参
 
	position	//身份 (4种类型,1:老师,2:主任,3:管理,4:校长. 发布课程只允许3,和4)
	school_id	//学校id
	publish_type	//发布类型 (分4种,传数字)
 //1:发布课程
 //2:发布时选择保存草稿箱
 //3:修改数据后发布课程 (除了原始图片,其他数据都要重新上传,包括新图片)
 //4:修改数据后保存草稿箱 (除了原始图片,其他数据都要重新上传,包括新图片)
 注:草稿箱中修改课程和审核状态,驳回状态修改课程,都属于修改.当修改的时候,请保证至少有一个参数用户改动了,才允许提交.
	course_id	//课程id (当修改课程时才有此传参,也就是publish_type等于3,4的时候)
 
 二:course_info数组的json形式传参(课程主体内容数据)
 三:course_tm数组的json形式传参(课程时间,是未知数量的)
 四:file上传文件(课程图片批量上传)
 3.当用户修改课程的时候,设置上课时间页面,限制住课程安排那个下拉框(一星期几次不要让用户改,这个涉及到用户删减很难判断)
 
 
 接口类型:2
 
 接口:
 http://www.xingxingedu.cn/Teacher/course_publish
 */

- (instancetype)initWithXid:(NSString *)xid  user_id:(NSString *)user_id  position:(NSString *)position school_id:(NSString *)school_id publish_type:(NSString *)publish_type course_id:(NSString *)course_id course_info:(NSString *)course_info course_tm:(NSString *)course_tm;

@end
