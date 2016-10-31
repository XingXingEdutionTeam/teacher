
//
//  XXETransactionRecordsViewController.m
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXETransactionRecordsViewController.h"
#import "XXETransactionRecordsTableViewCell.h"
#import "XXETransactionRecordsModel.h"
#import "XXETransactionRecordsApi.h"


@interface XXETransactionRecordsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXETransactionRecordsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.topItem.title = @"小红花";
    _dataSourceArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    page = 0;

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
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"钱包管理";
    
    UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"myself_icon30x30" Target:self Action:@selector(sent:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    //    [self fetchNetData];
    
    [self createTableView];
    
}



- (void)sent:(UIButton *)button{
    
//    XXESentToPeopleViewController *sentToPeopleVC = [[XXESentToPeopleViewController alloc] init];
//    
//    sentToPeopleVC.schoolId = _schoolId;
//    sentToPeopleVC.classId = _classId;
//    sentToPeopleVC.basketNumStr = _flower_able;
//    sentToPeopleVC.position = _position;
//    [self.navigationController pushViewController:sentToPeopleVC animated:YES];
    
}

- (void)fetchNetData{

    NSString *schoolId = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXETransactionRecordsApi *transactionRecordsApi = [[XXETransactionRecordsApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:schoolId page:pageStr];
    [transactionRecordsApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            NSArray *modelArray = [XXETransactionRecordsModel parseResondsData:dict];
            
            [_dataSourceArray addObjectsFromArray:modelArray];
        }else{
            
        }
        
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
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
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
    XXETransactionRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXETransactionRecordsTableViewCell" owner:self options:nil]lastObject];
    }
    XXETransactionRecordsModel *model = _dataSourceArray[indexPath.row];
    
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    cell.type_nameLabel.text = model.type_name;
    cell.moneyLabel.text = model.money;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    XXERedFlowerDetialViewController *redFlowerDetialVC = [[XXERedFlowerDetialViewController alloc] init];
//    
//    XXERedFlowerSentHistoryModel *model = _dataSourceArray[indexPath.row];
//    redFlowerDetialVC.name = model.tname;
//    redFlowerDetialVC.time = [XXETool dateStringFromNumberTimer:model.date_tm];
//    redFlowerDetialVC.schoolName = model.school_name;
//    redFlowerDetialVC.className = model.class_name;
//    redFlowerDetialVC.course = model.teach_course;
//    redFlowerDetialVC.content = model.con;
//    redFlowerDetialVC.picWallArray = model.pic_arr;
//    redFlowerDetialVC.iconUrl = model.head_img;
//    redFlowerDetialVC.collect_conditStr =model.collect_condit;
//    redFlowerDetialVC.collect_id = model.collectionId;
//    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];
    
}

@end
