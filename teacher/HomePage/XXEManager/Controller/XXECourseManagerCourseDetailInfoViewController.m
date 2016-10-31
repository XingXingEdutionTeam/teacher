

//
//  XXECourseManagerCourseDetailInfoViewController.m
//  teacher
//
//  Created by Mac on 16/9/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXECourseManagerCourseDetailInfoViewController.h"
#import "XXECourseManagerCourseDetailInfoTableViewCell.h"
#import "XXECourseManagerCourseModifyViewController.h"
#import "XXECourseManagerCourseDetailInfoModel.h"
#import "XXECourseManagerCourseDetailInfoApi.h"
#import "XXECourseManagerSupportAndRefuseApi.h"
#import "XXECourseManagerDeleteCourseApi.h"
#import "XXECourseManagerCoursePicModel.h"
#import "XXEImageBrowsingViewController.h"



@interface XXECourseManagerCourseDetailInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    //每一行 标题 数组
    NSMutableArray *_titleArray;
    //每一行 内容
    NSMutableArray *_contentArray;
    
    //课程 图片 资源 数组
    NSMutableArray *_picDataSourceArray;
    //图片 model 数组
    NSMutableArray *_picModelArray;
    //图片 地址(不含头部) 数组
    NSMutableArray *_picWallArray;
    //照片墙 的图片 可以排列几行
    NSInteger picRow;
    //照片墙 照片 宽
    CGFloat picWidth;
    //照片墙 照片 高
    CGFloat picHeight;
    
    //课程 时间 具体安排表 数组
    NSMutableArray *courseTimeDataSourseArray;
    NSMutableArray *courseTimeModelArray;
    NSMutableArray *courseTimeNameArray;
    NSMutableString *courseTimeString;
    
    
    //通过 按钮
    UIButton *supportButton;
    //驳回
    UIButton *refuseButton;
    //修改
    UIButton *modifyButton;
    //删除
    UIButton *deleteButton;
    
    //[allow_delete] = 1; //判断删除按钮的显示,  0:没有删除按钮  1:有删除按钮
    NSString *allow_delete;
    //[allow_edit] = 1;	//判断修改按钮的显示,  0:没有修改按钮  1:有修改按钮
    NSString *allow_edit;
    
    //condit课程状态
    /*
     0 : 未完善等待再编辑(保存到草稿)
     1 : 等待校长审核(管理员发布的)
     2 : 等待官方审核(校长审核通过)
     3 : 上线 (官方审核通过),包含学期结束的
     4 : 校长审核不通过
     5 : 官方审核不通过
     */
    NSString *condit;
    
    //通过/驳回 判断 关键字
    NSString *action_type;
    
    UITableView *_myTableView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}



@end

@implementation XXECourseManagerCourseDetailInfoViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    action_type = @"";

     [self fetchNetData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XXEBackgroundColor;
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"课程类型:",@"课程名称:",@"授课老师:",@"招生人数:" , @"适用人群:", @"教学目标:", @"每周次数:", @"课程时长:", @"开始时间:", @"结束时间:",  @"上课地址:", @"插班规则:", @"退班规则:", @"原  价:", @"现  价:", @"猩币抵扣:", @"课程详情:", @"课程图片:", nil];

    [self createTableView];
}


- (void)fetchNetData{
    XXECourseManagerCourseDetailInfoApi *courseManagerCourseDetailInfoApi = [[XXECourseManagerCourseDetailInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId course_id:_courseId];
    [courseManagerCourseDetailInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//             NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
    [self createContentArray:request.responseJSONObject[@"data"]];
        }else{
            
        }
        
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];


}

