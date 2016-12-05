

//
//  XXESentToPeopleViewController.m
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESentToPeopleViewController.h"
#import "XXEChiefAndTeacherViewController.h"
#import "XXEManagerAndHeadmasterViewController.h"
#import "DynamicScrollView.h"
#import "FSImagePickerView.h"
#import "XXESubmitSeletedBabyInfoApi.h"


@interface XXESentToPeopleViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate>
{
    DynamicScrollView *dynamicScrollView;
    NSMutableArray *didSelectBabyNameArray;//选中宝贝 名称  数组
    NSMutableArray *didSelectBabyIdArray;//选中宝贝 id  数组
    NSMutableArray *didSelectSchoolIdArray;//选中宝贝 学校 id  数组
    NSMutableArray *didSelectClassIdArray;//选中宝贝 班级 id  数组
    
    NSString *babyIdStr; //选中 的 宝贝 id
    
    NSMutableArray *submitBabyInfoArray; //选中 宝贝 提交 宝贝信息(baby id ,school id, class id)
    NSString *jsonString;
    
    //添加 宝贝
    UIView *addBabyBgView;
    //赠送 宝贝 名称
    UIView *babyNameBgView;
    //赠言
    UIView *contentBgView;
    //上传 图片
    UIView *uploadPicBgView;
    
    //选中  赠送 宝贝 名称
    UILabel *seletedBabyNameLabel;
    
    //输入 内容 字数 限制 的label
    UILabel *numLabel;
    
    //赠言 内容
    UITextView *contentTextView;
    
    //图片
    FSImagePickerView *picker1;
    NSMutableArray *arr;
    NSString *picUrl;
    
    NSString *conStr;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, strong) NSMutableArray *selectedBabyInfoArray;

@end

@implementation XXESentToPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XXEBackgroundColor;
    
    didSelectBabyNameArray = [[NSMutableArray alloc] init];
    didSelectBabyIdArray = [[NSMutableArray alloc] init];
    didSelectSchoolIdArray = [[NSMutableArray alloc] init];
    didSelectClassIdArray = [[NSMutableArray alloc] init];
    arr = [[NSMutableArray alloc] init];
    
    submitBabyInfoArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    picUrl = @"";
    
    [self createContent];
    

}

- (void)createContent{
    
    
#pragma mark ======= 添加 宝贝 ==========
    addBabyBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 90 * kScreenRatioHeight)];
    addBabyBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addBabyBgView];
    
    //添加按钮
    UIButton *addButton = [UIButton createButtonWithFrame:CGRectMake(10, 10, 70 * kScreenRatioWidth, 70 * kScreenRatioWidth) backGruondImageName:@"add" Target:self Action:@selector(addButtonClick:) Title:@""];
    [addBabyBgView addSubview:addButton];

    //选中 宝贝 头像 / 名称
    //选取控件
    dynamicScrollView = [[DynamicScrollView alloc] initWithFrame:CGRectMake(addButton.frame.origin.x + addButton.width,10 * kScreenRatioHeight,WinWidth-80,70 * kScreenRatioWidth) withImages:nil];
    [self.view addSubview:dynamicScrollView];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(removeSuccess:) name:@"TeacherNameRemoveSuccess" object:nil];
    
#pragma mark ************  赠送宝贝 名称 *******************
    babyNameBgView = [[UIView alloc] initWithFrame:CGRectMake(0, addBabyBgView.frame.origin.y + addBabyBgView.height + 5, KScreenWidth, 40)];
    babyNameBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:babyNameBgView];
    
    UIImageView *sentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    sentIcon.image = [UIImage imageNamed:@"home_redflower_nameIcon"];
    [babyNameBgView addSubview:sentIcon];
    
    UILabel *nameTitleLabel = [UILabel createLabelWithFrame:CGRectMake(sentIcon.frame.origin.x + sentIcon.width + 5, sentIcon.frame.origin.y, 70, 20) Font:14 Text:@"赠送宝贝:"];
    [babyNameBgView addSubview:nameTitleLabel];
    
    seletedBabyNameLabel = [UILabel createLabelWithFrame:CGRectMake(nameTitleLabel.frame.origin.x + nameTitleLabel.width, sentIcon.frame.origin.y, KScreenWidth - 110, 20) Font:14 Text:@""];
    [babyNameBgView addSubview:seletedBabyNameLabel];
    
