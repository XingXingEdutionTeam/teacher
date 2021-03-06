//
//  XXECharPageViewController.m
//  teacher
//
//  Created by codeDing on 16/8/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEChatPageViewController.h"
#import "XXECourseManagerCourseCategoryApi.h"
#import "XXEXingClassRoomTeacherListApi.h"
#import "XXEXingClassRoomCourseListApi.h"
#import "XXEXingClassRoomSchoolListApi.h"
#import "XXEXingClassRoomTeacherListTableViewCell.h"
#import "XXEXingClassRoomSchoolListTableViewCell.h"
#import "XXEXingClassRoomCourseListTableViewCell.h"
#import "XXEXingClassRoomTeacherListModel.h"
#import "XXEXingClassRoomCourseListModel.h"
#import "XXEXingClassRoomSchoolListModel.h"
#import "XXECourseManagerClassModel1.h"
#import "XXECourseManagerClassModel2.h"
#import "XXECourseManagerClassModel3.h"
#import "XXEXingClassRoomSearchViewController.h"
#import "XXEXingClassRoomTeacherDetailInfoViewController.h"
#import "XXEXingClassRoomCourseDetailInfoViewController.h"
#import "XXEHomeLogoRootViewController.h"
#import "WJDropdownMenu.h"
#import "MBProgressHUD.h"



@interface XXEChatPageViewController ()<UITableViewDelegate,UITableViewDataSource, WJMenuDelegate>
{
    //三级类目
    WJDropdownMenu *menu;
    //tableView
    UITableView *myTableView;
    //占位图
    UIImageView *placeholderImageView;
    
    //三级类目 数据
    NSMutableArray *classGroupArray1;
    NSMutableArray *classGroupArray2;
    NSMutableArray *classGroupArray3;
    NSMutableDictionary *classGroupDic2;
    NSMutableDictionary *classGroupDic3;
    
    NSString *className1;
    NSString *className2;
    NSString *className3;
    
    NSString *classID1;
    NSString *classID2;
    NSString *classID3;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;

    //三级类目 的 标题
    NSMutableArray *menuTitleArray;
    //第一级 类目 数组
    NSMutableArray *firstMenuArray;
    NSMutableArray *firstArr1;
    NSMutableArray *firstArr2;
    NSMutableArray *firstArr3;
    
    //第二级 类目 数组
    NSMutableArray *secondMenuArray1;
    NSMutableArray *secondMenuArray2;
    NSMutableArray *secondMenuArray3;
    //第三级 类目 数组
    NSMutableArray *thirdMenuArray;
    
    
    //老师 列表 老师model 数组
    NSMutableArray *teacherModelArray;
    //课程 列表 课程model 数组
    NSMutableArray *courseModelArray;
    //机构 列表 机构model 数组
    NSMutableArray *schoolModelArray;
    
    //传参
    NSInteger _teacherPage;
    NSInteger _coursePage;
    NSInteger _schoolPage;
    NSString *_longitudeString;//经度
    NSString *_latitudeString; //纬度
    
    NSString *_class_str; //类目,3级,逗号隔开,值是中文
    NSInteger _appoint_order;//指定排序,0:离我最近,1:评价最高,2:当前活跃,3:人气最高
    NSString *_filter_distance;	//距离筛选,单位km
    NSString *_search_words;	//关键字搜索(点击热门搜索,也用参数)
}


@property (nonatomic, strong)UISegmentedControl *segentControl;
@property(nonatomic)NSInteger segentNumber;
//@property(nonatomic,strong)EmptyView *noDataEmpty;
@property(nonatomic ,strong)UIWindow *window;

@end

@implementation XXEChatPageViewController

-(UIWindow *)window {
    if (!_window) {
        _window = [UIApplication sharedApplication].windows[1];
    }
    
    return _window;
}

//-(EmptyView *)noDataEmpty {
//    if (!_noDataEmpty) {
//        CGRect frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64 - 44);
//        _noDataEmpty = [EmptyView conveniceWithTitle:@"暂时没数据" frame:frame];
//        [myTableView addSubview:_noDataEmpty];
//        _noDataEmpty.hidden = YES;
//    }
//    
//    return _noDataEmpty;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

