
//
//  XXESchoolTimetableViewController.m
//  teacher
//
//  Created by Mac on 16/10/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolTimetableViewController.h"
#import "XXESchoolTimetableCollectionViewCell.h"
#import "XXESchoolTimetableTraditionApi.h"

#import "XXEAllWeeksApi.h"

//横向 周几 label 宽/高
#define weekLabelWidth (kWidth - 26 - 7 * 1)/7
#define weekLabelHeight 30

//竖向 几节课
#define timeLabelWidth 26
#define timeLabelHeight 39
//具体课程 label 宽/高
#define  cellWidth  (kWidth - 26 - 7 * 1)/7
#define  cellHeight  25



@interface XXESchoolTimetableViewController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    //假 navigationBar
    UIView *navigationBarView;
    
    WJCommboxView *titleCommbox;
    UIView *titleCommboxBgView;
    
    //左键 返回键
    UIButton *leftButton;
    //右键 切换键
    UIButton *rightButton;
    //一共几周
    NSMutableArray *weeksArray;
    //一共几个月
    NSMutableArray *monthArray;
    NSDictionary *weekMonthDic;
    //下面的 scrollview
    UIScrollView *bgScrollView;
    //创建行数
    NSInteger courseRow;
    
    //传统 数据 数组
    NSMutableArray *courseTraditionArray;
    //时间轴 数据 数组
    NSMutableArray *courseTimeArray;
    //scrollView 是第几页
    NSInteger page;
    
    UICollectionView *courseCollectionView;
//    NSMutableArray *courseDataArray;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@end

@implementation XXESchoolTimetableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(116,205, 169);;

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    weeksArray = [[NSMutableArray alloc] init];
    monthArray = [[NSMutableArray alloc] init];
    weekMonthDic = [[NSMutableDictionary alloc] init];
    courseTraditionArray = [[NSMutableArray alloc] init];
    courseTimeArray = [[NSMutableArray alloc] init];
    courseRow = 0;
    page = 0;
    
    
    for (int i = 0; i < 20; i++) {
        if (i == 0) {
            [weeksArray addObject:@"本周"];
        }else{
            NSString *str = [NSString stringWithFormat:@"第%d周",i+1];
            [weeksArray addObject:str];
        }
    }
    //获取一共几周 数据
    [self fetchAllWeeks];
    //获取 传统 模式 数据
    [self fetchCourseInfoTraditionStyle];
    
    
    //创建 假navigationBar
    [self createNavigationBar];
    //左键
    [self createLeftButton];
    //标题 下拉框
    [self createTitleView];
    //创建  右键 切换模式
    [self createRightButton];
    
    [self createScrollView];
    
    [self createCollectionView];
    
}

