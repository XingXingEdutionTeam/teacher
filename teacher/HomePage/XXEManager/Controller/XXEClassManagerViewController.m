
//
//  XXEClassManagerViewController.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassManagerViewController.h"
#import "XXEClassManagerClassListTableViewCell.h"
#import "XXEClassManagerClassReleaseViewController.h"
#import "XXEClassManagerClassDetailInfoViewController.h"
#import "XXEClassManagerClassListModel.h"
#import "XXEClassManagerApi.h"



@interface XXEClassManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    UIImageView *placeholderImageView;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEClassManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataSourceArray = [[NSMutableArray alloc] init];
    
    [self fetchNetData];
    [_myTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createTableView];
    [self createReleaseButton];
}


- (void)fetchNetData{
    XXEClassManagerApi *classManagerApi = [[XXEClassManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_type:_schoolType school_id:_schoolId position:_position];
    [classManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//                NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXEClassManagerClassListModel parseResondsData:request.responseJSONObject[@"data"]];
            
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
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [_myTableView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64 - 50) style:UITableViewStyleGrouped];
    
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
    XXEClassManagerClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEClassManagerClassListTableViewCell" owner:self options:nil]lastObject];
    }
    XXEClassManagerClassListModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.school_logo];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"school_logo_icon172x172"]];
    
    cell.gradeAndClassLabel.text = model.class_name;
    cell.teacherLabel.text = [NSString stringWithFormat:@"班主任: %@", model.teacher_boss];
    
    //[condit] => 1		//0:待审核  1:审核通过  2:驳回 refuse_icon_74x74
    if ([model.condit isEqualToString:@"0"]) {
         cell.stateImageView.image = [UIImage imageNamed:@"daishenghe"];
    }else if ([model.condit isEqualToString:@"1"]){
            cell.stateImageView.image = [UIImage imageNamed:@"yishenghe"];
    }if ([model.condit isEqualToString:@"2"]){
        cell.stateImageView.image = [UIImage imageNamed:@"refuse_icon_74x74"];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXEClassManagerClassDetailInfoViewController *classManagerClassDetailInfoVC = [[XXEClassManagerClassDetailInfoViewController alloc] init];
    
    XXEClassManagerClassListModel *model = _dataSourceArray[indexPath.row];
    classManagerClassDetailInfoVC.classNameStr = model.class_name;
    classManagerClassDetailInfoVC.classNumStr = model.classNum;
    classManagerClassDetailInfoVC.teacherStr = model.teacher_boss;
    
    classManagerClassDetailInfoVC.schoolId = _schoolId;
    classManagerClassDetailInfoVC.schoolType = _schoolType;
    classManagerClassDetailInfoVC.classId = model.class_id;
    classManagerClassDetailInfoVC.position = _position;
    classManagerClassDetailInfoVC.condit = model.condit;


    [self.navigationController pushViewController:classManagerClassDetailInfoVC animated:YES];
    
}

//发布
- (void)createReleaseButton{
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];

    releaseButton.frame = CGRectMake(0, _myTableView.frame.origin.y + _myTableView.frame.size.height, KScreenWidth, KScreenHeight - (_myTableView.frame.origin.y + _myTableView.frame.size.height) - 64 - 50 * kScreenRatioHeight);
    releaseButton.backgroundColor = UIColorFromRGB(0, 170, 42);
    [releaseButton setTitle:@"发布班级" forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:16 * kScreenRatioWidth];
    [releaseButton addTarget:self action:@selector(releaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
    
}

- (void)releaseButtonClick{
    XXEClassManagerClassReleaseViewController *classManagerClassReleaseVC = [[XXEClassManagerClassReleaseViewController alloc] init];
    
    classManagerClassReleaseVC.schoolId = _schoolId;
    classManagerClassReleaseVC.schoolType = _schoolType;
    classManagerClassReleaseVC.classId = _classId;
    classManagerClassReleaseVC.position = _position;
    
    [self.navigationController pushViewController:classManagerClassReleaseVC animated:YES];
    

}

@end
