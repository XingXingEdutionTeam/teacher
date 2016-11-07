

//
//  XXESchoolTimetableCourseViewController.m
//  teacher
//
//  Created by Mac on 16/11/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableCourseViewController.h"
#import "XXESchoolTimetableCourseDetailViewController.h"
#import "XXESchoolTimetableAddCourseViewController.h"
#import "XXESchoolTimetableCourseTableViewCell.h"
#import "XXESchoolTimetableCourseDeleteApi.h"
#import "XXESchoolTimetableCourseApi.h"
#import "XXESchoolTimetableModel.h"


@interface XXESchoolTimetableCourseViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *_courseModelArray;
    
    NSMutableArray *modifyInfoArray;
    
    //
    NSString *parame_data;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;


}


@end

@implementation XXESchoolTimetableCourseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSLog(@"_week_date:%@ ---- parame_data:%@", _week_date, parame_data);
    
//
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    modifyInfoArray = [[NSMutableArray alloc] init];
    
//    NSLog(@"_courseDataArray -- %@", _courseDataArray);
    NSError *error;
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:_courseDataArray  options:kNilOptions error:&error];
    parame_data =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"parame_data --%@", parame_data);
    
//    NSLog(@"_week_date --- %@", _week_date);

    [self fetchNetData];
    
    [self createTableView];
    
    [self createRightButton];

}

- (void)createRightButton{
    UIButton *addButton =[UIButton createButtonWithFrame:CGRectMake(0, 0, 25, 25) backGruondImageName:@"home_flowerbasket_addIcon44x44" Target:self Action:@selector(addButtonClick:) Title:@""];
    UIBarButtonItem *addItem =[[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem =addItem;
}

- (void)addButtonClick:(UIButton *)button{
    XXESchoolTimetableAddCourseViewController *schoolTimetableAddCourseVC = [[XXESchoolTimetableAddCourseViewController alloc] init];
    
    
    [self.navigationController pushViewController:schoolTimetableAddCourseVC animated:YES];
}

- (void)fetchNetData{
    
    XXESchoolTimetableCourseApi *schoolTimetableCourseApi = [[XXESchoolTimetableCourseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id week_date:_week_date parame_data:parame_data];
    [schoolTimetableCourseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"结果 === %@", request.responseJSONObject);
        
        
        NSString *codeStr = request.responseJSONObject[@"code"];
        if ([codeStr integerValue] == 1) {
            _courseModelArray = [[NSMutableArray alloc] init];
            NSArray *modelArray = [XXESchoolTimetableModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [_courseModelArray addObjectsFromArray:modelArray];
 
        }
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];

}

// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_courseDataArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
    
    }
    [_myTableView reloadData];
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
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
    
    return _courseModelArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXESchoolTimetableCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXESchoolTimetableCourseTableViewCell" owner:self options:nil]lastObject];
    }
    XXESchoolTimetableModel *model = _courseModelArray[indexPath.row];
    
//    NSLog(@"model === %@", model);
    
    cell.courseNameLabel.text = [NSString stringWithFormat:@"课程名:%@", model.course_name];
    cell.classLabel.text = [NSString stringWithFormat:@"班级:%@", model.classroom];
    cell.teacherNameLabel.text = [NSString stringWithFormat:@"老师:%@", model.teacher_name];
    cell.otherLabel.text = [NSString stringWithFormat:@"上下课时间:%@~%@", model.lesson_start_tm,model.lesson_end_tm ];
    cell.startTimeLabel.text = [NSString stringWithFormat:@"地址:%@", model.notes];    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000000001;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //[type] => 3			//类型,3是自定义,允许修改
    
    XXESchoolTimetableModel *model = _courseModelArray[indexPath.row];
    
//    NSLog(@"model.type --- %@", model.type);
    if ([model.type integerValue] == 3) {
        if(editingStyle == UITableViewCellEditingStyleDelete)
        {
            [self deleteCourse:indexPath];
            
        }

    }else{
    
        [self showString:@"不能删除非自定义的课程" forSecond:1.5];
    }
}


- (void)deleteCourse:(NSIndexPath *)path{
    XXESchoolTimetableModel *model = _courseModelArray[path.row];
    NSString *schedule_id = model.schedule_id;
    
    XXESchoolTimetableCourseDeleteApi *schoolTimetableCourseDeleteApi = [[XXESchoolTimetableCourseDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id schedule_id:schedule_id];
    [schoolTimetableCourseDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {

//              NSLog(@"2222---   %@", request.responseJSONObject);

        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];

        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"删除成功!" forSecond:1.5];

            [_courseModelArray removeObjectAtIndex:path.row];
            [_myTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];

        }else{
            [self showHudWithString:@"删除失败!" forSecond:1.5];
        }
        [self customContent];
    } failure:^(__kindof YTKBaseRequest *request) {

        [self showString:@"数据请求失败" forSecond:1.f];
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    XXESchoolTimetableCourseDetailViewController *schoolTimetableCourseDetailVC = [[XXESchoolTimetableCourseDetailViewController alloc] init];
        XXESchoolTimetableModel *model = _courseModelArray[indexPath.row];
    schoolTimetableCourseDetailVC.type = model.type;
    schoolTimetableCourseDetailVC.schedule_id = model.schedule_id;
    schoolTimetableCourseDetailVC.wd = model.wd;
    schoolTimetableCourseDetailVC.week_date = _week_date;
    schoolTimetableCourseDetailVC.model = model;
    
    [schoolTimetableCourseDetailVC returnArray:^(NSMutableArray *modifyArray) {
        //
        
//        NSLog(@"aaaaa %@", _courseDataArray);
        
        NSMutableArray *oldMarray = [[NSMutableArray alloc] initWithArray:_courseDataArray];
        
        modifyInfoArray = modifyArray;//课程名称,tm
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:_courseDataArray[indexPath.row]];
        mDic[@"name"] = modifyArray[0];
        mDic[@"tm"] = modifyArray[1];
        
        [oldMarray replaceObjectAtIndex:indexPath.row withObject:mDic];
        _courseDataArray = oldMarray;
        
//        NSLog(@"bbbb %@", _courseDataArray);
        
        NSError *error;
        NSData *jsonData =[NSJSONSerialization dataWithJSONObject:_courseDataArray  options:kNilOptions error:&error];
        parame_data =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//        _courseDataArray -- (
//                             {
//                                 "course_id" = 0;
//                                 name = Ccccccccc;
//                                 tm = " 20:20";
//                                 type = 3;
//                                 wd = wednesday;
//                             }
//                             )

        
        [self fetchNetData];
    }];

    [self.navigationController pushViewController:schoolTimetableCourseDetailVC animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