//    if (teacherModelArray.count != 0) {
//        [teacherModelArray removeAllObjects];
//    }
//    [self fetchTeacherInfo];
//    [myTableView reloadData];
}

/** 这两个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UISegmentedControl *)segentControl
{
    if (!_segentControl) {
        _segentControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(70.0f, 5.0f, 180.0f, 34.0f)];
        [_segentControl insertSegmentWithTitle:@"老师" atIndex:0 animated:YES];
        [_segentControl insertSegmentWithTitle:@"课程" atIndex:1 animated:YES];
        [_segentControl insertSegmentWithTitle:@"机构" atIndex:2 animated:YES];
        _segentControl.momentary = NO;
        _segentControl.multipleTouchEnabled = NO;
        _segentControl.selectedSegmentIndex = 0;
        _segentControl.tintColor = [UIColor whiteColor];
        [_segentControl addTarget:self action:@selector(segentControlClick:) forControlEvents:UIControlEventValueChanged];
        self.segentNumber = 0;
    }
    return _segentControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.segentControl;
    self.view.backgroundColor = XXEBackgroundColor;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    _longitudeString = @"";
    _latitudeString = @"";
    _class_str = @"";
    _appoint_order = 0;
    _filter_distance = @"";
    _search_words = @"";
    _teacherPage = 1;
    _coursePage = 1;
    _schoolPage = 1;
    
#if TARGET_IPHONE_SIMULATOR//模拟器
    _latitudeString = @"31.28190300";
    _longitudeString = @"121.60582400";
#elif TARGET_OS_IPHONE//真机
    /*
     [DEFAULTS setObject:self.longitudeString forKey:@"Longitude"];
     [DEFAULTS setObject:self.latitudeString forKey:@"LatitudeString"];
     */
    _longitudeString = [DEFAULTS objectForKey:@"Longitude"];
    _latitudeString = [DEFAULTS objectForKey:@"LatitudeString"];
#endif
    firstMenuArray = [[NSMutableArray alloc] init];
    firstArr1 = [[NSMutableArray alloc] init];
    firstArr2 = [[NSMutableArray alloc] init];
    firstArr3 = [[NSMutableArray alloc] init];
    teacherModelArray = [[NSMutableArray alloc] init];
    courseModelArray = [[NSMutableArray alloc] init];
    schoolModelArray = [[NSMutableArray alloc] init];
    
    
    menuTitleArray = [[NSMutableArray alloc] initWithObjects:@"全部科目", @"智能顺序", @"附近", nil];
    //老师 指定排序,0:离我最近,1:评价最高,2:当前活跃,3:人气最高
    secondMenuArray1 = [[NSMutableArray alloc] initWithObjects:@"离我最近", @"评价最高", @"当前活跃", @"人气最高", nil];
    //课程 指定排序,0:离我最近,1:价格最低,2:价格最高,3:最新发布,4:人气最高 ,5:近期开课
    secondMenuArray2 = [[NSMutableArray alloc] initWithObjects: @"离我最近",  @"价格最低", @"价格最高", @"最新发布", @"人气最高",  @"最近开课", nil];
    
    //学校 指定排序,0:离我最近,1:评价最高,2:人气最高,3:老师最多,4:学生最多,5:公里学校
    secondMenuArray3 = [[NSMutableArray alloc] initWithObjects:@"离我最近", @"评价最高", @"人气最高", @"老师最多", @"学生最多",  @"公立学校", nil];
    
    thirdMenuArray = [[NSMutableArray alloc] initWithObjects:@"附近", @"0.5KM", @"1.0KM", @"1.5KM",@"2.0KM", @"2.5KM", @"3.0KM", nil];
    [self createRightButton];
    
    [self createTableView];
    
    [self createMenu];
    
    [self fetchNetData];
    
    if (teacherModelArray.count != 0) {
        [teacherModelArray removeAllObjects];
    }
    [self fetchTeacherInfo];
    
    
}

