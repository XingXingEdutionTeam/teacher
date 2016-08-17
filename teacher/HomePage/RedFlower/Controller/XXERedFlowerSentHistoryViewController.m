



//
//  XXERedFlowerSentHistoryViewController.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERedFlowerSentHistoryViewController.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXERedFlowerSentHistoryModel.h"
#import "XXERedFlowerSentHistoryApi.h"
#import "XXERedFlowerDetialViewController.h"
#import "XXESentToPeopleViewController.h"

@interface XXERedFlowerSentHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    
    //已赠花篮数量
    NSString *give_num;
    //剩余花篮数量
    NSString *flower_able;
    
}


@end

@implementation XXERedFlowerSentHistoryViewController

- (void)viewWillAppear:(BOOL)animated{
    _dataSourceArray = [[NSMutableArray alloc] init];
    
    page = 0;
    
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.mj_header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"小红花";
    
    UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_redflower_sent" Target:self Action:@selector(sent:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    //    [self fetchNetData];
    
    [self createTableView];
    
}



- (void)sent:(UIButton *)button{

    XXESentToPeopleViewController *sentToPeopleVC = [[XXESentToPeopleViewController alloc] init];
    
    sentToPeopleVC.schoolId = _schoolId;
    sentToPeopleVC.classId = _classId;
    sentToPeopleVC.basketNumStr = flower_able;
    
    [self.navigationController pushViewController:sentToPeopleVC animated:YES];
    
}

- (void)fetchNetData{
    /*
     【小红花->赠送记录列表】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/give_flower_msg
     
     传参:
     
     page	//页码(加载更多,默认1)     */
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXERedFlowerSentHistoryApi *redFlowerSentHistoryApi = [[XXERedFlowerSentHistoryApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE page:pageStr];
    [redFlowerSentHistoryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//                NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {

        NSDictionary *dict = request.responseJSONObject[@"data"];
            //已赠花篮数量
            give_num = dict[@"give_num"];
            
            //剩余花篮 数量
            flower_able = dict[@"flower_able"];
            
            NSArray *modelArray = [XXERedFlowerSentHistoryModel parseResondsData:dict[@"list"]];

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
    page ++;
    
    [self fetchNetData];
    [ _myTableView.mj_header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_footer endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _myTableView.mj_footer endRefreshing];
    
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
    XXERedFlowerSentHistoryModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
    
//    NSLog(@"课程  %@", model.teach_course);
    
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@", model.tname, model.teach_course, model.class_name];
    cell.contentLabel.text = [NSString stringWithFormat:@"赠言:%@", model.con];
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat labelWidth = KScreenWidth / 3;
    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(0, 5, labelWidth, 20) Font:14 Text:@"历史记录"];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel1];
    
    UILabel *titleLabel2 = [UILabel createLabelWithFrame:CGRectMake(labelWidth, 5, labelWidth, 20) Font:14 Text:[NSString stringWithFormat:@"已颁发:%@朵", give_num]];
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel2];
    
    UILabel *titleLabel3 = [UILabel createLabelWithFrame:CGRectMake(labelWidth * 2, 5, labelWidth, 20) Font:14 Text:[NSString stringWithFormat:@"剩余:%@朵", flower_able]];
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel3];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    XXERedFlowerDetialViewController *redFlowerDetialVC = [[XXERedFlowerDetialViewController alloc] init];
    
    XXERedFlowerSentHistoryModel *model = _dataSourceArray[indexPath.row];
    redFlowerDetialVC.name = model.tname;
    redFlowerDetialVC.time = model.date_tm;
    redFlowerDetialVC.schoolName = model.school_name;
    redFlowerDetialVC.className = model.class_name;
    redFlowerDetialVC.course = model.teach_course;
    redFlowerDetialVC.content = model.con;
    redFlowerDetialVC.picWallArray = model.pic_arr;
    redFlowerDetialVC.iconUrl = model.head_img;
    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];

}


@end