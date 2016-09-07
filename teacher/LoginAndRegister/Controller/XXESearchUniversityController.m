//
//  XXESearchUniversityController.m
//  teacher
//
//  Created by codeDing on 16/9/7.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESearchUniversityController.h"
#import "XXESearchUnApi.h"
#import "XXESearchUNModel.h"
#import "UtilityFunc.h"
#import "XXERegisterSearchSchoolCell.h"

@interface XXESearchUniversityController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *myTableView;

/** 学校信息的 */
@property (nonatomic, strong)NSMutableArray *searchSchoolDatasource;

@end
static NSString *CellIdentifier = @"Cell";

@implementation XXESearchUniversityController

- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-44) style:UITableViewStyleGrouped];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _myTableView;
}

- (NSMutableArray *)searchSchoolDatasource
{
    if (!_searchSchoolDatasource) {
        _searchSchoolDatasource = [NSMutableArray array];
    }
    return _searchSchoolDatasource;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationItem.title = @"搜索学校";
    self.navigationController.navigationBarHidden = NO;
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"XXERegisterSearchSchoolCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [self.view addSubview:self.myTableView];
    
    [self createSearch];

}

#pragma mark - createSearch ----------------------------------
- (void)createSearch{
    
    //搜索
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    UIImage *bachgroundImage = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
    [_searchBar setBackgroundImage:bachgroundImage];
    _searchBar.placeholder = @"请输入学校";
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.delegate = self;
    _searchController = [[UISearchController alloc]initWithSearchResultsController:self];
    [_myTableView addSubview:_searchBar];
}
#pragma mark - searchBarDelegte
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索");
    NSString *strngXid;
    NSString *albumUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        albumUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        albumUserId = USER_ID;
    }
    
    XXESearchUnApi *searchUNApi = [[XXESearchUnApi alloc]initWithUserXid:strngXid UserId:albumUserId Province:@"" City:@"" District:@"" SearchWords:searchBar.text];
    [searchUNApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseJSONObject);
        
        if ([[request.responseJSONObject objectForKey:@"code"] intValue] == 1)
        {
            NSArray *dic = [request.responseJSONObject objectForKey:@"data"];
            NSLog(@"搜索的学校的信息:%@",dic);
            for (int i = 0; i < dic.count; i++) {
                XXESearchUNModel *model = [[XXESearchUNModel alloc]initWithDictionary:dic[i] error:nil];
                [self.searchSchoolDatasource addObject:model];
            }
            [self.myTableView reloadData];
            [self.searchBar resignFirstResponder];
        } else {
            
            [self showString:@"搜索失败,请确认学校名称" forSecond:1.f];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"搜索失败,请确认学校名称" forSecond:1.f];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchSchoolDatasource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XXERegisterSearchSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XXERegisterSearchSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    XXESearchUNModel *model = self.searchSchoolDatasource[indexPath.row];
    cell.registerSchoolNameLabel.text = model.schoolName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr = self.searchSchoolDatasource[indexPath.row];
    
    self.returnArrayBlock(arr);
    XXESearchUNModel *model = self.searchSchoolDatasource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(searchSchoolNUMessage:)]) {
        [self.delegate searchSchoolNUMessage:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)returnArray:(ReturnArrayBlock)block{
    self.returnArrayBlock = block;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchController.searchBar resignFirstResponder];
    
    [_searchController.searchBar endEditing:YES];
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
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