- (void)createRightButton{
    //导航栏的按钮
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

- (void)createMenu{
    
    //三级类目
    menu = [[WJDropdownMenu alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    menu.delegate = self;
//    menu.backgroundColor = [UIColor redColor];
    //  设置代理
    [self.view addSubview:menu];
    
    menu.menuTitleFont = 14;                   //  设置menuTitle字体大小    不设置默认是  11
    menu.tableTitleFont = 12;                  //  设置tableTitle字体大小   不设置默认是  10
    menu.cellHeight = 38;                      //  设置tableViewcell高度   不设置默认是  40
    menu.menuArrowStyle = menuArrowStyleSolid; //  旋转箭头的样式(空心箭头 or 实心箭头)
    menu.tableViewMaxHeight = 200;             //  tableView的最大高度(超过此高度就可以滑动显示)
    
    menu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
    menu.selectedColor = UIColorFromRGB(0, 172, 54);  //  选中的字体颜色
    menu.unSelectedColor = [UIColor grayColor];//  未选中的字体颜色
    
}

- (void)createTableView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
}

-(void)loadNewData{
    if (self.segentNumber == 0) {
        //老师
        _teacherPage = 1;
        [self fetchTeacherInfo];
        [myTableView.header endRefreshing];
        
    }else if (self.segentNumber == 1) {
        //课程
        _coursePage = 1;
        [self fetchCourseInfo];
        [myTableView.header endRefreshing];
        
    }else if (self.segentNumber == 2) {
        //机构
        _schoolPage = 1;
        [self fetchSchoolInfo];
        [myTableView.header endRefreshing];
        
    }

}

-(void)endRefresh{
    [myTableView.header endRefreshing];
    [myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    if (_segentControl.selectedSegmentIndex == 0) {
        //老师
        _teacherPage ++;
        [self fetchTeacherInfo];
        [myTableView.footer endRefreshing];
        
    }else if (_segentControl.selectedSegmentIndex == 1) {
        //课程
        _coursePage ++;
        [self fetchCourseInfo];
        [myTableView.footer endRefreshing];
        
    }else if (_segentControl.selectedSegmentIndex == 2) {
        //机构
        _schoolPage ++;
        [self fetchSchoolInfo];
        [myTableView.footer endRefreshing];
        
    }
    
}


#pragma mark - UISegmentedControl 代理方法=====================
- (void)segentControlClick:(UISegmentedControl *)segment
{
    [teacherModelArray removeAllObjects];
    [courseModelArray removeAllObjects];
    [schoolModelArray removeAllObjects];
    [myTableView reloadData];
    if (segment.selectedSegmentIndex == 0) {
        self.segentNumber = 0;
        _search_words = @"";
        _class_str = @"";
        _appoint_order = 0;
        _filter_distance = @"";
        _teacherPage = 1;
        if (teacherModelArray.count != 0) {
            [teacherModelArray removeAllObjects];
        }
        
//        NSLog(@"老师");
        if (menu) {
            [menu removeFromSuperview];
            [self createMenu];
            [menu createThreeMenuTitleArray:menuTitleArray FirstArr:firstMenuArray SecondArr:secondMenuArray1 threeArr:thirdMenuArray];
        }
        
        [self fetchTeacherInfo];
        
    }else if (segment.selectedSegmentIndex == 1){
        self.segentNumber = 1;
        _class_str = @"";
        _search_words = @"";
        _appoint_order = 0;
        _filter_distance = @"";
        _coursePage = 1;
        if (courseModelArray.count != 0) {
            [courseModelArray removeAllObjects];
        }

//        NSLog(@"课程");
        if (menu) {
            [menu removeFromSuperview];

            [self createMenu];
            [menu createThreeMenuTitleArray:menuTitleArray FirstArr:firstMenuArray SecondArr:secondMenuArray2 threeArr:thirdMenuArray];
        }else{

        }
        
        [self fetchCourseInfo];
        
    }else if (segment.selectedSegmentIndex == 2){
        self.segentNumber = 2;
        _class_str = @"";
        _appoint_order = 0;
        _filter_distance = @"";
        _search_words = @"";
        _schoolPage = 1;
        if (schoolModelArray.count != 0) {
            [schoolModelArray removeAllObjects];
        }

//        NSLog(@"机构");
        if (menu) {
            [menu removeFromSuperview];

            [self createMenu];
            [menu createThreeMenuTitleArray:menuTitleArray FirstArr:firstMenuArray SecondArr:secondMenuArray3 threeArr:thirdMenuArray];
        }else{

        }
        
        [self fetchSchoolInfo];
    }
}


#pragma mark - UISegmentedControl 代理方法=====================
//- (void)segentControlClick1:(UISegmentedControl *)segment
- (void)getSearchInfo{
    
    if (_segentControl.selectedSegmentIndex == 0) {
//        _search_words = @"";
        _class_str = @"";
        _appoint_order = 0;
        _filter_distance = @"";
        _teacherPage = 1;
        if (teacherModelArray.count != 0) {
            [teacherModelArray removeAllObjects];
        }
        
        //        NSLog(@"老师");
        if (menu) {
            [menu removeFromSuperview];
            [self createMenu];
            [menu createThreeMenuTitleArray:menuTitleArray FirstArr:firstMenuArray SecondArr:secondMenuArray1 threeArr:thirdMenuArray];
        }
        
        [self fetchTeacherInfo];
        
    }else if (_segentControl.selectedSegmentIndex == 1){
        _class_str = @"";
//        _search_words = @"";
        _appoint_order = 0;
        _filter_distance = @"";
        _coursePage = 1;
        if (courseModelArray.count != 0) {
            [courseModelArray removeAllObjects];
        }
        
        //        NSLog(@"课程");
        if (menu) {
            [menu removeFromSuperview];
            
            [self createMenu];
            [menu createThreeMenuTitleArray:menuTitleArray FirstArr:firstMenuArray SecondArr:secondMenuArray2 threeArr:thirdMenuArray];
        }else{
            
        }
        
        [self fetchCourseInfo];
        
    }else if (_segentControl.selectedSegmentIndex == 2){
        _class_str = @"";
        _appoint_order = 0;
        _filter_distance = @"";
//        _search_words = @"";
        _schoolPage = 1;
        if (schoolModelArray.count != 0) {
            [schoolModelArray removeAllObjects];
        }
        
        //        NSLog(@"机构");
        if (menu) {
            [menu removeFromSuperview];
            
            [self createMenu];
            [menu createThreeMenuTitleArray:menuTitleArray FirstArr:firstMenuArray SecondArr:secondMenuArray3 threeArr:thirdMenuArray];
        }else{
            
        }
        
        [self fetchSchoolInfo];
    }
}

- (void)fetchTeacherInfo{
    /*
     page		//页码,当此参数不存在或者空或者传值1,都代表第1页,
     测试期间每次加载5条数据(APP上线后30条数据)
     举例:传值1:获取到第1~第5条数据,传值2:获取到第6~第10条数据
     user_lng	//用户当前经度
     user_lat	//用户当前纬度
     filter_distance	//距离筛选,单位km
     appoint_order	//指定排序,0:离我最近,1:评价最高,2:当前活跃,3:人气最高
     class_str	//类目,3级,逗号隔开,值是中文
     search_words	//关键字搜索(点击热门搜索,也用参数)
     */
    
//    NSLog(@"_teacherPage ==== %ld ***** %@, &&&&&& %@ , ^^^^^ %@, !!!!!%ld, ==== %@", _teacherPage, _longitudeString, _latitudeString, _filter_distance,_appoint_order, _class_str);
    if ([_filter_distance isEqualToString:@"附近"]) {
        _filter_distance = @"";
    }
    
    if (_teacherPage == 1) {
        [MBProgressHUD showHUDAddedTo:self.window animated:true];
    }
    
    
    XXEXingClassRoomTeacherListApi *xingClassRoomTeacherListApi = [[XXEXingClassRoomTeacherListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id page:_teacherPage user_lng:_longitudeString user_lat:_latitudeString filter_distance:_filter_distance appoint_order:_appoint_order class_str:_class_str search_words:_search_words];
    
    [xingClassRoomTeacherListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:self.window animated:true];
//        NSLog(@"老师   %@", request.responseJSONObject);
        
//        NSLog(@"个数  %ld", [request.responseJSONObject[@"data"] count]);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [XXEXingClassRoomTeacherListModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [teacherModelArray addObjectsFromArray:modelArray];
            
        }else{
            
        }
        [self customContent:teacherModelArray];
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:self.window animated:true];
        [self showString:@"数据请求失败" forSecond:1.f];
    }];


}