- (void)createContentArray:(NSDictionary *)dic{

//    NSLog(@"cccc%@", dic);
    
    _contentArray = [[NSMutableArray alloc] init];
    //课程类型
    NSString *courseType = [NSString stringWithFormat:@"%@ %@ %@", dic[@"class1_name"], dic[@"class2_name"], dic[@"class3_name"]];
    [_contentArray addObject:courseType];
    
    //课程名称
    [_contentArray addObject:dic[@"course_name"]];
    
    //授课老师 名称
//    NSLog(@"%@", dic);
    
    NSString *teacherName;
    teacherName = @"";
    
    if ([dic[@"teacher_arr"] count] != 0) {
        NSDictionary *teacherDic = dic[@"teacher_arr"][0];
        teacherName = teacherDic[@"tname"];
    }
    
    [_contentArray addObject:teacherName];
    
    //招生人数
    NSString *needNumStr = [NSString stringWithFormat:@"%@人", dic[@"need_num"]];
    
    [_contentArray addObject:needNumStr];
    
    //适用 人群
    NSString *fitStudent = [NSString stringWithFormat:@"%@ ~ %@", dic[@"age_up"], dic[@"age_down"]];
    [_contentArray addObject:fitStudent];
    
    //教学目标
    [_contentArray addObject:dic[@"teach_goal"]];
    
    //@"每周次数", @"课程时长", @"开始时间", @"结束时间",
    NSString *weekTimes = [NSString stringWithFormat:@"%@节课", dic[@"week_times"]];
    [_contentArray addObject:weekTimes];
    
    NSString *lengthStr = [NSString stringWithFormat:@"%@分钟", dic[@"course_hour"]];
    [_contentArray addObject:lengthStr];
    
    //课程开始 日期
    NSString *startTimeString;
    startTimeString = @"";
    
    if (![dic[@"course_start_tm"] isEqualToString:@"0"]) {
        NSString *startTime = [XXETool dateStringFromNumberTimer:dic[@"course_start_tm"]];
        NSArray *array1 = [startTime componentsSeparatedByString:@" "];
        startTimeString = array1[0];
    }
    [_contentArray addObject:startTimeString];
    
    //课程结束 日期
    NSString *endTimeString;
    endTimeString = @"";
    if (![dic[@"course_end_tm"] isEqualToString:@"0"]) {
        NSString *endTime = [XXETool dateStringFromNumberTimer:dic[@"course_end_tm"]];
        NSArray *array2 = [endTime componentsSeparatedByString:@" "];
        endTimeString = array2[0];
    }
     [_contentArray addObject:endTimeString];
    
    //@"上课地址", @"插班规则", @"退班规则",
    [_contentArray addObject:dic[@"address"]];
    
    NSString *insertStr;
    if ([dic[@"middle_in_rule"] integerValue] == 1) {
        insertStr = @"允许";
    }else if ([dic[@"middle_in_rule"] integerValue] == 0){
       insertStr = @"不允许";
    }
    [_contentArray addObject:insertStr];
    
    NSString *exitStr;
    if ([dic[@"quit_rule"] integerValue] == 1) {
        exitStr = @"允许";
    }else if ([dic[@"quit_rule"] integerValue] == 0){
        exitStr = @"不允许";
    }
    [_contentArray addObject:exitStr];
    
    //@"原  价", @"现  价", @"猩币抵扣",
    
    NSString *oldPrice = [NSString stringWithFormat:@"%@元", dic[@"original_price"]];
    [_contentArray addObject:oldPrice];
    
    
    NSString *nowPrice = [NSString stringWithFormat:@"%@元", dic[@"now_price"]];
    [_contentArray addObject:nowPrice];
    
    NSString *deductStr;
    if ([dic[@"coin"] integerValue] == 1) {
        deductStr = @"允许";
    }else if ([dic[@"coin"] integerValue] == 0){
        deductStr = @"不允许";
    }
    [_contentArray addObject:deductStr];
    
   // @"课程详情", @"课程图片",
    [_contentArray addObject:dic[@"details"]];
    
#pragma mark - ---------- 图片 数组 ------------------
    [_contentArray addObject:@" "];
    _picDataSourceArray = [[NSMutableArray alloc] initWithArray:dic[@"pic_arr"]];
    
    _picModelArray = [[NSMutableArray alloc] init];
    NSArray *picModelArray = [XXECourseManagerCoursePicModel parseResondsData:_picDataSourceArray];
    
    [_picModelArray addObjectsFromArray:picModelArray];

    _picWallArray = [[NSMutableArray alloc] init];
    for (XXECourseManagerCoursePicModel *picModel in _picModelArray) {
        [_picWallArray addObject:picModel.pic];
    }
    
#pragma mark -------- 课程时间表 数组 ------------------
//    NSLog(@"nnnn  %@", dic[@"course_tm"]);
    
    courseTimeDataSourseArray = [[NSMutableArray alloc] initWithArray:dic[@"course_tm"]];
    
    courseTimeModelArray = [[NSMutableArray alloc] init];
    NSArray *courseModelArray = [XXECourseManagerCourseTimeModel parseResondsData:courseTimeDataSourseArray];
    [courseTimeModelArray addObjectsFromArray:courseModelArray];

    courseTimeString = [NSMutableString new];
    XXECourseManagerCourseTimeModel *timeModel;
    
    if (courseTimeModelArray.count == 1) {
        timeModel = courseTimeModelArray[0];
        courseTimeString = timeModel.complete_str;
    }else if (courseTimeModelArray.count > 1){
        
        NSMutableString *tidStr = [NSMutableString string];
        
        for (int j = 0; j < courseTimeModelArray.count; j ++) {
            
            timeModel = courseTimeModelArray[j];
            
            NSString *str = timeModel.complete_str;
            
            if (j != courseTimeModelArray.count - 1) {
                [tidStr appendFormat:@"%@/", str];
            }else{
                [tidStr appendFormat:@"%@", str];
            }
        }
        
        courseTimeString = tidStr;
    }

#pragma mark ------------- 是否 显示 删除/修改 按钮 --------
    allow_delete = dic[@"allow_delete"];
    
    allow_edit = dic[@"allow_edit"];
    
    condit = dic[@"condit"];
    
    //加  -------  判断 条件----------
    // 通过 按钮 // 驳回  按钮
    [self createFootView];
}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 * kScreenRatioWidth) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXECourseManagerCourseDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXECourseManagerCourseDetailInfoTableViewCell" owner:self options:nil]lastObject];
    }

    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.contentLabel.text = _contentArray[indexPath.row];
    
    //课程 每周 具体安排 时间表
    if (indexPath.row == 6) {
        UITextView *courseTimeTextView = [[UITextView alloc] initWithFrame:CGRectMake(90 , 30, KScreenWidth - 100, 80)];
        courseTimeTextView.layer.borderColor = [UIColorFromRGB(229, 232, 233) CGColor];
        courseTimeTextView.layer.borderWidth = 1;
        courseTimeTextView.text = courseTimeString;
        courseTimeTextView.editable = NO;
        [cell.contentView addSubview:courseTimeTextView];
        
    }
    
    //课程 详情
    if (indexPath.row == 16) {
        [cell.contentLabel removeFromSuperview];
        UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(90 , 8, KScreenWidth - 100, 80)];
        detailTextView.layer.borderColor = [UIColorFromRGB(229, 232, 233) CGColor];
        detailTextView.layer.borderWidth = 1;
        detailTextView.text = _contentArray[16];
        detailTextView.editable = NO;
        [cell.contentView addSubview:detailTextView];
        
    }
    
    //图片
    if (indexPath.row == 17) {
//        NSLog(@"kkk %@", _picWallArray);
        
        if (_picWallArray.count % 5 == 0) {
            picRow = _picWallArray.count / 5;
        }else{
            
            picRow = _picWallArray.count / 5 + 1;
        }
        //创建 十二宫格  三行、四列
        int margin = 10;
        picWidth = (KScreenWidth - 6 * margin) / 5;
        picHeight = picWidth;
        
        for (int i = 0; i < _picWallArray.count; i++) {
            
            //行
            int buttonRow = i / 5;
            
            //列
            int buttonLine = i % 5;
            
            CGFloat buttonX = 10 + (picWidth + margin) * buttonLine;
            CGFloat buttonY = 40 + (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
            
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _picWallArray[i]]]];
            pictureImageView.tag = 20 + i;
            pictureImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:pictureImageView];
        }
 
    }
    
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==6) {
        return 120;
    }else if (indexPath.row==16) {
        return 100;
    }else if (indexPath.row==17) {
        
        return 44 + picRow * picHeight;
    }else{
        return 44;
    }
}


- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
//        NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    XXEImageBrowsingViewController * imageBrowsingVC = [[XXEImageBrowsingViewController alloc] init];
    
    imageBrowsingVC.imageUrlArray = _picWallArray;
    imageBrowsingVC.currentIndex = tap.view.tag - 20;
    //举报 来源  3:猩课堂发布的课程图片
    imageBrowsingVC.origin_pageStr = @"3";
    
    [self.navigationController pushViewController:imageBrowsingVC animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;

}

#pragma amrk -------------- 通过 驳回 按钮---------------
- (void)createFootView{
    
    UIView *footerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 220)];
    
    footerBgView.backgroundColor = [UIColor whiteColor];
    _myTableView.tableFooterView = footerBgView;
    //通过
    CGFloat buttonWidth = 325 * kScreenRatioWidth;
    CGFloat buttonHeight = 42 * kScreenRatioHeight;
    
    //修改(只有校长身份 并且 状态为1 时 才有 通过/驳回 按钮)
    if ([self.position isEqualToString:@"4"] && [condit integerValue] == 1){
    
    supportButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth) / 2, 10, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(supportButtonClick) Title:@"通    过"];
    [supportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerBgView addSubview:supportButton];
    
    
    //驳回
    refuseButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth) / 2, supportButton.frame.origin.y + buttonHeight + 10, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(refuseButtonClick) Title:@"驳    回"];
    [refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerBgView addSubview:refuseButton];
}
    //判断修改按钮的显示,  0:没有修改按钮  1:有修改按钮
    
