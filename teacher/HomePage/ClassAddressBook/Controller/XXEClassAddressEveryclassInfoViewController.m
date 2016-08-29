

//
//  XXEClassAddressEveryclassInfoViewController.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassAddressEveryclassInfoViewController.h"
#import "XXEClassAddressTableViewCell.h"
#import "XXEClassAddressEveryclassInfoApi.h"
#import "XXEClassAddressStudentInfoModel.h"
#import "XXEClassAddressTeacherInfoModel.h"
#import "XXEClassAddressManagerInfoModel.h"
#import "XXEBabyFamilyInfoViewController.h"

@interface XXEClassAddressEveryclassInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    NSArray *title_nameArray;
    
    UIButton *arrowButton;
    NSString *search_wordsStr;
}

@property (nonatomic,strong) NSMutableArray *flagArray;
@property (nonatomic , strong) NSMutableArray *selectedBabyInfoArr;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;

@end

@implementation XXEClassAddressEveryclassInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flagArray = [[NSMutableArray alloc]init];
    for (int j=0; j<3; j++) {
        NSNumber *flagN = [NSNumber numberWithBool:YES];
        [self.flagArray addObject:flagN];
    }
    
    title_nameArray = [[NSArray alloc] initWithObjects:@"班级宝贝", @"班级老师", @"管理员", nil];
    
    [self createTableView];
}


- (void)fetchNetData{
    /*
     【班级通讯录】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Global/class_contact_book
     
     传参:
     
     school_id	//学校id
     class_id	//班级id
     search_words	//搜索关键字,搜索的返回的结构与之前一模一样
     
     测试:3个传参都填1   */
    if (search_wordsStr == nil) {
        search_wordsStr = @"";
    }else{
        [_flagArray removeAllObjects];
        for (int j=0; j<3; j++) {
            NSNumber *flagN = [NSNumber numberWithBool:YES];
            [_flagArray addObject:flagN];
        }
    }
    
//    NSLog(@"学校id  %@   ------  班级 id %@", _schoolId, _selectedClassId);
    XXEClassAddressEveryclassInfoApi *classAddressEveryclassInfoApi = [[XXEClassAddressEveryclassInfoApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId class_id:_selectedClassId search_words:@""];
    
    
    [classAddressEveryclassInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        
//        NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
           
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            NSArray *babyModelArray = [[NSArray alloc] init];
           babyModelArray = [XXEClassAddressStudentInfoModel parseResondsData:dict[@"baby_info"]];
            NSArray *teacherModelArray = [[NSArray alloc] init];
           teacherModelArray = [XXEClassAddressTeacherInfoModel parseResondsData:dict[@"teacher"]];
            NSArray *managerModelArray = [[NSArray alloc] init];
          managerModelArray  = [XXEClassAddressManagerInfoModel parseResondsData:dict[@"manager"]];
            
            [_dataSourceArray addObject:babyModelArray];
            [_dataSourceArray addObject:teacherModelArray];
            [_dataSourceArray addObject:managerModelArray];

        }else{
            
        }
//        NSLog(@"%@", _dataSourceArray);
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}



// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTableView reloadData];
        
    }
    
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    
    [self fetchNetData];
    [ _myTableView.mj_header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_footer endRefreshing];
}