- (void)fetchCourseInfo{
//    NSLog(@"_coursePage ==== %ld", _coursePage);
    if ([_filter_distance isEqualToString:@"附近"]) {
        _filter_distance = @"";
    }
    
    if (_coursePage == 1) {
        [MBProgressHUD showHUDAddedTo:self.window animated:true];
    }
    XXEXingClassRoomCourseListApi *xingClassRoomCourseListApi = [[XXEXingClassRoomCourseListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id page:_coursePage user_lng:_longitudeString user_lat:_latitudeString filter_distance:_filter_distance appoint_order:_appoint_order class_str:_class_str search_words:_search_words];
    
    [xingClassRoomCourseListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:self.window animated:true];
//                NSLog(@"课程   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {

            NSArray *modelArray = [XXEXingClassRoomCourseListModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [courseModelArray addObjectsFromArray:modelArray];
        }else{
            
        }
        [self customContent:courseModelArray];
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:self.window animated:true];
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
}


- (void)fetchSchoolInfo{
    
//    NSLog(@"_filter_distance ==== %@", _filter_distance); //附近
    if ([_filter_distance isEqualToString:@"附近"]) {
        _filter_distance = @"";
    }
    if (_schoolPage == 1) {
        [MBProgressHUD showHUDAddedTo:self.window animated:true];
    }
    XXEXingClassRoomSchoolListApi *xingClassRoomSchoolListApi = [[XXEXingClassRoomSchoolListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id page:_schoolPage user_lng:_longitudeString user_lat:_latitudeString filter_distance:_filter_distance appoint_order:_appoint_order class_str:_class_str search_words:_search_words];
    
    [xingClassRoomSchoolListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:self.window animated:true];
//                NSLog(@"学校   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [[NSArray alloc] init];
            modelArray = [XXEXingClassRoomSchoolListModel parseResondsData:request.responseJSONObject[@"data"]];
            
            [schoolModelArray addObjectsFromArray:modelArray];
            
        }else{
            
        }
        [self customContent:schoolModelArray];
    } failure:^(__kindof YTKBaseRequest *request) {
        [MBProgressHUD hideHUDForView:self.window animated:true];
        [self showString:@"数据请求失败" forSecond:1.f];
    }];

    
}


