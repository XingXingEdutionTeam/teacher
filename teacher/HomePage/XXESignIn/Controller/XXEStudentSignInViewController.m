


//
//  XXEStudentSignInViewController.m
//  teacher
//
//  Created by Mac on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentSignInViewController.h"
#import "XXEStudentSignInTableViewCell.h"
#import "HZQDatePickerView.h"
#import "XXEStudentSignInApi.h"
#import "XXEStudentSignInModel.h"
#import "XXEStudentSingleSignApi.h"
#import "XXEStudentAllSignApi.h"
#import "XXEStudentUnsignInListViewController.h"


@interface XXEStudentSignInViewController ()<HZQDatePickerViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    HZQDatePickerView *_pikerView;//截止日期选择器
    NSMutableArray * studentArray;
    //未 签到 人数
    NSString *no_sign_in_num;
    //签到 人数
    NSString *sign_in_num;
    
    UITableView *_myTableView;
    NSMutableArray *_dataSourceArray;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    NSString *nowDateStr;
}
//上部分 视图 背景
@property (nonatomic,strong) UIView *upBgView;
//中间 视图 背景
@property (nonatomic, strong) UIView *middleBgView;
//时间 图标
@property (nonatomic, strong) UIImageView *icon;
//时间 文本框
@property (nonatomic, strong) UILabel *timeLabel;
//选取 时间 按钮
@property (nonatomic, strong) UIButton *chooseButton;
//未签到人数 按钮
@property (nonatomic, strong) UIButton *unSignButton;
//签到人数 按钮
@property (nonatomic, strong) UIButton *signButton;
//未签到 人数 文本框
@property (nonatomic, strong) UILabel *unSignLabel;
//签到 人数 文本框
@property (nonatomic, strong) UILabel *signLabel;
//一键签到 按钮
@property (nonatomic, strong) UIButton *allRegisterBtn;



@end

@implementation XXEStudentSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    //获取 当前 系统 时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    nowDateStr  = [formatter stringFromDate:date];
    
    [self createContent];
    
    [self createTableView];
    
    [self fetchNetData];
}

