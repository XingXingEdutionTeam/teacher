
//
//  XXEMyselfInfoCollectionRedFlowerViewController.m
//  teacher
//
//  Created by Mac on 16/9/6.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionRedFlowerViewController.h"
#import "XXEMyselfInfoCollectionRedFlowerApi.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXEMyselfInfoCollectionRedFlowerModel.h"
#import "XXERedFlowerDetialViewController.h"
#import "XXEMyselfInfoDecollectionApi.h"


@interface XXEMyselfInfoCollectionRedFlowerViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    UIImageView *placeholderImageView;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    NSString *_collectionId;
}


@end

@implementation XXEMyselfInfoCollectionRedFlowerViewController

- (void)viewWillAppear:(BOOL)animated{
    _dataSourceArray = [[NSMutableArray alloc] init];
    
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
    
    self.title = @"小红花";
    
    [self createTableView];
    
}


- (void)fetchNetData{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXEMyselfInfoCollectionRedFlowerApi *myselfInfoCollectionRedFlowerApi = [[XXEMyselfInfoCollectionRedFlowerApi alloc] initWithXid:parameterXid user_id:parameterUser_Id page:pageStr return_param_all:@""];
    [myselfInfoCollectionRedFlowerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"111   %@", request.responseJSONObject);
        
        NSDictionary *dict = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dict[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [XXEMyselfInfoCollectionRedFlowerModel parseResondsData:dict[@"data"][@"list"]];
            
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
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [_myTableView reloadData];
    
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
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
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
    XXERedFlowerSentHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerSentHistoryTableViewCell" owner:self options:nil]lastObject];
    }
    XXEMyselfInfoCollectionRedFlowerModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    //    NSLog(@"课程  %@", model.teach_course);
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@", model.tname, model.teach_course, model.class_name];
    cell.contentLabel.text = [NSString stringWithFormat:@"赠言:%@", model.con];
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}

- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"取消收藏？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
#pragma mark - 取消收藏=================================================
        XXERedFlowerSentHistoryTableViewCell *cell = (XXERedFlowerSentHistoryTableViewCell *)[longPress.view superview];
        
        NSIndexPath *path = [_myTableView indexPathForCell:cell];
        
        XXEMyselfInfoCollectionRedFlowerModel *model = _dataSourceArray[path.row];
        _collectionId = model.collectionId;
        
        [self cancelCollection:path];
    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)cancelCollection:(NSIndexPath *)path{
    /*
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵 7:图片
     */
    
    XXEMyselfInfoDecollectionApi *myselfInfoDecollectionApi = [[XXEMyselfInfoDecollectionApi alloc] initWithXid:parameterXid user_id:parameterUser_Id collect_id:_collectionId collect_type:@"6" return_param_all:@""];
    
    [myselfInfoDecollectionApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//    NSLog(@"同意 2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"取消收藏成功!" forSecond:1.5];

            if (_dataSourceArray.count != 0) {
                [_dataSourceArray removeAllObjects];
            }
            page = 1;
        }else{
            [self showHudWithString:@"取消收藏失败!" forSecond:1.5];
        }
        
        [self fetchNetData];
        [_myTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];

    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXERedFlowerDetialViewController *redFlowerDetialVC = [[XXERedFlowerDetialViewController alloc] init];
    
    XXEMyselfInfoCollectionRedFlowerModel *model = _dataSourceArray[indexPath.row];
    redFlowerDetialVC.name = model.tname;
    redFlowerDetialVC.time = [XXETool dateStringFromNumberTimer:model.date_tm];
    redFlowerDetialVC.schoolName = model.school_name;
    redFlowerDetialVC.className = model.class_name;
    redFlowerDetialVC.course = model.teach_course;
    redFlowerDetialVC.content = model.con;
    
    if (![model.pic isEqualToString:@""]) {
        NSArray * picArr = [model.pic componentsSeparatedByString:@","];
//        NSLog(@"%@", picArr);
        
        redFlowerDetialVC.picWallArray = picArr;
    }

    redFlowerDetialVC.iconUrl = model.head_img;
    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