// 有数据 和 无数据 进行判断
- (void)customContent:(NSMutableArray *)dataArray{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (dataArray.count == 0) {
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
       [myTableView reloadData];
    }
    
    [myTableView reloadData];
    
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
    [self.view insertSubview:placeholderImageView belowSubview:menu];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}


#pragma mark - 搜索==============================
- (void)searchButtonClick:(UIButton *)sender
{
    if ([XXEUserInfo user].login) {
        //    NSLog(@"搜索");
        XXEXingClassRoomSearchViewController *xingClassRoomSearchVC = [[XXEXingClassRoomSearchViewController alloc] init];
        
        //date_type //需要查询的数据类型,填数字 1: 老师  2:课程 3:机构
        if (_segentControl.selectedSegmentIndex == 0) {
            xingClassRoomSearchVC.date_type = @"1";
        }else if (_segentControl.selectedSegmentIndex == 1) {
            xingClassRoomSearchVC.date_type = @"2";
        }else if (_segentControl.selectedSegmentIndex == 2) {
            xingClassRoomSearchVC.date_type = @"3";
        }
        
        
        [xingClassRoomSearchVC returnArray:^(NSMutableArray *searchInfoArray) {
            //
            _search_words = searchInfoArray[0];
            if ([searchInfoArray[1] integerValue] == 1) {
                _segentControl.selectedSegmentIndex = 0;
            }else if ([searchInfoArray[1] integerValue] == 2) {
                _segentControl.selectedSegmentIndex = 1;
            }else if ([searchInfoArray[1] integerValue] == 3) {
                _segentControl.selectedSegmentIndex = 2;
            }
            
            [self getSearchInfo];
        }];
        
        [self.navigationController pushViewController:xingClassRoomSearchVC animated:YES];
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
    }

}