#pragma mark ========= 赠言 =============
    contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, babyNameBgView.frame.origin.y + babyNameBgView.height + 5, KScreenWidth, 150)];
    contentBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentBgView];
    
    UIImageView *contentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    contentIcon.image = [UIImage imageNamed:@"home_redflower_contentIcon"];
    [contentBgView addSubview:contentIcon];
    
    UILabel *contentTitleLabel = [UILabel createLabelWithFrame:CGRectMake(contentIcon.frame.origin.x + contentIcon.width + 5, contentIcon.frame.origin.y, 70, 20) Font:14 Text:@"赠言"];
    [contentBgView addSubview:contentTitleLabel];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, contentIcon.frame.origin.y + contentIcon.height, KScreenWidth - 20, contentBgView.height - 60)];
    contentTextView.delegate = self;
    [contentBgView addSubview:contentTextView];
    
    //输入内容 字数 限制
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 50,  contentTextView.frame.origin.y + contentTextView.height, 50, 20)];
    numLabel.text = @"1/200";
    numLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    [contentBgView addSubview:numLabel];
    
    
#pragma mark ---------------- 上传 图片 ------------
    uploadPicBgView = [[UIView alloc] initWithFrame:CGRectMake(0, contentBgView.frame.origin.y + contentBgView.height + 5, KScreenWidth, 120)];
    uploadPicBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:uploadPicBgView];
    
    UIImageView *uploadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    uploadIcon.image = [UIImage imageNamed:@"home_redflower_picIcon"];
    [uploadPicBgView addSubview:uploadIcon];
    
    UILabel *uploadTitleLabel = [UILabel createLabelWithFrame:CGRectMake(uploadIcon.frame.origin.x + uploadIcon.width + 5, uploadIcon.frame.origin.y, 70, 20) Font:14 Text:@"上传图片"];
    [uploadPicBgView addSubview:uploadTitleLabel];

    //选择图片
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    picker1 = [[FSImagePickerView alloc] initWithFrame:CGRectMake(10, 30, kWidth - 10 * 2, 80) collectionViewLayout:layout1];
    picker1.backgroundColor = UIColorFromRGB(255, 255, 255);
    picker1.showsHorizontalScrollIndicator = NO;
    picker1.controller = self;
    
    [uploadPicBgView addSubview:picker1];
    
#pragma mark ========  确认 按钮 ============
    CGFloat buttonW = 327 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    
    CGFloat buttonX = (KScreenWidth - buttonW) / 2;
    CGFloat buttonY = uploadPicBgView.frame.origin.y + uploadPicBgView.height + 20;
    
    
    UIButton *certainButton = [UIButton createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) backGruondImageName:@"login_green" Target:self Action:@selector(certainButtonCick:) Title:@"确认赠送"];
    [certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    certainButton.titleLabel.font = [UIFont systemWithIphone6P:20 Iphone6:18 Iphone5:16 Iphone4:14];
    [self.view addSubview:certainButton];

}


- (void)removeSuccess:(NSNotification *)notification
{
    NSString *indexStr=[[notification userInfo] valueForKey:@"index"];
    NSInteger index=[indexStr integerValue];
    [didSelectBabyNameArray removeObjectAtIndex:index];
    NSMutableString *labelStr=[NSMutableString string];
    for (NSString * str in didSelectBabyNameArray ) {
        [labelStr appendString:str];
        [labelStr appendString:@"  "];
    }
//        self.nameLabel.text=labelStr;
    seletedBabyNameLabel.text = labelStr;
    
    //宝贝 id
    [didSelectBabyIdArray removeObjectAtIndex:index];
    
        NSMutableString *tidStr = [NSMutableString string];
    
        for (int j = 0; j < didSelectBabyIdArray.count; j ++) {
            NSString *str = didSelectBabyIdArray[j];
    
            if (j != didSelectBabyIdArray.count - 1) {
                [tidStr appendFormat:@"%@,", str];
            }else{
                [tidStr appendFormat:@"%@", str];
            }
        }
        
        babyIdStr = tidStr;
    
}


