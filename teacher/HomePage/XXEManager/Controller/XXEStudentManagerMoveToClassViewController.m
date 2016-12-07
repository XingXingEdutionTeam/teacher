
//
//  XXEStudentManagerMoveToClassViewController.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentManagerMoveToClassViewController.h"
#import "XXEClassAddressHeadermasterAndManagerApi.h"
#import "XXEClassAddressHeadermasterAndManagerModel.h"
#import "XXEStudentManagerMoveApi.h"

@interface XXEStudentManagerMoveToClassViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    //占位图
    UIImageView *placeholderImageView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, copy) NSString *selectedClassId;


@end

@implementation XXEStudentManagerMoveToClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"通讯录";
    
    [self createTableView];
    
    [self fetchNetData];
}

- (void)fetchNetData{
    /*
     【某个学校所有班级名称列表(当身份时校长和管理员时用到)】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/school_all_class
     
     传参:
     school_id	//学校id
     school_type	//学校类型 */
    //    NSLog(@"%@ --  %@", _schoolId, _schoolType);
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    XXEClassAddressHeadermasterAndManagerApi *classAddressHeadermasterAndManagerApi = [[XXEClassAddressHeadermasterAndManagerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId school_type:_schoolType];
    [classAddressHeadermasterAndManagerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
//                NSLog(@"2222---   %@", request.responseJSONObject);
        
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 44) style:UITableViewStyleGrouped];
    
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    XXEClassAddressHeadermasterAndManagerModel *model = _dataSourceArray[indexPath.row];
    cell.textLabel.text = model.class_name;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXEClassAddressHeadermasterAndManagerModel *model = _dataSourceArray[indexPath.row];
    NSString *moveToClassId = model.class_id;
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定移动到该班级？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#pragma mark - 移动=================================================
        
        [self moveToClass:moveToClassId];
        //        XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[button superview] superview];
        //        NSIndexPath *path = [_myTableView indexPathForCell:cell];
        //        NSLog(@"---------index row %ld; %ld", path.row, path.section);
        //        CommentsModel *model = [[CommentsModel alloc] init];
        
        //        CommentsModel *groupModel = dataSource[path.section];
        //        [groupModel.groupFriends removeObjectAtIndex:path.row];
        //
        //        [expandTable deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        //        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)moveToClass:(NSString *)moveToClassId{

//    NSLog(@"--%@", moveToClassId);
    XXEStudentManagerMoveApi *studentManagerMoveApi = [[XXEStudentManagerMoveApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:_currentSelectedClassId baby_id:_babyId move_class_id:moveToClassId];
    
    [studentManagerMoveApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//      NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"移动成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
