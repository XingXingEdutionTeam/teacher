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
#import "XXEHomeworkViewController.h"
#import "XXERecipeViewController.h"
#import "XXEHomeLogoRootViewController.h"
#import "XXENavigationViewController.h"
//编辑身份
#import "XXEAddIdentityViewController.h"
//监控
#import "VideoMonitorViewController.h"
#import "XXEClassAddressHeadermasterAndManagerViewController.h"
#import "XXEClassAddressEveryclassInfoViewController.h"
#import "XXESignInViewController.h"
//猩天地
#import "XXEXingCommunityViewController.h"
//通知
#import "XXENotificationViewController.h"
//管理
#import "XXEManagerTeacherViewController.h"
#import "XXEManagerManagerPrivateViewController.h"
#import "XXEManagerManagerPublicViewController.h"
#import "XXEManagerHeadmasterPrivateViewController.h"
#import "XXEManagerHeadmasterPublicViewController.h"
#import "XXRootChatETabBarController.h"
#import "RCUserInfo+XXEAddition.h"
#import <RongIMKit/RongIMKit.h>
#import "XXERCDataManager.h"
//课程表
#import "XXESchoolTimetableViewController.h"
//猩商城
#import "XXEStoreRootViewController.h"

#import "XXENewCourseView.h"

#import "AppDelegate.h"

@interface XXEHomePageViewController ()<XXEHomePageHeaderViewDelegate,XXEHomePageMiddleViewDelegate,XXEHomePageBottomViewDelegate>
{

    //左边 选中 学校 的是第几行
    NSInteger didSelectedSchoolRow;
    //
    NSString *babySchoolName;
    NSString *babyClassName;
    
}


@property (nonatomic, strong)NSMutableArray *schoolDatasource;//学校信息
@property (nonatomic, strong)NSMutableArray *classDatasource;//班级信息

@property (nonatomic, strong)XXEHomePageHeaderView *headView;
@property (nonatomic, strong)XXEHomePageMiddleView *middleView;

/** 学校数组里面包含班级Model */
@property (nonatomic, strong)NSMutableArray *schoolModelDatasource;

/** 下拉框 学校 */
@property (nonatomic, strong)WJCommboxView *homeSchoolView;
//学校 下拉框 背景
@property (nonatomic, strong) UIView *schoolBgView;

/** 下拉框 班级 */
@property (nonatomic, strong)WJCommboxView *homeClassView;
//班级 下拉框 背景
@property (nonatomic, strong) UIView *classBgView;

/** 学校ID */
@property (nonatomic, copy)NSString *schoolHomeId;
/** 班级ID */
@property (nonatomic, copy)NSString *classHomeId;
//学校 类型
@property (nonatomic, copy) NSString *schoolType;

/** 用户身份 */
@property (nonatomic, copy)NSString *userPosition;

/** 学校的名字 */
@property (nonatomic, strong)NSMutableArray *arraySchool;
/** 班级的名字 */
@property (nonatomic, strong)NSMutableArray *arrayClass;

@property (nonatomic, strong) NSMutableArray *classAllArray;

@property (nonatomic, strong) NSMutableArray *classGroupArray;

/** 底部的试图 */
@property (nonatomic, strong)XXEHomePageBottomView *bottomView;

/** 判断身份 */
@property (nonatomic, copy)NSString *identifyCard;

@property(nonatomic , assign) int unreadMessageCount;

@end

@implementation XXEHomePageViewController

- (NSMutableArray *)schoolModelDatasource
{
    if (!_schoolModelDatasource) {
        _schoolModelDatasource = [NSMutableArray array];
    }
    return _schoolModelDatasource;
}

- (NSMutableArray *)classAllArray{
    if (!_classAllArray) {
        _classAllArray = [NSMutableArray array];
    }
    return _classAllArray;
}

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteNotification:) name:kRemoteNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemMessage:) name:kSystemMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
    
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = YES;
    //新手 教程
    [self initNewCourseView];
    
    //获取数据
    [self setupHomePageRequeue];

}

- (void)remoteNotification:(NSNotification *)notification {
//    NSString *type = notification.userInfo[@"type"];
//    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"] ||[type isEqualToString:@"4"] ) {
//    }else if ([type isEqualToString:@"3"]) {
//        
//    }
    [self pushToXXENotificationViewController];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRemoteNotification object:nil];
}

- (void)systemMessage:(NSNotification *)notification {
    self.middleView.systemNotificationBadgeView.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSystemMessage object:nil];
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    if (self.bottomView.chatBadgeView.hidden == YES) {
        self.bottomView.chatBadgeView.hidden = NO;
    }
    
}