//    NSLog(@" %@ --- %@ ", allow_edit, allow_delete);
    
    if ([allow_edit integerValue] == 1){
    
       modifyButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth) / 2, refuseButton.frame.origin.y + buttonHeight + 10, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(modifyButtonClick) Title:@"修    改"];
        [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [footerBgView addSubview:modifyButton];
        
    }

    //判断修改按钮的显示,  0:没有 删除 按钮  1:有 删除 按钮
    if ([allow_delete integerValue] == 1){
    
        deleteButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth) / 2, modifyButton.frame.origin.y + buttonHeight + 10, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(deleteButtonClick) Title:@"删    除"];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [footerBgView addSubview:deleteButton];
        
    }

}

// 通过  action_type 	//执行类型, 1:处理通过  2:处理驳回
- (void)supportButtonClick{
    if (![action_type isEqualToString:@""]) {
        action_type = @"";
    }
    
    action_type = @"1";
    [self courseManagerSupportAndRefuseAction];
    
}

//驳回  action_type 	//执行类型, 1:处理通过  2:处理驳回
- (void)refuseButtonClick{
    if (![action_type isEqualToString:@""]) {
        action_type = @"";
    }
    
    action_type = @"2";
    [self courseManagerSupportAndRefuseAction];
    
}

//修改
- (void)modifyButtonClick{
    XXECourseManagerCourseModifyViewController *courseManagerCourseModifyVC = [[XXECourseManagerCourseModifyViewController alloc] init];
    
    courseManagerCourseModifyVC.schoolId = _schoolId;
    courseManagerCourseModifyVC.schoolType = _schoolType;
    courseManagerCourseModifyVC.position = _position;
    courseManagerCourseModifyVC.classId = _classId;
    courseManagerCourseModifyVC.courseId = _courseId;
    
    [self.navigationController pushViewController:courseManagerCourseModifyVC animated:YES];
}


//删除
- (void)deleteButtonClick{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除课程?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    
    [alert show];
}

#pragma mark - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //取消
            break;
            
        case 1:
        {
            [self deleteCourseInfo];
            
        }
            break;
    }
    
}

- (void)deleteCourseInfo{
    
    XXECourseManagerDeleteCourseApi *courseManagerDeleteCourseApi = [[XXECourseManagerDeleteCourseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id course_id:_courseId school_id:_schoolId position:_position];
    [courseManagerDeleteCourseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//            NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"删除成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"删除失败" forSecond:1.f];
    }];
    
    
}




- (void)courseManagerSupportAndRefuseAction{
    XXECourseManagerSupportAndRefuseApi *courseManagerSupportAndRefuseApi = [[XXECourseManagerSupportAndRefuseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id position:_position school_id:_schoolId course_id:_courseId action_type:action_type];
    
    [courseManagerSupportAndRefuseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"操作成功!" forSecond:1.5];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"发布失败!" forSecond:1.5];
    }];
}
 




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