- (void)addButtonClick:(UIButton *)button{
    
    //一次 最多 可 给3个孩子 送小红花
    if (didSelectBabyNameArray.count == 4) {
        
        [self showHudWithString:@"一次最多可给4个孩子送小红花"];
    }else{
        if ([self.position isEqualToString:@"1"] || [self.position isEqualToString:@"2"]) {
            //如果是 主任 或者 老师身份
            XXEChiefAndTeacherViewController *chiefAndTeacherVC = [[XXEChiefAndTeacherViewController alloc] init];
            
            chiefAndTeacherVC.schoolId = _schoolId;
            chiefAndTeacherVC.classId = _classId;
            chiefAndTeacherVC.didSelectBabyIdArray = _selectedBabyInfoArray;
            //返回 数组 头像、名称、id、课程
            [chiefAndTeacherVC returnArray:^(NSMutableArray *selectedBabyInfoArray) {
                
                [self updateBasketNum:selectedBabyInfoArray];
            }];
            [self.navigationController pushViewController:chiefAndTeacherVC animated:YES];
        }else if ([self.position isEqualToString:@"3"] || [self.position isEqualToString:@"4"]) {
            //如果是管理员 或者 校长身份
            XXEManagerAndHeadmasterViewController *managerAndHeadmasterVC = [[XXEManagerAndHeadmasterViewController alloc] init];
            managerAndHeadmasterVC.schoolId = _schoolId;
            managerAndHeadmasterVC.didSelectBabyIdArray = didSelectBabyIdArray;
            
            //返回 数组 头像、名称、id、课程
            [managerAndHeadmasterVC returnArray:^(NSMutableArray *selectedBabyInfoArray) {
                
                [self updateBasketNum:selectedBabyInfoArray];
            }];
            
            [self.navigationController pushViewController:managerAndHeadmasterVC animated:YES];
        }
    }

}



- (void)updateBasketNum:(NSMutableArray *)selectedBabyInfoArray{

    _selectedBabyInfoArray = [NSMutableArray arrayWithArray:selectedBabyInfoArray];
    
//            NSLog(@"剩余  花朵  %@", _basketNumStr);
    
    if (dynamicScrollView.imageViews.count < [_basketNumStr integerValue]) {
        //宝贝 头像
        [dynamicScrollView addImageView:[NSString stringWithFormat:@"%@%@",kXXEPicURL, selectedBabyInfoArray[0] ]];
        
        //宝贝 名字
        [didSelectBabyNameArray addObject:selectedBabyInfoArray[1]];
        NSMutableString *labelStr=[NSMutableString string];
        for (NSString * str in didSelectBabyNameArray ) {
            [labelStr appendString:str];
            [labelStr appendString:@"  "];
        }
//        self.nameLabel.text=labelStr;
        seletedBabyNameLabel.text = labelStr;
        
        //宝贝 id  //注意 去重
//        if ([didSelectBabyIdArray containsObject:selectedBabyInfoArray[2]]) {
//            [self showString:@"已选中该宝贝,请重新选择!" forSecond:1.5];
//        }else{
            [didSelectBabyIdArray addObject:selectedBabyInfoArray[2]];
            NSMutableString *tidStr = [NSMutableString string];
            
            for (int j = 0; j < didSelectBabyIdArray.count; j ++) {
                NSString *str = didSelectBabyIdArray[j];
                
                if (j != didSelectBabyIdArray.count - 1) {
                    [tidStr appendFormat:@"%@,", str];
                }else{
                    [tidStr appendFormat:@"%@", str];
                }
            }
            
            babyIdStr = tidStr;
            
            //每一维数组含baby_id,school_id,class_id (请使用孩子列表获得的数据)
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic = @{@"baby_id": selectedBabyInfoArray[2], @"school_id":selectedBabyInfoArray[3] , @"class_id":selectedBabyInfoArray[4] };
            [submitBabyInfoArray addObject:dic];
//        }
        
    
    }else{
        
        [self showHudWithString:@"小红花数量不足!" forSecond:1.5];
        
    }
}


