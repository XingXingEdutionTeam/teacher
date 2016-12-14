

//
//  XXENotificationViewController.m
//  teacher
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXENotificationViewController.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXESchoolNotificationDetailViewController.h"
#import "XXESystemNotificationDetailViewController.h"
#import "XXESchoolNotificationModel.h"
#import "XXESystemNotificationModel.h"
#import "XXESystemNotificationApi.h"
#import "XXESchoolNotificationApi.h"
#import "XXEAuditAndReleaseViewController.h"
#import "SysteamNotificationViewController.h"
#import "SchoolNotificationViewController.h"

@interface XXENotificationViewController ()
{
//    UITableView *_myTableView;
    UISegmentedControl *segementedControl;
    //学校通知 a=0; 系统通知 a=1;
//    NSInteger a;
    NSString *condit;
    
    //学校通知 数据
//    NSMutableArray *_schoolDataSourceArray;
//    //系统通知 数据
//    NSMutableArray *_systemDataSourecArray;
    //学校通知 page
//    NSInteger schoolPage;
//    //系统通知 page
//    NSInteger systemPage;
//    //身份
    NSString *position;
//    //数据请求参数
//    NSString *parameterXid;
//    NSString *parameterUser_Id;
//    //无数据 时 的占位图
//    UIImageView *placeholderImageView;
    
}
@property(nonatomic ,strong)EmptyView *empty;
@property(nonatomic ,strong)SysteamNotificationViewController *sysVC;
@property(nonatomic ,strong)SchoolNotificationViewController *schoolVC;
@property(nonatomic, strong)UIViewController *currentController;

@end

@implementation XXENotificationViewController

-(SysteamNotificationViewController *)sysVC {
    if (!_sysVC) {
        _sysVC = [[SysteamNotificationViewController alloc] init];
        _sysVC.schoolId = self.schoolId;
        _sysVC.classId = self.classId;
        _sysVC.schoolInfo = self.schoolInfo;
    }
    
    return _sysVC;
}

-(SchoolNotificationViewController *)schoolVC {
    if (!_schoolVC) {
        _schoolVC = [[SchoolNotificationViewController alloc] init];
        _schoolVC.schoolId = self.schoolId;
        _schoolVC.classId = self.classId;
        _schoolVC.schoolInfo = self.schoolInfo;
    }
    
    return _schoolVC;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    if (_schoolDataSourceArray.count != 0) {
//        [_schoolDataSourceArray removeAllObjects];
//    }
//    
//    if (_systemDataSourecArray.count != 0) {
//        [_systemDataSourecArray removeAllObjects];
//    }
//    
//    schoolPage = 0;
//    systemPage = 0;
    if (condit == nil) {
        condit = @"0";
    }

//    if ([condit integerValue] == 0) {
//        //        a = 0;
//        [self fetchSchoolNetData];
//        
//    }else if ([condit integerValue] == 1){
//        //        a = 1;
//        [self fetchSystemNetData];
//    }
    
//    [_myTableView reloadData];
    
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    [_myTableView.header beginRefreshing];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
//    _schoolDataSourceArray = [[NSMutableArray alloc] init];
//    _systemDataSourecArray = [[NSMutableArray alloc] init];
//    
//    if ([XXEUserInfo user].login){
//        parameterXid = [XXEUserInfo user].xid;
//        parameterUser_Id = [XXEUserInfo user].user_id;
//    }else{
//        parameterXid = XID;
//        parameterUser_Id = USER_ID;
//    }
    

//    a = 0;
    condit = @"0";
    
//    position = [DEFAULTS objectForKey:@"POSITION"];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;    

    UIButton *rightBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_notification_release_icon44x44" Target:self Action:@selector(rightBtnClick:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem =sentItem;
    
    [self createSegementControl];
    
//    [self createTableView];
    
}


#pragma Mark **********  右上角 按钮 **************
- (void)rightBtnClick:(UIButton *)button{

    if ([XXEUserInfo user].login) {
        XXEAuditAndReleaseViewController *auditAndReleaseVC = [[XXEAuditAndReleaseViewController alloc] init];
        
        auditAndReleaseVC.schoolId = _schoolId;
        auditAndReleaseVC.classId = _classId;
        
        [self.navigationController pushViewController:auditAndReleaseVC animated:YES];
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
    }
    
}

- (void)createSegementControl{
    
    CGFloat segWidth = 100 * kScreenRatioWidth;
    CGFloat segHeight = 30 * kScreenRatioHeight;
    
    segementedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake((KScreenWidth - segWidth)/2, (49 - segHeight)/2, segWidth, segHeight)];
    [segementedControl insertSegmentWithTitle:@"系统通知" atIndex:0 animated:NO];
    [segementedControl insertSegmentWithTitle:@"校园通知" atIndex:1 animated:NO];
    self.navigationItem.titleView = segementedControl;
    segementedControl.tintColor = [UIColor whiteColor];
    segementedControl.selectedSegmentIndex = 0;
    [segementedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];

    [self addChildViewController:self.sysVC];
    [self addChildViewController:self.schoolVC];
    [self.view addSubview:self.sysVC.view];
    self.currentController = self.sysVC;
}

- (void)controlPressed:(UISegmentedControl *)segment{
   condit = [NSString stringWithFormat:@"%ld", segment.selectedSegmentIndex];
    if ([condit integerValue] == 0) {
        
        [self transitionFromViewController:self.currentController toViewController:self.sysVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        }  completion:^(BOOL finished) {
            //......
        }];
        self.currentController=self.sysVC;
    }else if ([condit integerValue] == 1){
        [self transitionFromViewController:self.currentController toViewController:self.schoolVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        }  completion:^(BOOL finished) {
            //......
        }];
        self.currentController=self.schoolVC;
//        a = 1;
//        [self fetchSystemNetData];
    }
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([XXEUserInfo user].login) {
//        switch ([condit integerValue]) {
//            case 0:
//            {
//                XXESchoolNotificationDetailViewController *schoolNotificationDetailVC =[[XXESchoolNotificationDetailViewController alloc]init];
//                XXESchoolNotificationModel *model = _schoolDataSourceArray[indexPath.row];
//                
//                schoolNotificationDetailVC.name = model.school_name;
//                //[type] => 2		//通知范围需要  1:班级通知, 2:学校通知
//                if ([model.type integerValue] == 1) {
//                    schoolNotificationDetailVC.scope = @"班级通知";
//                }else if ([model.type integerValue] == 2){
//                    schoolNotificationDetailVC.scope = @"学校通知";
//                }
//                
//                schoolNotificationDetailVC.time =[XXETool dateStringFromNumberTimer:model.date_tm];
//                schoolNotificationDetailVC.content = model.con;
//                schoolNotificationDetailVC.titleStr = model.title;
//                [self.navigationController pushViewController:schoolNotificationDetailVC animated:YES];
//            }
//                break;
//            case 1:
//            {
//                XXESystemNotificationDetailViewController *systemNotificationDetailVC =[[XXESystemNotificationDetailViewController alloc]init];
//                XXESystemNotificationModel *model = _systemDataSourecArray[indexPath.row];
//                
//                systemNotificationDetailVC.name = model.school_name;
//                systemNotificationDetailVC.time =[XXETool dateStringFromNumberTimer:model.date_tm];
//                systemNotificationDetailVC.content = model.con;
//                systemNotificationDetailVC.titleStr = model.title;
//                [self.navigationController pushViewController:systemNotificationDetailVC animated:YES];
//            }
//                break;
//            default:
//                break;
//        }
//
//    }else{
//        [self showString:@"请用账号登录后查看" forSecond:1.5];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
