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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
#import "XXEHomePageApi.h"
#import "XXEUserInfo.h"
#import "XXEHomePageModel.h"
#import "XXEHomePageSchoolModel.h"
#import "XXEHomePageClassModel.h"
=======
#import "XXEFlowerbasketViewController.h"

>>>>>>> Stashed changes
=======
#import "XXEFlowerbasketViewController.h"

>>>>>>> Stashed changes

@interface XXEHomePageViewController ()<XXEHomePageHeaderViewDelegate,XXEHomePageMiddleViewDelegate,XXEHomePageBottomViewDelegate>
@property (nonatomic, strong)NSMutableArray *schoolDatasource;//学校信息
@property (nonatomic, strong)NSMutableArray *classDatasource;//班级信息

@property (nonatomic, strong)XXEHomePageHeaderView *headView;
@property (nonatomic, strong)XXEHomePageMiddleView *middleView;

@end

@implementation XXEHomePageViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"首页控制器");
    
    //获取数据
    [self setupHomePageRequeue];
    
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
}
//中部视图
- (void)homeMiddleFirstButtonClick
{
//    NSLog(@"----花篮点击事件----");
    XXEFlowerbasketViewController *XXEFlowerbasketVC = [[XXEFlowerbasketViewController alloc] init];
    
    [self.navigationController pushViewController:XXEFlowerbasketVC animated:YES];
}

- (void)homeMiddleTwoButtonClick
{
    NSLog(@"---小红花点击事件----");
}

- (void)homeMiddleThreeButtonClick
{
    NSLog(@"----猩币点击事件---");
}

//下部视图点击相应的方法
- (void)homeClassOneButtonClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
            NSLog(@"----实时监控----");
            break;
        case 1:
            NSLog(@"---相册----");
            break;
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
            NSLog(@"---点评----");
            break;
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
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"data"] );
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        XXEHomePageModel *model = [[XXEHomePageModel alloc]initWithDictionary:data error:nil];
        NSLog(@"%lu",(unsigned long)model);
//        [self.headView configCellWithInfo:model];
//        for (int i =0 ; i < model.school_info.count; i++) {
//            [self.headView configCellWithInfo1:model.school_info[i]];
//        }
//        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}
















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
