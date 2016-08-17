//
//  XXEHomePageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomePageViewController.h"
#import "XXEHomePageHeaderView.h"
#import "XXEHomePageMiddleView.h"
#import "XXEHomePageBottomView.h"
#import "XXEHomePageApi.h"
#import "XXEUserInfo.h"
#import "XXEHomePageModel.h"
#import "XXEHomePageSchoolModel.h"
#import "XXEHomePageClassModel.h"
#import "XXELoginViewController.h"
#import "XXEClassAlbumViewController.h"
#import "XXEXingCoinViewController.h"
#import "XXEFlowerbasketViewController.h"
#import "XXETeacherUserInfo.h"
#import "XXERedFlowerSentHistoryViewController.h"
#import "XXECommentRootViewController.h"


//监控
#import "VideoMonitorViewController.h"

@interface XXEHomePageViewController ()<XXEHomePageHeaderViewDelegate,XXEHomePageMiddleViewDelegate,XXEHomePageBottomViewDelegate>
@property (nonatomic, strong)NSMutableArray *schoolDatasource;//学校信息
@property (nonatomic, strong)NSMutableArray *classDatasource;//班级信息

@property (nonatomic, strong)XXEHomePageHeaderView *headView;
@property (nonatomic, strong)XXEHomePageMiddleView *middleView;

/** 下拉框 学校 */
@property (nonatomic, strong)WJCommboxView *homeSchoolView;
/** 下拉框 班级 */
@property (nonatomic, strong)WJCommboxView *homeClassView;

/** 学校ID */
@property (nonatomic, copy)NSString *schoolHomeId;
/** 班级ID */
@property (nonatomic, copy)NSString *classHomeId;

@property (nonatomic, strong)NSMutableArray *arraySchool;
@property (nonatomic, strong)NSMutableArray *arrayClass;

@end

@implementation XXEHomePageViewController

- (NSMutableArray *)arraySchool
{
    if (!_arraySchool) {
        _arraySchool = [NSMutableArray array];
    }
    return _arraySchool;
}

- (NSMutableArray *)arrayClass
{
    if (!_arrayClass) {
        _arrayClass = [NSMutableArray array];
    }
    return _arrayClass;
}

- (NSMutableArray *)schoolDatasource
{
    if (!_schoolDatasource) {
        _schoolDatasource = [NSMutableArray array];
    }
    return _schoolDatasource;
}

