
//
//  XXERongCloudSearchFriendViewController.m
//  teacher
//
//  Created by Mac on 16/10/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudSearchFriendViewController.h"
#import "XXERongCloudSearchFriendDetailInfoViewController.h"
#import "XXERongCloudSearchFriendTableViewCell.h"
#import "XXERongCloudSeeNearUserListModel.h"
#import "XXERongCloudSearchFriendApi.h"

@interface XXERongCloudSearchFriendViewController ()< UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    UISearchController *_searchController;
    UISearchBar *_searchBar;
    UITableView *_myTableView;
    
    NSString *_parameterXid;
    NSString *_parameterUser_Id;
    
    //
    NSString *_headImageStr;
    NSString *_nicknameStr;
    NSString *_xidStr;
    //几行
    NSInteger rows;
}


@end

@implementation XXERongCloudSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    if ([XXEUserInfo user].login){
        _parameterXid = [XXEUserInfo user].xid;
        _parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        _parameterXid = XID;
        _parameterUser_Id = USER_ID;
    }
    _headImageStr = @"";
    _nicknameStr = @"";
    rows = 0;
    
    [self createSearchBar];
    
}

#pragma mark
#pragma mark - --------------- 搜索--------------------------

- (void)createSearchBar{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, kWidth, 44)];
    UIImage *backgroundImg = [XXETool createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
    [_searchBar setBackgroundImage:backgroundImg];
    _searchBar.placeholder =@"输入你想要查询的联系人";
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.delegate =self;
    _searchController = [[UISearchController alloc]initWithSearchResultsController:self];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchBar.showsCancelButton =YES;
    [self.view addSubview:_searchBar];
//    _myTableView.tableHeaderView = _searchBar;

}

#pragma mark -

- (void)searchFriend{
    XXERongCloudSearchFriendApi *rongCloudSearchFriendApi = [[XXERongCloudSearchFriendApi alloc] initWithXid:_parameterXid user_id:_parameterUser_Id search_con:_searchBar.text];
    [rongCloudSearchFriendApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//            NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            rows = 1;
            //            0 :表示 自己 头像 ，需要添加 前缀
            //            1 :表示 第三方 头像 ，不需要 添加 前缀
            //判断是否是第三方头像
            NSDictionary *dic = request.responseJSONObject[@"data"];
            if([dic[@"head_img_type"] integerValue] == 0){
                _headImageStr = [kXXEPicURL stringByAppendingString:dic[@"head_img"]];
            }else{
                _headImageStr = dic[@"head_img"];
            }
            
            _nicknameStr = dic[@"nickname"];
            _xidStr = dic[@"xid"];
        }else{
            [self showHudWithString:@"未搜索到该用户" forSecond:1.5];
        }
        
        [self createTableView];
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];


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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (_myTableView) {
        [_myTableView removeFromSuperview];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if (_searchBar.text.length < 6 || _searchBar.text.length > 11 ) {
        [self showHudWithString:@"请输入6-11位完整的猩ID或者手机号" forSecond:1.5];
    }else{
        [self searchFriend];
    }
    
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
    [_searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    _searchBar.text=nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}

#pragma mark - createTableView -----------------------------------
- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchController.searchBar.frame.origin.y + _searchController.searchBar.height, kWidth, kHeight) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
        
    [self.view addSubview:_myTableView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERongCloudSearchFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERongCloudSearchFriendTableViewCell" owner:self options:nil]lastObject];
    }

    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_headImageStr] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    cell.nameLabel.text = _nicknameStr;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXERongCloudSearchFriendDetailInfoViewController *rongCloudSearchFriendDetailInfoVC = [[XXERongCloudSearchFriendDetailInfoViewController alloc] init];
    
    rongCloudSearchFriendDetailInfoVC.iconStr = _headImageStr;
    rongCloudSearchFriendDetailInfoVC.nicknameStr = _nicknameStr;
    rongCloudSearchFriendDetailInfoVC.xidStr = _xidStr;
    
    [self.navigationController pushViewController:rongCloudSearchFriendDetailInfoVC animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