- (void)certainButtonCick:(UIButton *)button{

    /*
     【小红花->点击赠送】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Teacher/action_give_flower
     传参:
     position	//教职身份
     baby_info	//★二维数组的json数据,每一维数组含baby_id,school_id,class_id (请使用孩子列表获得的数据)
     con		//赠言
     file	//批量上传图片,app上漏写了上传图片
     */
    //position	//身份,传数字(1教师/2班主任/3管理/4校长)
    
    if (![submitBabyInfoArray isEqual:@"..."]) {
        NSError *error;
        NSData *jsonData =[NSJSONSerialization dataWithJSONObject:submitBabyInfoArray  options:kNilOptions error:&error];
        jsonString =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    if (conStr == nil) {
        conStr = @"";
    }
    if (_position == nil) {
        _position = @"";
    }
        
    // pickerView.data  里面 有一张加号占位图,所有 个数最少有 1 张
    for (int i = 0; i < picker1.data.count - 1; i++) {
        FSImageModel *mdoel = picker1.data[i];
        UIImage *image1 = [UIImage imageWithData:mdoel.data];
        [arr addObject:image1];
    }
    
    [self transformPicUrl];

}



- (void)transformPicUrl{
    /*
     【上传文件】
     接口:
     http://www.xingxingedu.cn/Global/uploadFile
     ★注: 默认传参只要appkey和backtype
     接口类型:2
     传参
     file_type	//文件类型,1图片,2视频 			  (必须)
     page_origin	//页面来源,传数字 			  (必须)
     11//学校食谱
     upload_format	//上传格式, 传数字,1:单个上传  2:批量上传 (必须)
     file		//文件数据的数组名 			  (必须)
     */
    NSString *url = @"http://www.xingxingedu.cn/Global/uploadFile";
    
    NSDictionary *parameter = @{
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"xid":parameterXid,
                                @"user_id":parameterUser_Id,
                                @"user_type":USER_TYPE,
                                @"file_type":@"1",
                                @"page_origin":@"11",
                                @"upload_format":@"2"
                                };
    
    AFHTTPRequestOperationManager *mgr =[AFHTTPRequestOperationManager manager];
    [mgr POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i< arr.count; i++) {
            NSData *data = UIImageJPEGRepresentation(arr[i], 0.5);
            NSString *name = [NSString stringWithFormat:@"%d.jpeg",i];
            NSString *formKey = [NSString stringWithFormat:@"file%d",i];
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        }
        
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =responseObject;
        //          NSLog(@"111111<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@",dict);
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            NSArray *picArray = [NSArray array];
            
            picArray = dict[@"data"];
            if (picArray.count == 1) {
                picUrl = picArray[0];
            }else if (picArray.count > 1){
                
                NSMutableString *tidStr = [NSMutableString string];
                
                for (int j = 0; j < picArray.count; j ++) {
                    NSString *str = picArray[j];
                    
                    if (j != picArray.count - 1) {
                        [tidStr appendFormat:@"%@,", str];
                    }else{
                        [tidStr appendFormat:@"%@", str];
                    }
                }
                
                picUrl = tidStr;
            }
        
        }
        
            [self submitFlowerSentInfo];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}

- (void)submitFlowerSentInfo{
    /*
     【小红花->点击赠送】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Teacher/action_give_flower
     传参:
     position	//教职身份
     baby_info	//★二维数组的json数据,每一维数组含baby_id,school_id,class_id (请使用孩子列表获得的数据)
     con		//赠言
     url_group	//批量上传图片,app上漏写了上传图片
     */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Teacher/action_give_flower";
    NSDictionary *parameter = @{
                                @"appkey":APPKEY,
                                @"backtype":BACKTYPE,
                                @"xid":parameterXid,
                                @"user_id":parameterUser_Id,
                                @"user_type":USER_TYPE,
                                @"position": _position,
                                @"baby_info": jsonString,
                                @"con": conStr,
                                @"url_group": picUrl
                                };
[WZYHttpTool post:urlStr params:parameter success:^(id responseObj) {
    //
//    NSLog(@" 哈哈哈哈 %@", responseObj);
    
    if ([responseObj[@"code"] integerValue] == 1) {
        [self showHudWithString:@"赠送成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }else{
        [self showHudWithString:@"赠送失败!"];
    }
    
} failure:^(NSError *error) {
    //
    [self showHudWithString:@"数据获取失败!"];
}];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView == contentTextView) {
        
        if (contentTextView.text.length <= 200) {
            numLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        }else{
           [self showHudWithString:@"最多可输入200个字符"];
           contentTextView.text = [contentTextView.text substringToIndex:200];
        }
        conStr = contentTextView.text;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
     numLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