- (NSMutableArray *)classDatasource
{
    if (!_classDatasource) {
        _classDatasource = [NSMutableArray array];
    }
    return _classDatasource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = YES;
}
/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 下拉选择框
- (void)setUpDropDownSelection
{
    self.homeSchoolView = [[WJCommboxView alloc] initWithFrame:CGRectMake(60 * kScreenRatioWidth, 45 * kScreenRatioWidth, 120 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
    self.homeSchoolView.dataArray = self.schoolDatasource;
    [self.view addSubview:self.homeSchoolView];
    
    self.homeSchoolView.textField.placeholder = @"学校";
    self.homeSchoolView.textField.text = @"请选择学校";
    self.homeSchoolView.textField.textAlignment = NSTextAlignmentCenter;
    self.homeSchoolView.textField.tag = 102;
    self.homeSchoolView.textField.layer.cornerRadius =10 * KScreenWidth / 375;
    self.homeSchoolView.textField.layer.masksToBounds =YES;
    
    //班级
    self.homeClassView = [[WJCommboxView alloc] initWithFrame:CGRectMake(60 * kScreenRatioWidth+120 * kScreenRatioWidth+5, 45*kScreenRatioWidth, 120 * kScreenRatioWidth, 30 * kScreenRatioHeight)];
    
    self.homeClassView.dataArray = self.classDatasource;
    //    NSLog(@"学校数组:%@",self.homeClassView.dataArray);
    [self.view addSubview:self.homeClassView];
    
    self.homeClassView.textField.placeholder = @"班级";
    self.homeClassView.textField.text = @"请选择你的班级";
    self.homeClassView.textField.textAlignment = NSTextAlignmentCenter;
    self.homeClassView.textField.tag = 103;
    self.homeClassView.textField.layer.cornerRadius =10 * KScreenWidth / 375;
    self.homeClassView.textField.layer.masksToBounds =YES;

//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(calssAction:) name:@"commboxNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(calssAction2:) name:@"commboxNotice2" object:nil];
    
}

//- (void)calssAction:(NSNotification *)notif
//{
//    switch ([notif.object integerValue]) {
//        case 102:
//            [self.self.homeClassView removeFromSuperview];
//            [self.view addSubview:self.homeClassView];
//            break;
//        case 103:
//            [self.self.homeSchoolView removeFromSuperview];
//            [self.view addSubview:self.homeSchoolView];
//            
//        default:
//            break;
//    }
//}

#pragma mark - 通知选择的学校

- (void)calssAction2:(NSNotification *)notif
{
    NSLog(@"%@",notif.object);
    NSLog(@"%@",self.homeSchoolView.textField.text);
    NSString *string = self.homeSchoolView.textField.text;
    for (XXETeacherUserInfo *model in self.arraySchool) {
        if ([model.school_name isEqualToString:string]) {
            self.homeClassView.textField.text = model.class_name;
            self.schoolHomeId = model.school_id;
            self.classHomeId = model.class_id;
            
            NSLog(@"%@ %@",model.school_id,model.class_id);
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"首页控制器");
    
    self.headView = [[XXEHomePageHeaderView alloc]init];
    self.headView.frame = CGRectMake(0, 0, KScreenWidth, 276*kScreenRatioHeight);
    self.headView.delegate = self;
    self.middleView = [[XXEHomePageMiddleView alloc]initWithFrame:CGRectMake(0, 276*kScreenRatioHeight, KScreenWidth, 43*kScreenRatioHeight)];
    self.middleView.delegate = self;
    
    XXEHomePageBottomView *bottomView = [[XXEHomePageBottomView alloc]initWithFrame:CGRectMake(0, self.middleView.frame.origin.y+43*kScreenRatioHeight, KScreenWidth, 290*kScreenRatioHeight)];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [self.view addSubview:self.middleView];
    [self.view addSubview:self.headView];

    //获取数据
        [self setupHomePageRequeue];
}

#pragma mark - 点击代理方法 Delegate
//顶部视图
- (void)homePageLeftButtonClick
{
    NSLog(@"---跳转到学校的详情页----");
}

- (void)homePageRightButtonClick
{
    NSLog(@"----跳转到登录页面----");
    XXELoginViewController *loginVC = [[XXELoginViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = loginVC;
}
//中部视图
- (void)homeMiddleFirstButtonClick
{
    NSLog(@"----花篮点击事件----");
    XXEFlowerbasketViewController *XXEFlowerbasketVC = [[XXEFlowerbasketViewController alloc] init];
    
    [self.navigationController pushViewController:XXEFlowerbasketVC animated:YES];
}

- (void)homeMiddleTwoButtonClick
{
    NSLog(@"---小红花点击事件----");
    //    NSLog(@"---小红花点击事件----");
    XXERedFlowerSentHistoryViewController *redFlowerSentHistoryVC = [[XXERedFlowerSentHistoryViewController alloc] init];
    //
    redFlowerSentHistoryVC.schoolId = self.schoolHomeId;
    redFlowerSentHistoryVC.classId = self.classHomeId;
    //    NSLog(@"%@%@",self.schoolHomeId,self.classHomeId);
    
    [self.navigationController pushViewController:redFlowerSentHistoryVC animated:YES];
    
    
}

- (void)homeMiddleThreeButtonClick
{
    NSLog(@"----猩币点击事件---");
    XXEXingCoinViewController *xingCoinVC = [[XXEXingCoinViewController alloc] init];
    [self.navigationController pushViewController:xingCoinVC animated:YES];
}

//下部视图点击相应的方法
- (void)homeClassOneButtonClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
        { NSLog(@"----实时监控----");
            VideoMonitorViewController *videoVC = [[VideoMonitorViewController alloc]init];
            [self.navigationController pushViewController:videoVC animated:YES];
            break;
        }
        case 1:
        {
            NSLog(@"---相册----");
            XXEClassAlbumViewController *classAlbumVC = [[XXEClassAlbumViewController alloc]init];
            classAlbumVC.schoolID = self.schoolHomeId;
            classAlbumVC.classID = self.classHomeId;
            NSLog(@"%@%@",self.schoolHomeId,self.classHomeId);
            [self.navigationController pushViewController:classAlbumVC animated:YES];
            break;
        }
        case 2:
            NSLog(@"----课程表----");
            break;
        case 3:
            NSLog(@"---通讯录----");
            break;
        case 4:
            NSLog(@"----聊天----");
            break;
        case 5:
        {
            NSLog(@"---点评----");
            //XXECommentRootViewController
//            XXECommentRequestViewController *commentRequestVC = [[XXECommentRequestViewController alloc] init];
//            commentRequestVC.classId = self.classHomeId;
//            [self.navigationController pushViewController:commentRequestVC animated:YES];
            
            XXECommentRootViewController *commentRootVC = [[XXECommentRootViewController alloc] init];
            commentRootVC.classId = self.classHomeId;
            [self.navigationController pushViewController:commentRootVC animated:NO];
            break;
        }
        case 6:
            NSLog(@"----作业----");
            break;
        case 7:
            NSLog(@"---食谱----");
            break;
        case 8:
            NSLog(@"----签到----");
            break;
        case 9:
            NSLog(@"---签到----");
            break;
        case 10:
            NSLog(@"----星天地----");
            break;
        case 11:
            NSLog(@"---猩猩商城----");
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 获取数据
- (void)setupHomePageRequeue
{
    NSString *strngXid;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
    }else {
        strngXid = @"18886389";
    }
    XXEHomePageApi *homePageApi = [[XXEHomePageApi alloc]initWithHomePageXid:strngXid];
    [homePageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString * code = [request.responseJSONObject objectForKey:@"code"];
        
        if ([code intValue] == 1) {
            [self showHudWithString:@"正在请求数据..."];
            
            NSLog(@"%@",request.responseJSONObject  );
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            XXEHomePageModel *homePageModel = [[XXEHomePageModel alloc]initWithDictionary:data error:nil];
            NSLog(@"%@",homePageModel);
            [self.headView configCellWithInfo:homePageModel];
            [self.middleView configCellMiddleWithInfo:homePageModel];
            
            
            for (int i =0; i < homePageModel.school_info.count; i++) {
                
                XXEHomePageSchoolModel *schoolInfo = ((XXEHomePageSchoolModel *)(homePageModel.school_info[i]));
                XXETeacherUserInfo *modelInfo = [[XXETeacherUserInfo alloc]init];
                modelInfo.school_name = schoolInfo.school_name;
                modelInfo.school_id = schoolInfo.school_id;
                [self.arraySchool addObject:modelInfo];
                
                [self.schoolDatasource addObject:schoolInfo.school_name];
                
                for (XXEHomePageClassModel *classInfo in schoolInfo.class_info) {
                    modelInfo.class_id = classInfo.class_id;
                    modelInfo.class_name = classInfo.class_name;
                    [self.arrayClass addObject:modelInfo];
                    [self.classDatasource addObject:classInfo.class_name];
                }
            }
            
            NSLog(@"学校%@ 班级%@",self.arraySchool[0],self.arrayClass[1]);
            
        } else {
            [self showHudWithString:@"数据请求失败" forSecond:1.f];
        }
                //创建下拉选择框
        [self setUpDropDownSelection];
        [self hideHud];
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showHudWithString:@"数据请求失败" forSecond:1.f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc方法");
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