/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//MARK: - 新手教程
-(void)initNewCourseView{
    
    NSUserDefaults *first = [NSUserDefaults standardUserDefaults];
    NSString *isFirst = [first objectForKey:@"isFirst"];
    
    if (!isFirst) {
        UIWindow *window = [[UIApplication sharedApplication] windows][1];
        XXENewCourseView *newCourseView = [[XXENewCourseView alloc] init];
        [window addSubview:newCourseView];
    }
    
    isFirst = @"NO";
    [first setObject:isFirst  forKey:@"isFirst"];
    [first synchronize];
}

#pragma mark - 下拉选择框
- (void)setUpDropDownSelection
{
    XXEHomePageSchoolModel *model3 = [self.schoolDatasource firstObject];
    XXEHomePageClassModel *model1 = [model3.class_info firstObject];
    //    NSLog(@"model1:%@ --- model3:%@", model1, model3);
    
    self.schoolHomeId = model3.school_id;
    self.schoolType = model3.school_type;
    self.classHomeId = model1.class_id;
    self.userPosition = model1.position;
//    NSLog(@"学校类型:%@",self.schoolType);
    
//    //*******************  学 校  *************************
//    NSLog(@"self.arraySchool ==== %@", self.arraySchool);
    
    if (self.arraySchool.count != 0) {
        self.homeSchoolView.dataArray = self.arraySchool;
        [self.homeSchoolView.listTableView reloadData];
    }

    self.homeSchoolView.textField.text = model3.school_name;

//    //***********************  班 级  ***************************
    NSString *string = @"编辑班级";
//
    if (self.classAllArray.count != 0) {
        for (int i =0; i<self.classAllArray.count; i++) {
            [self.classAllArray[i] addObject:string];
        }
        self.homeClassView.dataArray = self.classAllArray[0];
        [self.homeClassView.listTableView reloadData];
    }

    self.homeClassView.textField.text = model1.class_name;
    self.userPosition = model1.position;

    //获取下部试图
    [self bottomViewShowPosition:self.userPosition];
    
    //显示 学校 logo 头像
    [_headView changeSchoolLogo:model3.school_logo];
}

- (void)bottomViewShowPosition:(NSString *)position
{
    [self.bottomView removeFromSuperview];
    self.bottomView = [[XXEHomePageBottomView alloc]initWithFrame:CGRectMake(0, self.middleView.frame.origin.y+43*kScreenRatioHeight+1, KScreenWidth, 296*kScreenRatioHeight)];
    [self.bottomView configBottomViewButton:self.userPosition];
    self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
}

- (void)commboxAction2:(NSNotification *)notif{
    
    self.identifyCard =self.homeClassView.textField.text;
    
    if ([self.homeClassView.textField.text isEqualToString:@"编辑班级"]) {
        NSLog(@"调转页面");
        XXEAddIdentityViewController *addIdenVC = [[XXEAddIdentityViewController alloc]init];
        [self.navigationController pushViewController:addIdenVC animated:YES];
    }else{
        [self homePageBottomViewText:self.homeClassView.textField.text];
    }
}

#pragma mark - 获取身份 -----------------------
- (void)homePageBottomViewText:(NSString *)text
{
    if ([text isEqualToString:@"校长"]){
        //获取下部试图
        self.userPosition = @"4";
        [self bottomViewShowPosition:self.userPosition];
    }else if ([text isEqualToString:@"管理员"])
    {
        //获取下部试图
        self.userPosition = @"3";
        [self bottomViewShowPosition:self.userPosition];
    }else if ([text containsString:@"主任"]){
        self.userPosition = @"2";
        [self bottomViewShowPosition:self.userPosition];
    }else{
        self.userPosition = @"1";
        [self bottomViewShowPosition:self.userPosition];
    }
    
//    NSLog(@"----- *** ----- %@", self.userPosition);
    
    
    [DEFAULTS setObject:self.userPosition forKey:@"POSITION"];
    [DEFAULTS synchronize];
}

#pragma mark - 通知选择的学校

- (void)commboxAction:(NSNotification *)notif{
//    NSLog(@"%@",notif.object);
//    NSLog(@"文字是什么%@",self.homeClassView.textField.text);
    switch ([notif.object integerValue]) {
        case 102:
        {
//            NSLog(@"%@",notif.object);
//            NSLog(@"文字是什么%@",self.homeClassView.textField.text);
            [self.homeSchoolView removeFromSuperview];
            
            [self.view addSubview:self.schoolBgView];
            [self.view addSubview:self.homeSchoolView];
            
        }
            break;
        case 103:
        {
            [self.homeClassView removeFromSuperview];
            [self.view addSubview:self.classBgView];
            [self.view addSubview:self.homeClassView];
//            NSLog(@"老师的身份是什么%@",self.userPosition);
        }
            break;
        default:
            break;
    }
}

