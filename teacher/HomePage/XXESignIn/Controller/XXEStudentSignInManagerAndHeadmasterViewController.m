//
//  XXEStudentSignInManagerAndHeadmasterViewController.m
//  teacher
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentSignInManagerAndHeadmasterViewController.h"
#import "XXEManagerAndHeadmasterStudentSignInApi.h"
#import "XXEClassAddressHeadermasterAndManagerApi.h"
#import "XXEClassAddressHeadermasterAndManagerModel.h"
#import "XXEStudentSignInViewController.h"
#import "HZQDatePickerView.h"

@interface XXEStudentSignInManagerAndHeadmasterViewController ()<HZQDatePickerViewDelegate,UITableViewDelegate,UITableViewDataSource>{
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


@end

@implementation XXEStudentSignInManagerAndHeadmasterViewController

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
    
    _timeLabel.text = nowDateStr;
    
    [_chooseButton addTarget:self action:@selector(chooseTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self createTableView];
    
    [self fetchNetData];
}

- (void)createTableView{
    
    CGFloat tableViewY = _upBgView.frame.origin.y + _upBgView.frame.size.height;
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, KScreenWidth, KScreenHeight - tableViewY - 64) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
}

- (void)fetchNetData{
    //获取 上部分 视图 的 数据
    [self fetchUpInfo];
    
    //获取 下部分 班级 的 数据
    [self fetchClassInfo];
}
    
- (void)fetchUpInfo{

    XXEManagerAndHeadmasterStudentSignInApi *managerAndHeadmasterStudentSignInApi = [[XXEManagerAndHeadmasterStudentSignInApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE date_tm:nowDateStr school_id:_schoolId];
    [managerAndHeadmasterStudentSignInApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"kkk%@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            no_sign_in_num = dict[@"no_sign_in_num"];
            sign_in_num = dict[@"sign_in_num"];
            
        }else{
            
        }
        if (no_sign_in_num == nil) {
            no_sign_in_num = @"";
        }
        NSString  *unsignNumStr = [NSString stringWithFormat:@"%@", no_sign_in_num];
        [_unsignNumButton setTitle:unsignNumStr forState:UIControlStateNormal];
        
        if (sign_in_num == nil) {
            sign_in_num = @"";
        }
        NSString  *signNumStr = [NSString stringWithFormat:@"%@", sign_in_num];
        [_signNumButton setTitle:signNumStr forState:UIControlStateNormal];

        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
    
}

- (void)fetchClassInfo{
    /*
     【某个学校所有班级名称列表(当身份时校长和管理员时用到)】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/school_all_class
     
     传参:
     school_id	//学校id
     school_type	//学校类型 */

    XXEClassAddressHeadermasterAndManagerApi *classAddressHeadermasterAndManagerApi = [[XXEClassAddressHeadermasterAndManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId school_type:_schoolType];
    [classAddressHeadermasterAndManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        //        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            NSArray *modelArray = [XXEClassAddressHeadermasterAndManagerModel parseResondsData:dict];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
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
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_myTableView.frame.size.width / 2 - myImageWidth / 2, (_myTableView.frame.size.height - 64 - 49 ) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTableView reloadData];
        
    }
    
}


- (void)chooseTimeBtnClick{
    
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

#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        XXEClassAddressHeadermasterAndManagerModel *model = _dataSourceArray[indexPath.row];
        cell.textLabel.text = model.class_name;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.00000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXEStudentSignInViewController *studentSignInVC = [[XXEStudentSignInViewController alloc] init];
    XXEClassAddressHeadermasterAndManagerModel *model = _dataSourceArray[indexPath.row];
    studentSignInVC.schoolId = _schoolId;
    studentSignInVC.classId = model.class_id;
    
    [self.navigationController pushViewController:studentSignInVC animated:YES];

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