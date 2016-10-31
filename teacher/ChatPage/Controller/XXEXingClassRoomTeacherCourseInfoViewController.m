
//
//  XXEXingClassRoomTeacherCourseInfoViewController.m
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomTeacherCourseInfoViewController.h"
#import "XXEXingClassRoomCourseDetailInfoViewController.h"
#import "XXEXingClassRoomCourseListTableViewCell.h"
#import "XXEXingClassRoomCourseListModel.h"

@interface XXEXingClassRoomTeacherCourseInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    NSMutableArray *_dataSourceArray;
    //传参 xid
    NSString *parameterXid;
    //传参 user_id
    NSString *parameterUser_Id;
}

@end

@implementation XXEXingClassRoomTeacherCourseInfoViewController

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
    
//        NSLog(@"=====  %@", _course_groupArray);
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
        
        NSArray *modelArray = [XXEXingClassRoomCourseListModel parseResondsData:_course_groupArray];
        
        [_dataSourceArray addObjectsFromArray:modelArray];
    }
    [_myTableView reloadData];
}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,  KScreenHeight / 3  * 2 - 49) style:UITableViewStyleGrouped];
    
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
    XXEXingClassRoomCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEXingClassRoomCourseListTableViewCell" owner:self options:nil]lastObject];
    }
    XXEXingClassRoomCourseListModel *model = _dataSourceArray[indexPath.row];
    
    cell.iconImageView.layer.cornerRadius= cell.iconImageView.bounds.size.width/2;
    cell.iconImageView.layer.masksToBounds=YES;
    
    NSString *coursePicStr = [NSString stringWithFormat:@"%@%@", kXXEPicURL, model.course_pic];
    //        NSLog(@"hhh %@", coursePicStr);
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:coursePicStr] placeholderImage:[UIImage imageNamed:@"home_logo_course_icon80x80"]];
    cell.distanceLabel.hidden = YES;
    //
    cell.courseLabel.text = model.course_name;
    
    if ([model.teacher_tname_group count] != 0) {
        cell.nameLabel.text = [NSString stringWithFormat:@"授课老师:%@",model.teacher_tname_group[0]];
    }
    
    cell.totalLabel.text = [NSString stringWithFormat:@"%@人班", model.need_num];
    NSInteger leftNum = [model.need_num integerValue] - [model.now_num integerValue];
    
    cell.leftLabel.text = [NSString stringWithFormat:@"还剩%ld人", leftNum];
    cell.priceLabel.text = [NSString stringWithFormat:@"原价:%@   限时抢购价:%@", model.original_price, model.now_price];
    /*
     [coin] => 0				//0:不允许猩币抵扣 1:允许猩币抵扣
     [allow_return] => 0			//是否允许退课 0:不允许,1:允许
     */
    
    if ([model.coin isEqualToString:@"0"]) {
        cell.xingCoinBtn.hidden = YES;
    }else if ([model.coin isEqualToString:@"1"]){
        cell.xingCoinBtn.hidden = NO;
    }
    
    if ([model.allow_return isEqualToString:@"0"]) {
        cell.quitBtn.hidden = YES;
    }else if ([model.allow_return isEqualToString:@"1"]) {
        cell.quitBtn.hidden = NO;
    }
    
    if ([model.now_num isEqualToString:model.need_num]) {
        cell.fullBtn.hidden = NO;
    }else{
        cell.fullBtn.hidden = YES;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        XXEXingClassRoomCourseDetailInfoViewController *xingClassRoomCourseDetailInfoVC = [[XXEXingClassRoomCourseDetailInfoViewController alloc] init];
        XXEXingClassRoomCourseListModel *model = _dataSourceArray[indexPath.row];
        xingClassRoomCourseDetailInfoVC.course_id = model.courseId;
    
        [self.navigationController pushViewController:xingClassRoomCourseDetailInfoVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