- (void)commboxHidden1{
    
    [self.schoolBgView removeFromSuperview];
    [self.homeSchoolView setShowList:NO];
    self.homeSchoolView.listTableView.hidden = YES;
    
}
- (void)commboxHidden2{
    
    [self.classBgView removeFromSuperview];
    [self.homeClassView setShowList:NO];
    self.homeClassView.listTableView.hidden = YES;
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSString *str = [NSString stringWithFormat:@"%@",context];
//    NSLog(@"str:%@",str);
    
    if ([str integerValue] == 1) {
        if ([object isKindOfClass:[UITextField class]]){
            //如果 改变 左边 学校 ——》自动关联到 右边的年级班级信息
            //取出name的旧值和新值
            NSString * newNameOne=[change objectForKey:@"new"];
             NSLog(@"object:%@,new:%@",object,newNameOne);
            
            NSLog(@"%@ --- %@ ", _arraySchool, _classAllArray);
            
            if (_arraySchool.count != 0 && _classAllArray.count != 0) {
                didSelectedSchoolRow =[_arraySchool indexOfObject:newNameOne];
                self.homeClassView.dataArray = _classAllArray[didSelectedSchoolRow];
//                NSLog(@"%@", _classAllArray[didSelectedSchoolRow]);
                
//                if ([_classAllArray[didSelectedSchoolRow] count] != 0) {
                    self.homeClassView.textField.text = _classAllArray[didSelectedSchoolRow][0];
//                }
                
                [_homeClassView.listTableView reloadData];
                
                for (XXEHomePageSchoolModel *model in self.schoolDatasource) {
                    
                    if ([model.school_name isEqualToString:newNameOne]) {
                        self.schoolHomeId = model.school_id;
                        self.schoolType = model.school_type;
                        
                        [_headView changeSchoolLogo:model.school_logo];
                        XXEHomePageClassModel *classModel = [model.class_info firstObject];
                        self.classHomeId = classModel.class_id;
                        self.userPosition = classModel.position;
//                        NSLog(@"身份%@ === %@",self.userPosition, self.schoolType);
                        [DEFAULTS setObject:self.schoolType forKey:@"SCHOOL_TYPE"];
                        [DEFAULTS synchronize];
                        //获取下部试图
                        [self bottomViewShowPosition:self.userPosition];
                        
                    }
                }
            }
            
        }
        
        
        return;
    }else if ([str integerValue] == 2){
        if ([object isKindOfClass:[UITextField class]]){
            //如果 改变 右边的年级班级信息  ——》自动关联到 左边 学校
            //取出name的旧值和新值
            // NSString * newNameTwo=[change objectForKey:@"new"];
//            NSLog(@"hahahaha %@", self.userPosition);
            
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"首页控制器");
    self.identifyCard = @"";
    babySchoolName = @"";
    babyClassName = @"";
//    //获取数据
//    [self setupHomePageRequeue];
    
    _classGroupArray = [[NSMutableArray alloc] init];
    
    didSelectedSchoolRow = 0;
    
    self.headView = [[XXEHomePageHeaderView alloc]init];
    self.headView.frame = CGRectMake(0, 0, KScreenWidth, 276*kScreenRatioHeight);
    self.headView.delegate = self;
    self.middleView = [[XXEHomePageMiddleView alloc]initWithFrame:CGRectMake(0, 276*kScreenRatioHeight, KScreenWidth, 43*kScreenRatioHeight)];
    self.middleView.delegate = self;
    
    [self.view addSubview:self.middleView];
    [self.view addSubview:self.headView];
   
    [self setRongCloud];
    
    //创建 下拉框
    [self createCommboxView];
    
    
//    self.tabBarItem.badgeValue = @"10";
}


#pragma mark ========= 创建 下拉框 =============
- (void)createCommboxView{

    //*******************  学 校  *************************
    self.homeSchoolView = [[WJCommboxView alloc] initWithFrame:CGRectMake(65 * kScreenRatioWidth, 41 * kScreenRatioHeight, 120 * kScreenRatioWidth, 36 * kScreenRatioHeight)];
    
    [self.view addSubview:self.homeSchoolView];
    
    self.homeSchoolView.textField.placeholder = @"学校";
    self.homeSchoolView.textField.textAlignment = NSTextAlignmentCenter;
    self.homeSchoolView.textField.tag = 102;
    self.homeSchoolView.textField.layer.cornerRadius =10 * KScreenWidth / 375;
    self.homeSchoolView.textField.layer.masksToBounds =YES;
    //    //监听 学校 名称 改变
    [self.homeSchoolView.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"1"];
    
    self.schoolBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight+300)];
    self.schoolBgView.backgroundColor = [UIColor clearColor];
    self.schoolBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden1)];
    [self.schoolBgView addGestureRecognizer:singleTap1];
    
    
    //***********************  班 级  ***************************
    self.homeClassView = [[WJCommboxView alloc] initWithFrame:CGRectMake(65 * kScreenRatioWidth+120 * kScreenRatioWidth+5, 41*kScreenRatioHeight, 120 * kScreenRatioWidth, 36 * kScreenRatioHeight)];
    
    [self.view addSubview:self.homeClassView];
    
    self.homeClassView.textField.placeholder = @"班级";
    self.homeClassView.textField.textAlignment = NSTextAlignmentCenter;
    self.homeClassView.textField.tag = 103;
    self.homeClassView.textField.layer.cornerRadius =10 * KScreenWidth / 375;
    self.homeClassView.textField.layer.masksToBounds =YES;
    //监听 班级 改变
    [self.homeClassView.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:@"2"];
    
    self.classBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight+300)];
    self.classBgView.backgroundColor = [UIColor clearColor];
    self.classBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden2)];
    [self.classBgView addGestureRecognizer:singleTap2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction2:) name:@"commboxNotice2"object:nil];
}



