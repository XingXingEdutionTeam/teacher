//
//  XXEHeaderApi.h
//  teacher
//
//  Created by codeDing on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#ifndef XXEHeaderApi_h
#define XXEHeaderApi_h

//访客登录XID不变
#define XID  @"18886389"
#define APPKEY  @"U3k8Dgj7e934bh5Y"
#define BACKTYPE @"json"
#define USER_ID  @"1"
#define USER_TYPE @"2"


//登录
#define XXELoginUrl @"http://www.xingxingedu.cn/Teacher/login"
//首页
#define XXEHomePageUrl @"http://www.xingxingedu.cn/Teacher/home_data"
//相册
#define XXEClassAlubmUrl @"http://www.xingxingedu.cn/Teacher/class_album_new"

//我的相册
#define  XXEMySelfAlubmUrl @"http://www.xingxingedu.cn/Teacher/class_teacher_album"
//添加相册
#define XXEMySelfAlubmAddUrl @"http://www.xingxingedu.cn/Teacher/class_album_add"
//删除相册
#define XXEAlbumDelegateUrl @"http://www.xingxingedu.cn/Teacher/class_album_delete"
//上传图片
#define XXEAblumUpdataUrl @"http://www.xingxingedu.cn/Teacher/class_pic_upload"

//相册的内容
#define XXEAblumPhotoUrl @"http://www.xingxingedu.cn/Teacher/class_album_pic"
//我的朋友圈
#define XXEFriendCircleUrl @"http://www.xingxingedu.cn/Global/my_friend_circle"

//搜索学校
#define XXESearchSchoolUrl @"http://www.xingxingedu.cn/Global/get_school_info"

//【通过学校获取年级】

#define XXESearchClassUrl @"http://www.xingxingedu.cn/Global/give_school_get_grade" 

/** 注册页的教学类型 */
#define XXERegisTeachTypeUrl @"http://www.xingxingedu.cn/Teacher/get_teach_name"

/** 获取审核人 */
#define XXEReviewerUrl @"http://www.xingxingedu.cn/Parent/get_examine_teacher"


#endif /* XXEHeaderApi_h */