- (void)createTableView{

    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 205 * kScreenRatioHeight, KScreenWidth, KScreenHeight - 205 * kScreenRatioHeight - 64) style:UITableViewStyleGrouped];
    
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
    return _dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEStudentSignInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEStudentSignInTableViewCell" owner:self options:nil]lastObject];
    }
    XXEStudentSignInModel *model = _dataSourceArray[indexPath.row];

    NSString *head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    if (![_timeLabel.text isEqualToString:nowDateStr] || ![_position isEqualToString:@"2"]) {
      [cell.signInButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
      [cell.signInButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
      cell.signInButton.enabled = NO;
    }else{
      [cell.signInButton.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
      [cell.signInButton addTarget:self action:@selector(signInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // [sign_in_condit] => 1	//签到状态, 1: 已签到  2:未签到
    if ([model.sign_in_condit isEqualToString:@"1"]) {
        [cell.signInButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cell.signInButton setTitle:@"已签到" forState:UIControlStateNormal];
        cell.signInButton.enabled = NO;
    }else if ([model.sign_in_condit isEqualToString:@"2"]) {
        [cell.signInButton.layer setBorderWidth:1];
        [cell.signInButton.layer setMasksToBounds:YES];
        [cell.signInButton setTitle:@"签到" forState:UIControlStateNormal];

    }

    cell.nameLabel.text = model.tname;
    
    return cell;
}

//---------------------------- 签到 --------------------
- (void)signInButtonClick:(UIButton *)button{
    
    XXEStudentSignInTableViewCell *cell = (XXEStudentSignInTableViewCell *)[[button superview] superview];
    NSIndexPath *path = [_myTableView indexPathForCell:cell];
    
    XXEStudentSignInModel *model = _dataSourceArray[path.row];
    
    XXEStudentSingleSignApi *studentSingleSignApi = [[XXEStudentSingleSignApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE class_id:_classId school_id:_schoolId baby_id:model.babyId position:@"2"];
    [studentSingleSignApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"签到成功!" forSecond:1.5];
            
            [self fetchNetData];
            
        }else{
        [self showHudWithString:@"签到失败!" forSecond:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击 cell");
}

- (void)fetchNetData{

//    NSLog(@"%@ --- %@ ---- %@ ", _classId, _schoolId, _timeLabel.text);
    
    XXEStudentSignInApi *studentSignInApi = [[XXEStudentSignInApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE class_id:_classId school_id:_schoolId date_tm:_timeLabel.text];
    [studentSignInApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
//        NSLog(@"%@", request.responseJSONObject);
    NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
    if ([codeStr isEqualToString:@"1"]) {
        NSDictionary *dict = request.responseJSONObject[@"data"];

        NSArray *modelArray = [XXEStudentSignInModel parseResondsData:dict[@"baby_list"]];
        [_dataSourceArray addObjectsFromArray:modelArray];
        
        no_sign_in_num = dict[@"no_sign_in_num"];
        sign_in_num = dict[@"sign_in_num"];
        
    }else{
    
    }
        
     [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
       [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
    
}



// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        
//        NSLog(@"ggg  %f", _myTableView.frame.size.height);
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (_myTableView.frame.size.height - 64 - 49 ) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [_myTableView addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        
        [self updateContentInfo];
        
        [_myTableView reloadData];
        
    }
    
}

//更新 上部分 视图 的内容
- (void)updateContentInfo{

    //如果 看 签到 历史 "一键签到" 按钮 颜色 变为 灰色且 不可点
    if (![_timeLabel.text isEqualToString:nowDateStr] || [no_sign_in_num integerValue] == 0 || ![_position isEqualToString:@"2"]) {
        [_allRegisterBtn setBackgroundColor:[UIColor lightGrayColor]];
        _allRegisterBtn.enabled = NO;
    }else {
        [_allRegisterBtn setBackgroundColor:UIColorFromRGB(254, 103, 0)];
        _allRegisterBtn.enabled = YES;
    
    }

    if (no_sign_in_num == nil) {
        no_sign_in_num = @"";
    }
    NSString  *unsignNumStr = [NSString stringWithFormat:@"%@", no_sign_in_num];
    [_unSignButton setTitle:unsignNumStr forState:UIControlStateNormal];
    
    if (sign_in_num == nil) {
        sign_in_num = @"";
    }
    NSString  *signNumStr = [NSString stringWithFormat:@"%@", sign_in_num];
    [_signButton setTitle:signNumStr forState:UIControlStateNormal];

}



- (void)createContent{
    //---------------------- 上部分 视图 ------------------
    _upBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40 * kScreenRatioHeight)];
    _upBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_upBgView];
    //icon
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20 * kScreenRatioWidth, 10 * kScreenRatioHeight, 20 * kScreenRatioWidth, 20 * kScreenRatioWidth)];
    _icon.image = [UIImage imageNamed:@"home_redflower_timeIcon"];
    [_upBgView addSubview:_icon];
    
    //label
    _timeLabel = [UILabel createLabelWithFrame:CGRectMake(50 * kScreenRatioWidth, 10 * kScreenRatioHeight, 200 * kScreenRatioWidth, 20 * kScreenRatioHeight) Font:14* kScreenRatioWidth Text:nowDateStr];
    _timeLabel.text = nowDateStr;
    [_upBgView addSubview:_timeLabel];
    
    //选取 时间 按钮
    _chooseButton = [UIButton createButtonWithFrame:CGRectMake(260 * kScreenRatioWidth, 10 * kScreenRatioHeight, 100 * kScreenRatioWidth, 20 * kScreenRatioHeight) backGruondImageName:nil Target:self Action:@selector(chooseTimeButtonClick) Title:@"选取时间"];
    _chooseButton.titleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [_chooseButton setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
    [_upBgView addSubview:_chooseButton];
    
    // ================== 中间 视图 ===============
    CGFloat _upBgViewBottom = _upBgView.frame.origin.y + _upBgView.frame.size.height;
    _middleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _upBgViewBottom + 10 * kScreenRatioHeight, KScreenWidth, 150 * kScreenRatioHeight)];
    _middleBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_middleBgView];
    
    //未签到 人数 按钮
    _unSignButton = [UIButton createButtonWithFrame:CGRectMake(60 * kScreenRatioWidth, 5 * kScreenRatioHeight, 50 * kScreenRatioWidth, 50 * kScreenRatioWidth) backGruondImageName:nil Target:self Action:@selector(unSignButtonClick) Title:@""];
    [_unSignButton setTitleColor:UIColorFromRGB(254, 103, 0) forState:UIControlStateNormal];
    _unSignButton.titleLabel.font = [UIFont systemFontOfSize:24 * kScreenRatioWidth];
    
    [_middleBgView addSubview:_unSignButton];
    
    //签到 人数 按钮
    _signButton = [UIButton createButtonWithFrame:CGRectMake(265 * kScreenRatioWidth, 5 * kScreenRatioHeight, 50 * kScreenRatioWidth, 50 * kScreenRatioWidth) backGruondImageName:nil Target:self Action:@selector(signButtonClick) Title:@""];
    [_signButton setTitleColor:UIColorFromRGB(254, 103, 0) forState:UIControlStateNormal];
    _signButton.titleLabel.font = [UIFont systemFontOfSize:24 * kScreenRatioWidth];
    [_middleBgView addSubview:_signButton];
    
    //未签到 人数 label
    _unSignLabel = [UILabel createLabelWithFrame:CGRectMake(50 * kScreenRatioWidth, 60 * kScreenRatioHeight, 100 * kScreenRatioWidth, 20 * kScreenRatioHeight) Font:16 * kScreenRatioWidth Text:@"未签到人数"];
    [_middleBgView addSubview:_unSignLabel];
    
    //签到 人数 label
    _signLabel = [UILabel createLabelWithFrame:CGRectMake(255 * kScreenRatioWidth, 60 * kScreenRatioHeight, 100 * kScreenRatioWidth, 20 * kScreenRatioHeight) Font:16 * kScreenRatioWidth Text:@"签到人数"];
    [_middleBgView addSubview:_signLabel];
    
    //一键签到 按钮
    _allRegisterBtn = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - 325 * kScreenRatioWidth) / 2, 100 * kScreenRatioHeight, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:nil Target:self Action:@selector(allRegisterBtnClick) Title:@"一键签到"];
    
//    _allRegisterBtn = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - 325 * kScreenRatioWidth) / 2, 100 * kScreenRatioHeight, 325 * kScreenRatioWidth, 42 * kScreenRatioHeight) backGruondImageName:nil Target:self Action:nil Title:@"一键签到"];
    
    _allRegisterBtn.layer.cornerRadius = _allRegisterBtn.frame.size.height / 2;
    _allRegisterBtn.layer.masksToBounds = YES;
    [_allRegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _allRegisterBtn.titleLabel.font = [UIFont systemFontOfSize:24 * kScreenRatioWidth];
    [_middleBgView addSubview:_allRegisterBtn];
    
    [self updateContentInfo];
    
}

//未签到 人数 按钮
- (void)unSignButtonClick{
    
    XXEStudentUnsignInListViewController *studentUnsignInListVC = [[XXEStudentUnsignInListViewController alloc] init];
    studentUnsignInListVC.schoolId = _schoolId;
    studentUnsignInListVC.classId = _classId;
    studentUnsignInListVC.timeStr = _timeLabel.text;
    //sign_type	//1:已签到  2:未签到
    studentUnsignInListVC.sign_type = @"2";
    [self.navigationController pushViewController:studentUnsignInListVC animated:YES];
}

//签到 人数 按钮
- (void)signButtonClick{
    
    XXEStudentUnsignInListViewController *studentUnsignInListVC = [[XXEStudentUnsignInListViewController alloc] init];
    studentUnsignInListVC.schoolId = _schoolId;
    studentUnsignInListVC.classId = _classId;
    studentUnsignInListVC.timeStr = _timeLabel.text;
    //sign_type	//1:已签到  2:未签到
    studentUnsignInListVC.sign_type = @"1";
    [self.navigationController pushViewController:studentUnsignInListVC animated:YES];
    
}

- (void)chooseTimeButtonClick{

    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = DateTypeOfStart;
    // 今天开始往后的日期
    //    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    [_pikerView.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_pikerView];

}




//----------------------------  一键签到  --------------------
- (void)allRegisterBtnClick{
    //★★签到已改版,老师签到板块第一期不要了,只要学生签到, 老师看到某个班级签到,管理看到所有班级签到,具体跟我沟通(我这里有页面改动的草稿(小梁没有重新做))
    //position	//身份,传数字(1教师/2班主任/3管理/4校长)
    XXEStudentAllSignApi *studentAllSignApi = [[XXEStudentAllSignApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE class_id:_classId school_id:_schoolId position:_position];
    
    [studentAllSignApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//                NSLog(@"%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"签到成功!" forSecond:1.5];
            
            [self fetchNetData];
            
        }else{
            [self showHudWithString:@"签到失败!" forSecond:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}


- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    switch (type) {
        case DateTypeOfStart:
        {
            //            NSLog(@"时间  %@", date);2016-08-23 18:16:14
            NSArray *array = [date componentsSeparatedByString:@" "];
            self.timeLabel.text = array[0];
            [self fetchNetData];
            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
