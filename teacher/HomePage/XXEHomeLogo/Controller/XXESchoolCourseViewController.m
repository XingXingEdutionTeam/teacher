

//
//  XXESchoolCourseViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolCourseViewController.h"
#import "XXESchoolCourseTableViewCell.h"
#import "XXESchoolCourseModel.h"


@interface XXESchoolCourseViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    NSMutableArray *_dataSourceArray;
    //传参 xid
    NSString *parameterXid;
    //传参 user_id
    NSString *parameterUser_Id;
}


@end

@implementation XXESchoolCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSourceArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createData];
    
    [self createTableView];
    
//    NSLog(@"=====  %@", _course_groupArray);
}

- (void)createData{
    if (_course_groupArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, _myTableView.frame.size.height / 2, myImageWidth, myImageHeight)];
        myImageView.backgroundColor = [UIColor redColor];
        myImageView.image = myImage;
        [_myTableView addSubview:myImageView];
        
//        [_myTableView bringSubviewToFront:myImageView];

    }else{
    
        NSArray *modelArray = [XXESchoolCourseModel parseResondsData:_course_groupArray];
        
        [_dataSourceArray addObjectsFromArray:modelArray];
    }
    [_myTableView reloadData];
}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    
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
    XXESchoolCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[XXESchoolCourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    XXESchoolCourseModel *model = _dataSourceArray[indexPath.row];
    
//    NSLog(@"model --- %@", model);
    
    cell.bookIconImage.layer.cornerRadius= cell.bookIconImage.bounds.size.width/2;
    cell.bookIconImage.layer.masksToBounds=YES;
    
    NSString *coursePicStr = [NSString stringWithFormat:@"%@%@", kXXEPicURL, model.course_pic];
//        NSLog(@"hhh %@", coursePicStr);
    [cell.bookIconImage sd_setImageWithURL:[NSURL URLWithString:coursePicStr] placeholderImage:[UIImage imageNamed:@"home_logo_course_icon80x80"]];
    
    //
    cell.courseNameLabel.text = model.course_name;
    
    if ([model.teacher_tname_group count] != 0) {
        
        for (int i = 0; i < [model.teacher_tname_group count]; i++) {
            UILabel *teacherNameLabel = [UILabel createLabelWithFrame:CGRectMake((190 + 65 * i) * kWidth / 375, 35 , 60 * kWidth / 375, 20) Font:14 * kWidth / 375 Text:model.teacher_tname_group[i]];
            [cell.contentView addSubview:teacherNameLabel];
        }
        
    }
    
    cell.totalNumberLabel.text = [NSString stringWithFormat:@"%@人班级", model.need_num];
    NSInteger leftNum = [model.need_num integerValue] - [model.now_num integerValue];
    
    cell.numberLabel.text = [NSString stringWithFormat:@"还剩%ld人", leftNum];
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"原价:%@", model.original_price];
    cell.nowPriceLbl.text = [NSString stringWithFormat:@"限时抢购价:%@", model.now_price];
    
    //    cell.coinImageView.image = [UIImage imageNamed:@"猩币icon28x30"];
    //    cell.reduceImageView.image = [UIImage imageNamed:@"退icon28x30@2x.png"];
    //    cell.saveImageView.image = [UIImage imageNamed:@"收藏icon28x30"];
    cell.fullImageView.image = [UIImage imageNamed:@"home_logo_course_state_icon28x30"];
    //剩余 人数 不为0 ,说明 还没招满,则该"满员"图标 不显示
    if (leftNum != 0) {
        cell.fullImageView.hidden = YES;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    XXECommentHistoryDetailInfoViewController *commentHistoryDetailInfoVC = [[XXECommentHistoryDetailInfoViewController alloc] init];
//    
//    XXECommentRequestModel *model = _dataSourceArray[indexPath.row];
//    commentHistoryDetailInfoVC.name = model.baby_tname;
//    commentHistoryDetailInfoVC.ask_con = model.ask_con;
//    commentHistoryDetailInfoVC.ask_time = model.ask_tm;
//    commentHistoryDetailInfoVC.com_con = model.com_con;
//    commentHistoryDetailInfoVC.picString = model.com_pic;
//    commentHistoryDetailInfoVC.type = model.type;
//    
//    [self.navigationController pushViewController:commentHistoryDetailInfoVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
