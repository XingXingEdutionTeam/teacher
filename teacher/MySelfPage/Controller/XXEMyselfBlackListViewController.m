

//
//  XXEMyselfBlackListViewController.m
//  teacher
//
//  Created by Mac on 16/9/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfBlackListViewController.h"
#import "XXEBlackListTableViewCell.h"
#import "XXEMyselfBlackListModel.h"
#import "XXEBatchRemoveFromBlackListApi.h"
#import "XXEBlackListApi.h"

@interface XXEMyselfBlackListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    //
    NSMutableArray *removeXidArray;
    NSInteger t;
    
    NSString *other_xid;
    
}


@end

@implementation XXEMyselfBlackListViewController

- (void)viewWillAppear:(BOOL)animated{

    
    page = 0;
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户";
    
    [self createTableView];
    [self createRightBar];
    
}

- (void)createRightBar{

    UIButton *rightBtn =[UIButton createButtonWithFrame:CGRectMake(0,0,22,22) backGruondImageName:@"remove_icon44x44" Target:self Action:@selector(rightBtnClick:) Title:nil];
    UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =rightBar;
    
}

- (void)rightBtnClick:(UIButton *)rightBtnClick{
    if (removeXidArray.count == 0) {
        [self showHudWithString:@"请选择要移除的人" forSecond:1.5];
    }else{
        [self removePersonFromBlackList];
    }
}


- (void)removePersonFromBlackList{

//    NSLog(@"移除 ");
    
    if (removeXidArray.count == 1) {
        other_xid = removeXidArray[0];
    }else if (removeXidArray.count > 1){
        
        NSMutableString *tidStr = [NSMutableString string];
        
        for (int j = 0; j < removeXidArray.count; j ++) {
            NSString *str = removeXidArray[j];
            
            if (j != removeXidArray.count - 1) {
                [tidStr appendFormat:@"%@,", str];
            }else{
                [tidStr appendFormat:@"%@", str];
            }
        }
        
        other_xid = tidStr;
    }
    
    XXEBatchRemoveFromBlackListApi *globalPermissionSettingApi = [[XXEBatchRemoveFromBlackListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:other_xid];
    [globalPermissionSettingApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        //        NSLog(@"权限设置 -- %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"移除成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据请求失败!" forSecond:1.5];
    }];


}



- (void)fetchNetData{
    
//    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXEBlackListApi *blackListApi = [[XXEBlackListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    [blackListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        removeXidArray = [[NSMutableArray alloc] init];
        
        //        NSLog(@"111   %@", request.responseJSONObject);
        
        NSDictionary *dict = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dict[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [XXEMyselfBlackListModel parseResondsData:dict[@"data"]];
            [_dataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"请求失败" forSecond:1.f];
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        
    }
    [_myTableView reloadData];
    
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    page ++;
    
    [self fetchNetData];
    [ _myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _myTableView.footer endRefreshing];
    
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
    
    static NSString *identifier = @"cell";
    XXEBlackListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEBlackListTableViewCell" owner:self options:nil]lastObject];
    }
    XXEMyselfBlackListModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *head_img;
    if ([model.head_img_type isEqualToString:@"0"]) {
        head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    }else if ([model.head_img_type isEqualToString:@"1"]){
        head_img = model.head_img;
    }

    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    cell.nameLabel.text = model.nickname;
    cell.ageLabel.text = model.sex;
    cell.selectButton.tag = indexPath.row + 100;
    
    cell.selectButton.layer.cornerRadius = 20 / 2;
    cell.selectButton.layer.masksToBounds = YES;
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"report_unselected_icon"] forState:UIControlStateNormal];
    [cell.selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)selectButtonClick:(UIButton *)button{
    XXEMyselfBlackListModel *model = _dataSourceArray[button.tag - 100];
    if (button.selected ) {
        [button setBackgroundImage:[UIImage imageNamed:@"report_unselected_icon"] forState:UIControlStateNormal];
        button.selected = NO;
        [removeXidArray removeObject:model.xid];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"report_selected_icon"] forState:UIControlStateNormal];
        button.selected = YES;
        [removeXidArray addObject:model.xid];
    
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    XXERedFlowerDetialViewController *redFlowerDetialVC = [[XXERedFlowerDetialViewController alloc] init];
    //
    //    XXEMyselfInfoCollectionRedFlowerModel *model = _dataSourceArray[indexPath.row];
    //    redFlowerDetialVC.name = model.tname;
    //    redFlowerDetialVC.time = [XXETool dateStringFromNumberTimer:model.date_tm];
    //    redFlowerDetialVC.schoolName = model.school_name;
    //    redFlowerDetialVC.className = model.class_name;
    //    redFlowerDetialVC.course = model.teach_course;
    //    redFlowerDetialVC.content = model.con;
    //
    //    if (![model.pic isEqualToString:@""]) {
    //        NSArray * picArr = [model.pic componentsSeparatedByString:@","];
    //        NSLog(@"%@", picArr);
    //
    //        redFlowerDetialVC.picWallArray = picArr;
    //    }
    //
    //    redFlowerDetialVC.iconUrl = model.head_img;
    //    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