#pragma mark - 点击代理方法 Delegate
//顶部视图
- (void)homePageLeftButtonClick
{
    NSLog(@"---跳转到学校的详情页----");
    //logo
    XXEHomeLogoRootViewController *homeLogoRootVC = [[XXEHomeLogoRootViewController alloc] init];
    
    homeLogoRootVC.schoolId = _schoolHomeId;
    homeLogoRootVC.classId = _classHomeId;
    homeLogoRootVC.position = self.userPosition;
    
    [self.navigationController pushViewController:homeLogoRootVC animated:NO];
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
    redFlowerSentHistoryVC.position = self.userPosition;
    //    NSLog(@"%@%@",self.schoolHomeId,self.classHomeId);
    
    [self.navigationController pushViewController:redFlowerSentHistoryVC animated:YES];
}

- (void)homeMiddleFourButtonClick{
    [self pushToXXENotificationViewController];
}

- (void)pushToXXENotificationViewController {
    NSLog(@"-----  通知 ---- ");
    XXENotificationViewController *notificationVC = [[XXENotificationViewController alloc] init];
    notificationVC.schoolId = self.schoolHomeId;
    notificationVC.classId = self.classHomeId;
    self.middleView.systemNotificationBadgeView.hidden = YES;
    [self.navigationController pushViewController:notificationVC animated:YES];
}

#pragma mark - 获取数据
- (void)setupHomePageRequeue
{
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
//    NSLog(@"%@%@",strngXid,homeUserId);
    
    //远程推送跳转
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSLog(@"%@%@",strngXid,homeUserId);
    XXEHomePageApi *homePageApi = [[XXEHomePageApi alloc]initWithHomePageXid:strngXid UserType:@"2" UserId:homeUserId];
    [homePageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString * code = [request.responseJSONObject objectForKey:@"code"];
        
        if ([code intValue] == 1) {
            [self showHudWithString:@"正在请求数据..."];
            
//            NSLog(@"%@",request.responseJSONObject  );
            NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
            
            XXEHomePageModel *homePageModel = [[XXEHomePageModel alloc]initWithDictionary:data error:nil];
//            NSLog(@"首页 -- %@",homePageModel);
            [self.headView configCellWithInfo:homePageModel];
            [self.middleView configCellMiddleWithInfo:homePageModel];
            [self.arraySchool removeAllObjects];
            [self.schoolDatasource removeAllObjects];
            [self.classDatasource removeAllObjects];
            [self.arrayClass removeAllObjects];
            [self.classAllArray removeAllObjects];
            
            NSArray *schoolArray = [data objectForKey:@"school_info"];
//            NSLog(@"%@",schoolArray);
            for (int g = 0; g<schoolArray.count; g++) {
                _arrayClass = [[NSMutableArray alloc] init];
                
                XXEHomePageSchoolModel *schoolModel = [[XXEHomePageSchoolModel alloc]initWithDictionary:schoolArray[g] error:nil];
                [self.arraySchool addObject:schoolModel.school_name];
                [self.schoolDatasource addObject:schoolModel];
                NSArray *classArray = [schoolArray[g] objectForKey:@"class_info"];
                
                for (int k =0; k<classArray.count; k++) {
                    XXEHomePageClassModel *classModel = [[XXEHomePageClassModel alloc]initWithDictionary:classArray[k] error:nil];
                    
                    [self.arrayClass addObject:classModel.class_name];
                    [self.classDatasource addObject:classModel];
                }
                
                [self.classAllArray addObject:self.arrayClass];
                
                [self.schoolModelDatasource addObject:self.classDatasource];
                [self homePageBottomViewText:self.arrayClass[0]];
                NSLog(@"班级的数组%@",self.classDatasource);
                
                
            }
        } else {
            [self showHudWithString:@"数据请求失败" forSecond:1.f];
        }
                //创建下拉选择框
        [self setUpDropDownSelection];
        [self hideHud];
        
        
        if (appdelegate.userInfo) {
            [self pushToXXENotificationViewController];
        }
        appdelegate.userInfo = nil;
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showHudWithString:@"数据请求失败" forSecond:1.f];
    }];
}