- (void)fetchNetData{
    
    XXECourseManagerCourseCategoryApi *courseManagerCourseCategoryApi = [[XXECourseManagerCourseCategoryApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    
    [courseManagerCourseCategoryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        classGroupArray1 = [[NSMutableArray alloc] init];
        classGroupDic2 = [[NSMutableDictionary alloc] init];
        classGroupDic3 = [[NSMutableDictionary alloc] init];
        //        NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *classModelArr1 = [[NSArray alloc] init];
            classModelArr1 = [XXECourseManagerClassModel1 parseResondsData:request.responseJSONObject[@"data"][@"class1_group"]];
            [classGroupArray1 addObjectsFromArray:classModelArr1];
            
            classGroupDic2 = request.responseJSONObject[@"data"][@"class2_group"];
            classGroupDic3 = request.responseJSONObject[@"data"][@"class3_group"];
            
        }else{
            
        }
        [self updateDataFirstArr1];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}

- (void)updateDataFirstArr1{
    //课程 更新 第一个 下拉框 的数据
    NSMutableArray *classNameArray1 = [[NSMutableArray alloc] init];
    for (XXECourseManagerClassModel1 *model1 in classGroupArray1) {
        [classNameArray1 addObject:model1.name];
    }
    firstArr1 = classNameArray1;
    //        NSLog(@"firstArr1 --- %@", firstArr1);
    
    [self updateDataFirstArr2];
}

- (void)updateDataFirstArr2{
    classGroupArray2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < classGroupArray1.count; i++) {
        XXECourseManagerClassModel1 *model1 = classGroupArray1[i];
        NSArray *classModelArr2 = [[NSArray alloc] init];
        classModelArr2 = [XXECourseManagerClassModel2 parseResondsData:classGroupDic2[model1.class1]];
        [classGroupArray2 addObject:classModelArr2];
    }
    
    //    NSLog(@"classGroupArray2 --- %@", classGroupArray2);
    
    //课程 更新 第二个 下拉框 的数据
    if (classGroupArray2.count != 0) {
        for (int i = 0; i < classGroupArray2.count; i++) {
            NSMutableArray *mArr = classGroupArray2[i];
            NSMutableArray *classNameArray2 = [[NSMutableArray alloc] init];
            for (XXECourseManagerClassModel2 *model2 in mArr) {
                [classNameArray2 addObject:model2.name];
            }
            [firstArr2 addObject:classNameArray2];
        }
        
    }
    
    //    NSLog(@"firstArr2 --- %@", firstArr2);
    
    [self updateDataFirstArr3];
}

//
- (void)updateDataFirstArr3{
    classGroupArray3 = [[NSMutableArray alloc] init];
    
    if (classGroupArray2.count != 0) {
        
        for (int i = 0; i < classGroupArray2.count; i++) {
            NSMutableArray *mArr = classGroupArray2[i];
            NSArray *classModelArr3 = [[NSArray alloc] init];
            for (XXECourseManagerClassModel2 *model2 in mArr) {
                
                classModelArr3 = [XXECourseManagerClassModel3 parseResondsData:classGroupDic3[model2.class2]];
                [classGroupArray3 addObject:classModelArr3];
            }
        }
    }
    
    //    NSLog(@"classGroupArray3 --- %@", classGroupArray3 );
    //课程 更新 第三个 下拉框 的数据
    if (classGroupArray3.count != 0) {
        for (int i = 0; i < classGroupArray3.count; i++) {
            NSMutableArray *mArr = classGroupArray3[i];
            NSMutableArray *classNameArray3 = [[NSMutableArray alloc] init];
            for (XXECourseManagerClassModel3 *model3 in mArr) {
                [classNameArray3 addObject:model3.name];
            }
            [firstArr3 addObject:classNameArray3];
        }
        
    }
    
    //    NSLog(@"firstArr3 --- %@", firstArr3);
    firstMenuArray = [[NSMutableArray alloc] initWithObjects:firstArr1, firstArr2, firstArr3, nil];
    
    NSMutableArray *secArr = [[NSMutableArray alloc] init];
    //老师
    if (_segentControl.selectedSegmentIndex == 0) {
        secArr = secondMenuArray1;
    }else if (_segentControl.selectedSegmentIndex == 1){
        secArr = secondMenuArray2;
    }else if (_segentControl.selectedSegmentIndex == 2){
        secArr = secondMenuArray3;
    }
    
    [menu createThreeMenuTitleArray:menuTitleArray FirstArr:firstMenuArray SecondArr:secArr threeArr:thirdMenuArray];
}

#pragma mark -- 代理方法 返回点击时对应的内容和index(合并了方法1和方法2)
- (void)menuCellDidSelected:(NSString *)MenuTitle menuIndex:(NSInteger)menuIndex firstContent:(NSString *)firstContent firstIndex:(NSInteger)firstIndex secondContent:(NSString *)secondContent secondIndex:(NSInteger)secondIndex thirdContent:(NSString *)thirdContent thirdIndex:(NSInteger)thirdIndex{
    //    NSLog(@"菜单title:%@  titleIndex:%ld,一级菜单:%@    一级菜单Index:%ld,     二级子菜单:%@   二级子菜单Index:%ld   三级子菜单:%@  三级子菜单Index:%ld",MenuTitle,(long)menuIndex,firstContent,(long)firstIndex,secondContent,(long)secondIndex,thirdContent,(long)thirdIndex);

    switch (menuIndex) {
        case 0:
            _class_str = [NSString stringWithFormat:@"%@,%@,%@",firstContent,secondContent,thirdContent];

            if (_segentControl.selectedSegmentIndex == 0) {
                if (teacherModelArray.count != 0) {
                    [teacherModelArray removeAllObjects];
                }
             
                [self fetchTeacherInfo];
                
            }else if (_segentControl.selectedSegmentIndex == 1){
                if (courseModelArray.count != 0) {
                    [courseModelArray removeAllObjects];
                }

                [self fetchCourseInfo];
                
            }else if (_segentControl.selectedSegmentIndex == 2){
                if (schoolModelArray.count != 0) {
                    [schoolModelArray removeAllObjects];
                }

                [self fetchSchoolInfo];
            }
            break;
        case 1:

            _appoint_order = firstIndex;
            
            if (_segentControl.selectedSegmentIndex == 0) {
                if (teacherModelArray.count != 0) {
                    [teacherModelArray removeAllObjects];
                }
                [self fetchTeacherInfo];
                
            }else if (_segentControl.selectedSegmentIndex == 1){
                if (courseModelArray.count != 0) {
                    [courseModelArray removeAllObjects];
                }
                [self fetchCourseInfo];
                
            }else if (_segentControl.selectedSegmentIndex == 2){
                if (schoolModelArray.count != 0) {
                    [schoolModelArray removeAllObjects];
                }
                [self fetchSchoolInfo];
            }
            break;
        case 2:
            _filter_distance = MenuTitle;
            if (_segentControl.selectedSegmentIndex == 0) {
                if (teacherModelArray.count != 0) {
                    [teacherModelArray removeAllObjects];
                }
                [self fetchTeacherInfo];
                
            }else if (_segentControl.selectedSegmentIndex == 1){
                if (courseModelArray.count != 0) {
                    [courseModelArray removeAllObjects];
                }
                [self fetchCourseInfo];
                
            }else if (_segentControl.selectedSegmentIndex == 2){
                if (schoolModelArray.count != 0) {
                    [schoolModelArray removeAllObjects];
                }
                [self fetchSchoolInfo];
            }
            break;
        default:
            break;
    }
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segentNumber == 0) {
        return teacherModelArray.count;
    }else if (self.segentNumber == 1){
        return courseModelArray.count;
    }else if (self.segentNumber == 2){
        return schoolModelArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *identifier = @"cell";
    
    if (self.segentNumber == 0) {
            XXEXingClassRoomTeacherListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEXingClassRoomTeacherListTableViewCell" owner:self options:nil]lastObject];
            }
            XXEXingClassRoomTeacherListModel *model = teacherModelArray[indexPath.row];
            /*
             0 :表示 自己 头像 ，需要添加 前缀
             1 :表示 第三方 头像 ，不需要 添加 前缀
             //判断是否是第三方头像
             */
        
            NSString *head_img;
            if ([model.head_img_type isEqualToString:@"0"] ) {
                head_img = [NSString stringWithFormat:@"%@%@",kXXEPicURL,model.head_img];
            }else {
                head_img = model.head_img;
            }
        
            cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
            cell.iconImageView.layer.masksToBounds = YES;
        
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
        
//                NSLog(@"课程  %@", model.teach_course);
           cell.nameLabel.text = model.tname;
            cell.ageLabel.text = [NSString stringWithFormat:@"%@岁", model.age];
            cell.scoreLabel.text = [NSString stringWithFormat:@"%@分", model.score_num];
            cell.courseLabel.text = model.teach_range;
            cell.distanceLabel.text = [NSString stringWithFormat:@"%@KM", model.distance];
            cell.teachTimeLabel.text = [NSString stringWithFormat:@"教龄:%@年", model.exper_year];

        
            return cell;
    }else if (self.segentNumber == 1) {
        XXEXingClassRoomCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEXingClassRoomCourseListTableViewCell" owner:self options:nil]lastObject];
        }
        XXEXingClassRoomCourseListModel *model = courseModelArray[indexPath.row];
        
        cell.iconImageView.layer.cornerRadius= cell.iconImageView.bounds.size.width/2;
        cell.iconImageView.layer.masksToBounds=YES;
        
        NSString *coursePicStr = [NSString stringWithFormat:@"%@%@", kXXEPicURL, model.pic];
        //        NSLog(@"hhh %@", coursePicStr);
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:coursePicStr] placeholderImage:[UIImage imageNamed:@"home_logo_course_icon80x80"]];
        
        //
        cell.courseLabel.text = model.course_name;
        
        if ([model.teacher_tname_group count] != 0) {
            cell.nameLabel.text = [NSString stringWithFormat:@"授课老师:%@",model.teacher_tname_group[0]];
        }
        
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@KM", model.distance];
        
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
    }else if (self.segentNumber == 2) {
        XXEXingClassRoomSchoolListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEXingClassRoomSchoolListTableViewCell" owner:self options:nil]lastObject];
        }
        XXEXingClassRoomSchoolListModel *model = schoolModelArray[indexPath.row];
        /*
         0 :表示 自己 头像 ，需要添加 前缀
         1 :表示 第三方 头像 ，不需要 添加 前缀
         //判断是否是第三方头像
         */
        NSString *head_img = [kXXEPicURL stringByAppendingString:model.logo];
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
        cell.iconImageView.layer.masksToBounds = YES;
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
        
        //                NSLog(@"课程  %@", model.teach_course);
        cell.nameLabel.text = model.name;
        cell.scoreLabel.text = [NSString stringWithFormat:@"%@分", model.score_num];
        cell.studentLabel.text = [NSString stringWithFormat:@"%@位学生", model.baby_count];
        cell.teacherLabel.text = [NSString stringWithFormat:@"%@位老师", model.teacher_count];
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@KM", model.distance];
        cell.addressLabel.text = [NSString stringWithFormat:@"地址:%@", model.address];
        
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.segentNumber == 0) {
        return 95;
    }else if (self.segentNumber == 1) {
        return 115;
    } else if (self.segentNumber == 2) {
        return 95;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([XXEUserInfo user].login) {
        if (self.segentNumber == 0) {
            XXEXingClassRoomTeacherDetailInfoViewController *xingClassRoomTeacherDetailInfoVC = [[XXEXingClassRoomTeacherDetailInfoViewController alloc] init];
            XXEXingClassRoomTeacherListModel *model = teacherModelArray[indexPath.row];
            xingClassRoomTeacherDetailInfoVC.teacher_id = model.teacher_id;
            [self.navigationController pushViewController:xingClassRoomTeacherDetailInfoVC animated:YES];
            
        }else if (self.segentNumber == 1){
            XXEXingClassRoomCourseDetailInfoViewController *xingClassRoomCourseDetailInfoVC = [[XXEXingClassRoomCourseDetailInfoViewController alloc] init];
            XXEXingClassRoomCourseListModel *model = courseModelArray[indexPath.row];
            xingClassRoomCourseDetailInfoVC.course_id = model.courseId;
            [self.navigationController pushViewController:xingClassRoomCourseDetailInfoVC animated:YES];
            
        }else if (self.segentNumber == 2){
            
            XXEHomeLogoRootViewController *homeLogoRootVC = [[XXEHomeLogoRootViewController alloc] init];
            XXEXingClassRoomSchoolListModel *model = schoolModelArray[indexPath.row];
            homeLogoRootVC.schoolId = model.school_id;
            [self.navigationController pushViewController:homeLogoRootVC animated:NO];
        }
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