- (void)loadFooterNewData{
    
    [self fetchNetData];
    [ _myTableView.mj_footer endRefreshing];
    
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSLog(@"%@", _dataSourceArray[section]);
    
    
    if ([self.flagArray[section] boolValue] == YES) {
        return [_dataSourceArray[section] count];
    }else{
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEClassAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEClassAddressTableViewCell" owner:self options:nil]lastObject];
    }
    
    if (indexPath.section == 0) {
        //宝贝 信息
        XXEClassAddressStudentInfoModel *model = _dataSourceArray[indexPath.section][indexPath.row];
        //宝贝 头像 全部 是拼接 的
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, model.head_img]] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
        cell.nameLabel.text = model.tname;
        cell.detailLabel.text = [NSString stringWithFormat:@"%@岁", model.age];
        
        UITapGestureRecognizer *iconTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
        cell.iconImageView.tag =100+indexPath.row;
        [cell.iconImageView addGestureRecognizer:iconTap];
        
    }else if (indexPath.section == 1){
        //老师 信息
        XXEClassAddressTeacherInfoModel *model = _dataSourceArray[indexPath.section][indexPath.row];
        //[head_img_type] => 0	//头像类型,0代表系统头像,需要加http头部(看前言),如果是1,是第三方头像
        NSString *headImageStr;
        if ([model.head_img_type isEqualToString:@"0"]) {
            headImageStr = [NSString stringWithFormat:@"%@%@", kXXEPicURL, model.head_img];
        }else if ([model.head_img_type isEqualToString:@"1"]){
            headImageStr = model.head_img;
        }
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
        cell.nameLabel.text = model.tname;
        cell.detailLabel.text = model.teach_course;
        cell.lookFamilyInfoButton.hidden = YES;
    }else if (indexPath.section == 2){
        //管理人员 信息
        XXEClassAddressManagerInfoModel *model = _dataSourceArray[indexPath.section][indexPath.row];
        //[head_img_type] => 0	//头像类型,0代表系统头像,需要加http头部(看前言),如果是1,是第三方头像
        NSString *headImageStr;
        if ([model.head_img_type isEqualToString:@"0"]) {
            headImageStr = [NSString stringWithFormat:@"%@%@", kXXEPicURL, model.head_img];
        }else if ([model.head_img_type isEqualToString:@"1"]){
            headImageStr = model.head_img;
        }
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:headImageStr] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
        cell.nameLabel.text = model.tname;
        cell.detailLabel.text = model.teach_course;
        cell.lookFamilyInfoButton.hidden = YES;
    
    }
   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //点击 宝贝 cell 先进入到 宝贝家人 列表
        XXEBabyFamilyInfoViewController *babyFamilyInfoVC = [[XXEBabyFamilyInfoViewController alloc] init];
        XXEClassAddressStudentInfoModel *model = _dataSourceArray[indexPath.section][indexPath.row];
//        NSLog(@"%@", model);
        babyFamilyInfoVC.baby_id = model.baby_id;
        babyFamilyInfoVC.familyInfoArray = model.parent_list;
        [self.navigationController pushViewController:babyFamilyInfoVC animated:YES];
        
    }else if (indexPath.section == 1){
    
    }else if (indexPath.section == 2){
    
    }
    
}


- (void)iconTap:(UITapGestureRecognizer*)tap{
    // NSLog(@">>>>>>>>>>>>>>tapViewTag>>>>>>>>>>>>>>>>>>>>>%ld",tap.view.tag);
//    if ([XXEUserInfo user].login){
//        KTClassTelephoneBabyViewController *telephoneBabyVC =[[KTClassTelephoneBabyViewController alloc]init];
//        telephoneBabyVC.idKT =KTIDMArr[0][tap.view.tag-100];
//        [self.navigationController pushViewController:telephoneBabyVC animated:NO];
//    }else{
//        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
//    }
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    
    view.tag = 100 + section;
    
    UITapGestureRecognizer *viewPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPressClick:)];
    [view addGestureRecognizer:viewPress];
    
    arrowButton = [[UIButton alloc]initWithFrame:CGRectMake(10, (44-24)/2, 17.5, 20)];
    NSNumber *flagN = self.flagArray[section];
    
    if ([flagN boolValue]) {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
        CGAffineTransform currentTransform =arrowButton.transform;
        CGAffineTransform newTransform =CGAffineTransformRotate(currentTransform, M_PI/2);
        arrowButton.transform =newTransform;
        
    }else
    {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal ];
        
    }
    arrowButton.tag = 300+section;
    //    [arrowButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:arrowButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 200, 30)];
    label.text = [NSString stringWithFormat:@"%@",title_nameArray[section]];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:label];
    
    return view;
}

- (void)viewPressClick:(UITapGestureRecognizer *)press{
    
    //    NSLog(@" 头视图  tag  %ld", press.view.tag - 100);
    
    if ([self.flagArray[press.view.tag - 100] boolValue]) {
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber  numberWithBool:NO]];
        
    }else{
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber numberWithBool:YES]];
    }
    [_myTableView reloadData ];
    
    
}
//返回每个分组的表头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

#pragma mark
#pragma mark - --------------- 搜索--------------------------
- (void)searchB:(UIBarButtonItem*)btn{
    
    //    _flagShow = !_flagShow;
    
//    if ([XXEUserInfo user].login){
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20, kWidth, 44)];
        UIImage *backgroundImg = [XXETool createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
        [_searchBar setBackgroundImage:backgroundImg];
        _searchBar.placeholder =@"输入你想要查询的联系人";
        _searchBar.tintColor = [UIColor blackColor];
        _searchBar.delegate =self;
        _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
        [self.navigationItem.titleView sizeToFit];
        [self.navigationController.view addSubview:_searchBar];
        _searchBar.showsCancelButton =YES;
//    }else{
//        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
//    }
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = YES;
    
    return YES;
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    search_wordsStr = _searchBar.text;
    
    [self fetchNetData];
    
    [searchBar resignFirstResponder];
    
    [searchBar removeFromSuperview];
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    _searchBar.text=nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
