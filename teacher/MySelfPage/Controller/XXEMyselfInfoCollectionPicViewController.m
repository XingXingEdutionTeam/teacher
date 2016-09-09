

//
//  XXEMyselfInfoCollectionPicViewController.m
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfInfoCollectionPicViewController.h"
#import "XXEMyselfInfoCollectionPicTableViewCell.h"
#import "XXEMyselfInfoCollectionPicModel.h"
#import "XXEMyselfInfoCollectionPicApi.h"




@interface XXEMyselfInfoCollectionPicViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEMyselfInfoCollectionPicViewController

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
    self.title = @"点评";
    
    [self createTableView];
    
}


- (void)fetchNetData{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXEMyselfInfoCollectionPicApi *myselfInfoCollectionPicApi = [[XXEMyselfInfoCollectionPicApi alloc] initWithXid:parameterXid user_id:parameterUser_Id page:pageStr];
    [myselfInfoCollectionPicApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//                    NSLog(@"111   %@", request.responseJSONObject);
        
        NSDictionary *dict = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dict[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSArray *modelArray = [XXEMyselfInfoCollectionPicModel parseResondsData:dict[@"data"]];
            
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49) style:UITableViewStyleGrouped];
    
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
    XXEMyselfInfoCollectionPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEMyselfInfoCollectionPicTableViewCell" owner:self options:nil]lastObject];
    }
    XXEMyselfInfoCollectionPicModel *model = _dataSourceArray[indexPath.row];
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, model.pic]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
    
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