#pragma mark - 点击事件
- (void)homeMiddleThreeButtonClick
{
    NSLog(@"----猩币点击事件---");
    XXEXingCoinViewController *xingCoinVC = [[XXEXingCoinViewController alloc] init];
    [self.navigationController pushViewController:xingCoinVC animated:YES];
}

//下部视图点击相应的方法
- (void)homeClassOneButtonClick:(NSInteger)tag
{
    if ([self.userPosition isEqualToString:@"1"] || [self.userPosition isEqualToString:@"2"]) {
        //教师/班主任
        [self xxe_homePageTeacherIdentifierNum:tag];
    }else if ([self.userPosition isEqualToString:@"3"]){
        //管理员
        [self xxe_homePageAdminIdentifierNum:tag];
    }else{
        //校长
        [self xxe_homePageHeaderIdentifierNum:tag];
    }
    
}

#pragma mark - 身份不同点击的区域就不一样
#pragma mark ---------- position 1 或 2---------------

- (void)xxe_homePageTeacherIdentifierNum:(NSInteger )numTag
{
    switch (numTag) {
        case 0:
        { NSLog(@"----实时监控----");
            VideoMonitorViewController *videoVC = [[VideoMonitorViewController alloc]init];
            [self.navigationController pushViewController:videoVC animated:YES];
            break;
        }
        case 1:
        {
//            NSLog(@"---相册----");
//            NSLog(@"%@",self.userPosition);

                XXEClassAlbumViewController *classAlbumVC = [[XXEClassAlbumViewController alloc]init];
                classAlbumVC.schoolID = self.schoolHomeId;
                classAlbumVC.classID = self.classHomeId;
                NSLog(@"%@ == %@",self.schoolHomeId,self.classHomeId);
                [self.navigationController pushViewController:classAlbumVC animated:YES];
            break;
        }
        case 2:
        {
            NSLog(@"----课程表----");
            
            XXESchoolTimetableViewController *schoolTimetableVC = [[XXESchoolTimetableViewController alloc] init];
            
            [self.navigationController pushViewController:schoolTimetableVC animated:YES];
            
            break;
        }
        case 3:
        {
            //通讯录
            if ([self.userPosition isEqualToString:@"1"] || [self.userPosition isEqualToString:@"2"]) {
            
                XXEClassAddressEveryclassInfoViewController *classAddressEveryclassInfoVC = [[XXEClassAddressEveryclassInfoViewController alloc] init];
                classAddressEveryclassInfoVC.schoolId = _schoolHomeId;
                classAddressEveryclassInfoVC.selectedClassId = _classHomeId;
                classAddressEveryclassInfoVC.babyClassName = _homeSchoolView.textField.text;
                [self.navigationController pushViewController:classAddressEveryclassInfoVC animated:YES];
            }else if([self.userPosition isEqualToString:@"3"] || [self.userPosition isEqualToString:@"4"]){
                XXEClassAddressHeadermasterAndManagerViewController *classAddressHeadermasterAndManagerVC = [[XXEClassAddressHeadermasterAndManagerViewController alloc] init];
                classAddressHeadermasterAndManagerVC.schoolId = _schoolHomeId;
                classAddressHeadermasterAndManagerVC.schoolType = _schoolType;
                
                [self.navigationController pushViewController:classAddressHeadermasterAndManagerVC animated:YES];
            }
            
            break;
        }
        case 4:
        {
            NSLog(@"----聊天----");
            if ([XXEUserInfo user].login) {
                
            XXRootChatETabBarController *rootChatVC = [[XXRootChatETabBarController alloc]init];
            rootChatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rootChatVC animated:NO];
        }else{
            
            [self showHudWithString:@"请用账号登录" forSecond:1.5];
        }
            break;
        }
        case 8:
        {
            NSLog(@"---点评----");
            XXECommentRootViewController *commentRootVC = [[XXECommentRootViewController alloc] init];
            
            commentRootVC.classId = self.classHomeId;
            commentRootVC.schoolId = self.schoolHomeId;
            
            [self.navigationController pushViewController:commentRootVC animated:NO];
            break;
        }
        case 6:
        {
            NSLog(@"----作业----");
            XXEHomeworkViewController *homeworkVC = [[XXEHomeworkViewController alloc] init];
            homeworkVC.schoolId = self.schoolHomeId;
            homeworkVC.classId = self.classHomeId;
            
            [self.navigationController pushViewController:homeworkVC animated:YES];
            
            break;
        }
        case 5:
        {
            NSLog(@"---食谱----");
            XXERecipeViewController *recipeViewController = [[XXERecipeViewController alloc] init];
            recipeViewController.schoolId = self.schoolHomeId;
            
            recipeViewController.position = self.userPosition;
            
            [self.navigationController pushViewController:recipeViewController animated:YES];
            
            break;
        }
        case 11:
        {
            NSLog(@"----签到----");
        
            XXESignInViewController *signInVC = [[XXESignInViewController alloc] init];
            signInVC.schoolId = self.schoolHomeId;
            signInVC.classId = self.classHomeId;
            signInVC.schoolType = self.schoolType;
            signInVC.position = self.userPosition;
            
            [self.navigationController pushViewController:signInVC animated:YES];
            break;
        }
            
        case 10:
        {
            NSLog(@"---管理----");
            
            if ([self.userPosition isEqualToString:@"1"] || [self.userPosition isEqualToString:@"2"]) {
//             教师
               XXEManagerTeacherViewController *managerTeacherVC = [[XXEManagerTeacherViewController alloc] init];
                managerTeacherVC.schoolId = self.schoolHomeId;
                managerTeacherVC.classId = self.classHomeId;
                managerTeacherVC.schoolType = self.schoolType;
                managerTeacherVC.position = self.userPosition;
                
                [self.navigationController pushViewController:managerTeacherVC animated:YES];
            }
            
            break;
        }
            
        case 9:
        {
            NSLog(@"----星天地----");
            XXEXingCommunityViewController *xingCommunityVC = [[XXEXingCommunityViewController alloc] init];
            
            [self.navigationController pushViewController:xingCommunityVC animated:YES];
            break;
            
        }
    
        case 7:
        {
            NSLog(@"---猩猩商城----");
            XXEStoreRootViewController *storeRootVC = [[XXEStoreRootViewController alloc] init];
            
            [self.navigationController pushViewController:storeRootVC animated:YES];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark ---------- position 3---------------
- (void)xxe_homePageAdminIdentifierNum:(NSInteger )numTag
{
    switch (numTag) {
        case 0:
        { NSLog(@"----实时监控----");
            VideoMonitorViewController *videoVC = [[VideoMonitorViewController alloc]init];
            [self.navigationController pushViewController:videoVC animated:YES];
            break;
        }
        case 1:
        {
            NSLog(@"---相册----");
             NSLog(@"%@",self.userPosition);

            XXEClassAlbumViewController *classAlbumVC = [[XXEClassAlbumViewController alloc]init];
            classAlbumVC.schoolID = self.schoolHomeId;
            classAlbumVC.classID = self.classHomeId;
            NSLog(@"%@ == %@",self.schoolHomeId,self.classHomeId);
            [self.navigationController pushViewController:classAlbumVC animated:YES];
            break;
        }
        case 2:
        {
            NSLog(@"----课程表----");
            
            XXESchoolTimetableViewController *schoolTimetableVC = [[XXESchoolTimetableViewController alloc] init];
            
            [self.navigationController pushViewController:schoolTimetableVC animated:YES];
            
            break;
        }
        case 3:
        {
            //通讯录
//            if([self.userPosition isEqualToString:@"3"] || [self.userPosition isEqualToString:@"4"]){
                XXEClassAddressHeadermasterAndManagerViewController *classAddressHeadermasterAndManagerVC = [[XXEClassAddressHeadermasterAndManagerViewController alloc] init];
                classAddressHeadermasterAndManagerVC.schoolId = _schoolHomeId;
                classAddressHeadermasterAndManagerVC.schoolType = _schoolType;
                
                [self.navigationController pushViewController:classAddressHeadermasterAndManagerVC animated:YES];
//            }
            
            break;
        }
        case 4:
        {
            NSLog(@"----聊天----");
            
            if ([XXEUserInfo user].login) {
                
            XXRootChatETabBarController *rootChatVC = [[XXRootChatETabBarController alloc]init];
            rootChatVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:rootChatVC animated:NO];
        }else{
            
            [self showHudWithString:@"请用账号登录" forSecond:1.5];
        }
            
            break;
        }
        case 8:
        {
            NSLog(@"---点评----");
            XXECommentRootViewController *commentRootVC = [[XXECommentRootViewController alloc] init];
            
            commentRootVC.classId = self.classHomeId;
            commentRootVC.schoolId = self.schoolHomeId;
            
            [self.navigationController pushViewController:commentRootVC animated:NO];
            break;
        }
        case 5:
        {
            NSLog(@"---食谱----");
            XXERecipeViewController *recipeViewController = [[XXERecipeViewController alloc] init];
            recipeViewController.schoolId = self.schoolHomeId;
            recipeViewController.position = self.userPosition;
            [self.navigationController pushViewController:recipeViewController animated:YES];
            
            break;
        }
        case 6:
        {
            NSLog(@"----签到----");
            XXESignInViewController *signInVC = [[XXESignInViewController alloc] init];
            signInVC.schoolId = self.schoolHomeId;
            signInVC.classId = self.classHomeId;
            signInVC.schoolType = self.schoolType;
            signInVC.position = self.userPosition;
            [self.navigationController pushViewController:signInVC animated:YES];
            break;
        }
            
        case 10:
        {
            NSLog(@"---管理----");
            if ([self.userPosition isEqualToString:@"3"]) {
                //school_type //学校类型: 幼儿园/小学/中学/机构 1/2/3/4
                //如果 是 4 表示 私立, 其他为公立学校
                
                if ([_schoolType isEqualToString:@"4"]) {
                    //管理员(私立)
                    XXEManagerManagerPrivateViewController *managerPrivateVC = [[XXEManagerManagerPrivateViewController alloc] init];
                    managerPrivateVC.schoolId = self.schoolHomeId;
                    managerPrivateVC.classId = self.classHomeId;
                    managerPrivateVC.schoolType = self.schoolType;
                    managerPrivateVC.position = self.userPosition;
                    
                    [self.navigationController pushViewController:managerPrivateVC animated:YES];
                }else{
                    //管理员(公立)
                    XXEManagerManagerPublicViewController *managerPublicVC = [[XXEManagerManagerPublicViewController alloc] init];
                    managerPublicVC.schoolId = self.schoolHomeId;
                    managerPublicVC.classId = self.classHomeId;
                    managerPublicVC.schoolType = self.schoolType;
                    managerPublicVC.position = self.userPosition;
                    
                    [self.navigationController pushViewController:managerPublicVC animated:YES];
                }
 
            }
           break;
        }
            
        case 9:
        {
            NSLog(@"----星天地----");
            XXEXingCommunityViewController *xingCommunityVC = [[XXEXingCommunityViewController alloc] init];
            
            [self.navigationController pushViewController:xingCommunityVC animated:YES];
            break;
            
        }
        case 7:
        {
            NSLog(@"---猩猩商城----");
            XXEStoreRootViewController *storeRootVC = [[XXEStoreRootViewController alloc] init];
            
            [self.navigationController pushViewController:storeRootVC animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark ---------- position 4---------------
- (void)xxe_homePageHeaderIdentifierNum:(NSInteger )numTag
{
    switch (numTag) {
        case 0:
        { NSLog(@"----实时监控----");
            VideoMonitorViewController *videoVC = [[VideoMonitorViewController alloc]init];
            [self.navigationController pushViewController:videoVC animated:YES];
            break;
        }
        case 1:
        {
             NSLog(@"%@",self.userPosition);
            NSLog(@"---相册----");
            XXEClassAlbumViewController *classAlbumVC = [[XXEClassAlbumViewController alloc]init];
            classAlbumVC.schoolID = self.schoolHomeId;
            classAlbumVC.classID = self.classHomeId;
            NSLog(@"%@ == %@",self.schoolHomeId,self.classHomeId);
            [self.navigationController pushViewController:classAlbumVC animated:YES];
            break;
        }
        case 2:
            {
                NSLog(@"----课程表----");
                
                XXESchoolTimetableViewController *schoolTimetableVC = [[XXESchoolTimetableViewController alloc] init];
                
                [self.navigationController pushViewController:schoolTimetableVC animated:YES];
                
                break;
            }        case 3:
        {
            //通讯录
//           if([self.userPosition isEqualToString:@"3"] || [self.userPosition isEqualToString:@"4"]){
                XXEClassAddressHeadermasterAndManagerViewController *classAddressHeadermasterAndManagerVC = [[XXEClassAddressHeadermasterAndManagerViewController alloc] init];
                classAddressHeadermasterAndManagerVC.schoolId = _schoolHomeId;
                classAddressHeadermasterAndManagerVC.schoolType = _schoolType;
                
                [self.navigationController pushViewController:classAddressHeadermasterAndManagerVC animated:YES];
//            }
            
            break;
        }
        case 4:
        {
            NSLog(@"----聊天----");
            if ([XXEUserInfo user].login) {
                
            XXRootChatETabBarController *rootChatVC = [[XXRootChatETabBarController alloc]init];
            rootChatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rootChatVC animated:NO];
        }else{
            
            [self showHudWithString:@"请用账号登录" forSecond:1.5];
        }
            break;
        }
        case 5:
        {
            NSLog(@"---食谱----");
            XXERecipeViewController *recipeViewController = [[XXERecipeViewController alloc] init];
            recipeViewController.schoolId = self.schoolHomeId;
            recipeViewController.position = self.userPosition;
            [self.navigationController pushViewController:recipeViewController animated:YES];
            
            break;
        }
        case 6:
        {
            NSLog(@"----签到----");
            XXESignInViewController *signInVC = [[XXESignInViewController alloc] init];
            signInVC.schoolId = self.schoolHomeId;
            signInVC.classId = self.classHomeId;
            signInVC.schoolType = self.schoolType;
            signInVC.position = self.userPosition;
            [self.navigationController pushViewController:signInVC animated:YES];
            break;
        }
        case 7:
        {
            NSLog(@"---猩猩商城----");
            XXEStoreRootViewController *storeRootVC = [[XXEStoreRootViewController alloc] init];
            
            [self.navigationController pushViewController:storeRootVC animated:YES];
            break;
        }
            
        case 8:
        {
            NSLog(@"---管理----");
            //不同 身份
            
            if ([self.userPosition isEqualToString:@"4"]) {
            //school_type //学校类型: 幼儿园/小学/中学/机构 1/2/3/4
            //如果 是 4 表示 私立, 其他为公立学校
            if ([_schoolType isEqualToString:@"4"]) {
                //校长(私立)
                XXEManagerHeadmasterPrivateViewController *managerHeadmasterPrivateVC = [[XXEManagerHeadmasterPrivateViewController alloc] init];
                
                managerHeadmasterPrivateVC.schoolId = self.schoolHomeId;
                managerHeadmasterPrivateVC.classId = self.classHomeId;
                managerHeadmasterPrivateVC.schoolType = self.schoolType;
                managerHeadmasterPrivateVC.position = self.userPosition;
                
                [self.navigationController pushViewController:managerHeadmasterPrivateVC animated:YES];
            }else{
                // 校长(公立)
                XXEManagerHeadmasterPublicViewController *managerHeadmasterPublicVC = [[XXEManagerHeadmasterPublicViewController alloc] init];
                
                managerHeadmasterPublicVC.schoolId = self.schoolHomeId;
                managerHeadmasterPublicVC.classId = self.classHomeId;
                managerHeadmasterPublicVC.schoolType = self.schoolType;
                managerHeadmasterPublicVC.position = self.userPosition;
                
                [self.navigationController pushViewController:managerHeadmasterPublicVC animated:YES];
            }
           }
            break;
        }
            
        case 9:
        {
            NSLog(@"----星天地----");
            XXEXingCommunityViewController *xingCommunityVC = [[XXEXingCommunityViewController alloc] init];
            
            [self.navigationController pushViewController:xingCommunityVC animated:YES];
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


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.homeSchoolView.textField removeObserver:self forKeyPath:@"text"];
    [self.homeClassView.textField removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RCKitDispatchMessageNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    babySchoolName = _homeSchoolView.textField.text;
    babyClassName = _homeClassView.textField.text;
    
    [DEFAULTS setObject:babySchoolName forKey:@"SCHOOL_NAME"];
    [DEFAULTS setObject:babyClassName forKey:@"CLASS_NAME"];
    
    [DEFAULTS setObject:self.schoolHomeId forKey:@"SCHOOL_ID"];
    
    [DEFAULTS setObject:self.classHomeId forKey:@"CLASS_ID"];
    
    //身份
//    [DEFAULTS setObject:self.userPosition forKey:@"POSITION"];
    
//    [DEFAULTS setObject:self.schoolType forKey:@"SCHOOL_TYPE"];
    
    [DEFAULTS synchronize];
    
    
//   NSLog(@"viewWillDisappear:  %@ == %@", self.userPosition, self.schoolType);
}

#pragma mark - 融云
- (void)setRongCloud
{
    [[RCIM sharedRCIM] initWithAppKey:MyRongCloudAppKey];
    
    NSString *token = [XXEUserInfo user].token;
    NSString *userId = [XXEUserInfo user].xid;
    NSString *userNickName = [XXEUserInfo user].nickname;
    NSString *userImage = [XXEUserInfo user].user_head_img;
    
    RCUserInfo *currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId      name:userNickName portrait:userImage];
    
    [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
    [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
        
//        NSLog(@"%@ --- %@ --- %@ --- %@ ", token, userId, userNickName, userImage);
        
    [[XXERCDataManager shareManager] loginRongCloudWithUserInfo:[[RCUserInfo alloc] initWithUserId:userId name:userNickName portrait:userImage QQ:nil sex:nil age:nil]  withToken:token];
        NSLog(@"登陆成功当前用户ID为%@",userId);
        
    } error:^(RCConnectErrorCode status) {
       NSLog(@"登录错误%ld",(long)status);
    } tokenIncorrect:^{
       NSLog(@"token错误"); 
    }];
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