- (void)fetchAllWeeks{

    XXEAllWeeksApi *allWeeksApi = [[XXEAllWeeksApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    [allWeeksApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"%@", request.responseJSONObject);
        
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 1) {
            if ([dict[@"data"] count] != 0) {
                for (int i = 0; i < [dict[@"data"] count]; i++) {
                    NSString *str = [XXETool dateStringFromNumberTimer:dict[@"data"][i]];
                    NSArray *arr = [str componentsSeparatedByString:@"-"];

                    [monthArray addObject:arr[1]];
                }
            }
            
        }
        [self createScrollViewTitlesLabel2];
        [courseCollectionView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}


#pragma mark =========== fetchCourseInfoTraditionStyle====
- (void)fetchCourseInfoTraditionStyle{

    XXESchoolTimetableTraditionApi *schoolTimetableTraditionApi = [[XXESchoolTimetableTraditionApi alloc] initWithXid:parameterXid user_id:parameterUser_Id week_date:@""];
    [schoolTimetableTraditionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        NSLog(@"%@", request.responseJSONObject);
        courseTraditionArray = request.responseJSONObject[@"data"];
        courseRow = [courseTraditionArray count];

        [self createScrollViewTitlesLabel1];
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
}


- (void)createNavigationBar{
    navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    navigationBarView.backgroundColor = UIColorFromRGB(0, 170, 42);
    navigationBarView.userInteractionEnabled = YES;
    [self.view addSubview:navigationBarView];
    [self.view bringSubviewToFront:navigationBarView];
}

- (void)createLeftButton{
//
    leftButton = [UIButton createButtonWithFrame:CGRectMake(10, 34, 45, 19) backGruondImageName:@"back_icon90x38" Target:self Action:@selector(leftButtonClick) Title:@""];
    [navigationBarView addSubview:leftButton];
}

- (void)leftButtonClick{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createTitleView{
    //----------------------周几 下拉框
    titleCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake((KScreenWidth - 90) / 2, 30 , 90, 30)];
    titleCommbox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
//    titleCommbox.textField.placeholder = @"本周";
    titleCommbox.textField.text = weeksArray[0];
    titleCommbox.dataArray = weeksArray;
    titleCommbox.textField.textAlignment = NSTextAlignmentLeft;
    titleCommbox.textField.tag = 1001;
    
    [navigationBarView addSubview:titleCommbox];
    
    //监听
    [titleCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"1"];
    
    titleCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    titleCommboxBgView.backgroundColor = [UIColor clearColor];
    titleCommboxBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [titleCommboxBgView addGestureRecognizer:singleTouch];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
}


- (void)createRightButton{

    //切换模式(传统模式/时间轴)
    rightButton =[UIButton createButtonWithFrame:CGRectMake(KScreenWidth - 44, 34, 22, 22) backGruondImageName:@"schooltimetable_exchange_icon" Target:self Action:@selector(exchangeBtn:) Title:@""];
    [navigationBarView addSubview:rightButton];
}

- (void)exchangeBtn:(UIButton *)button{


}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 1001:
        {
            
            [titleCommbox removeFromSuperview];
            
            [self.view addSubview:titleCommboxBgView];
            [self.view addSubview:titleCommbox];
            
        }
            break;
        default:
            break;
    }
    
}


- (void)commboxHidden{
    
    [titleCommboxBgView removeFromSuperview];
    [titleCommbox setShowList:NO];
    titleCommbox.listTableView.hidden = YES;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 1:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                
                NSInteger index = [weeksArray indexOfObject:newName];
                bgScrollView.contentOffset = CGPointMake(0, KScreenHeight * index);
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - ------------- createScrollView =============
- (void)createScrollView{
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight)];
    bgScrollView.pagingEnabled = YES;
    bgScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight * weeksArray.count);
    bgScrollView.delegate = self;
    bgScrollView.userInteractionEnabled = YES;
    [self.view addSubview:bgScrollView];
    
}
#pragma mark ------------ createScrollViewContent ==========
- (void)createScrollViewTitlesLabel1{
   //创建竖向 标题
    if (courseRow == 0) {
        UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0, page * KScreenHeight, timeLabelWidth, timeLabelHeight) Font:14 Text:[NSString stringWithFormat:@"%@月", monthArray[page]]];
        monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
        monthLabel.textAlignment = NSTextAlignmentCenter;
        [bgScrollView addSubview:monthLabel];
    }else{
        for (int i = 0; i <= courseRow; i++) {
            if (i == 0) {
                UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0, page * KScreenHeight, timeLabelWidth, timeLabelHeight) Font:14 Text:[NSString stringWithFormat:@"%@月", monthArray[page]]];
                monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
                monthLabel.textAlignment = NSTextAlignmentCenter;
                [bgScrollView addSubview:monthLabel];
            }else{
                UILabel *monthLabel = [UILabel createLabelWithFrame:CGRectMake(0, page * KScreenHeight + 1 +(timeLabelHeight + 1) * i, timeLabelWidth, timeLabelHeight) Font:10 Text:[NSString stringWithFormat:@"%d", i]];
                monthLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
                monthLabel.textAlignment = NSTextAlignmentCenter;
                [bgScrollView addSubview:monthLabel];
            
            }
        }
    
    }
}

//竖向 titleLabel
- (void)createScrollViewTitlesLabel2{
    //创建水平 周一~周日
    NSArray *weekArr = [[NSArray alloc] initWithObjects:@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日", nil];
    
    for (int j = 0; j < 7; j ++) {
        UILabel *weekLabel = [UILabel createLabelWithFrame:CGRectMake(timeLabelWidth + 1 + j * (weekLabelWidth + 1), page * KScreenHeight, weekLabelWidth, weekLabelHeight) Font:10 Text:weekArr[j]];
        weekLabel.backgroundColor = UIColorFromRGB(195, 239, 251);
        weekLabel.textAlignment = NSTextAlignmentCenter;
        [bgScrollView addSubview:weekLabel];
    }

}

- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = NO;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    
    courseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(timeLabelWidth, weekLabelHeight, KScreenWidth - timeLabelWidth, KScreenHeight - weekLabelHeight) collectionViewLayout:layout];
    courseCollectionView.backgroundColor = [UIColor clearColor];
    courseCollectionView.delegate = self;
    courseCollectionView.dataSource = self;
    [bgScrollView addSubview:courseCollectionView];

    [courseCollectionView registerClass:[XXESchoolTimetableCollectionViewCell class] forCellWithReuseIdentifier:@"XXESchoolTimetableCollectionViewCell"];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return courseRow;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
//    NSLog(@"%@", courseTraditionArray[section]);
    return 7;
//    return [courseTraditionArray[section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"XXESchoolTimetableCollectionViewCell";
    XXESchoolTimetableCollectionViewCell *cell = [courseCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return (CGSize){cellWidth,cellWidth};
//}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 1, 5, 1);
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中某个");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    page = bgScrollView.contentOffset.y / kHeight;
    NSLog(@"page ---- %ld", page);
    
    titleCommbox.textField.text = weeksArray[page];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [titleCommbox.textField removeObserver:self forKeyPath:@"text" context:@"1"];

}
@end
