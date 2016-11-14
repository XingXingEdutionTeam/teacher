


//
//  XXEStoreConsigneeAddressViewController.m
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreConsigneeAddressViewController.h"
#import "XXEStoreConsigneeAddressTableViewCell.h"
#import "XXEStoreAddressModel.h"

@interface XXEStoreConsigneeAddressViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
//    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEStoreConsigneeAddressViewController

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

//    page = 0;

    [self fetchNetData];
    
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
    
    
    self.title = @"收货地址";
    
    UIButton *addBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"home_flowerbasket_addIcon44x44" Target:self Action:@selector(addBtnClick:) Title:@""];
    UIBarButtonItem *addItem =[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem =addItem;
    
    //
    
    [self createTableView];
    
}



- (void)addBtnClick:(UIButton *)button{
    
//    XXESentToPeopleViewController *sentToPeopleVC = [[XXESentToPeopleViewController alloc] init];
//    
//    sentToPeopleVC.schoolId = _schoolId;
//    sentToPeopleVC.classId = _classId;
//    sentToPeopleVC.basketNumStr = _flower_able;
//    sentToPeopleVC.position = _position;
//    [self.navigationController pushViewController:sentToPeopleVC animated:YES];
    
}

- (void)fetchNetData{
    /*
     【猩猩商城--获取购物地址】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/get_shopping_address
     传参:(测试xid = 18884982)*/
    
//    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_shopping_address";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":@"18884982",
                           @"user_id":@"1",
                           @"user_type":USER_TYPE
                           };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"UUUU %@", responseObj);
        NSString *codeStr = responseObj[@"code"];
        if ([codeStr integerValue] == 1) {
            
            NSArray *arr = [[NSArray alloc] init];
            arr = [XXEStoreAddressModel parseResondsData:responseObj[@"data"]];
            [_dataSourceArray addObjectsFromArray:arr];
            
        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
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
    
//    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    
//    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

//-(void)loadNewData{
////    page ++;
//    
//    [self fetchNetData];
//    [ _myTableView.header endRefreshing];
//}
//-(void)endRefresh{
//    [_myTableView.header endRefreshing];
//    [_myTableView.footer endRefreshing];
//}
//
//- (void)loadFooterNewData{
////    page ++ ;
//    
//    [self fetchNetData];
//    [ _myTableView.footer endRefreshing];
//    
//}


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
    XXEStoreConsigneeAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEStoreConsigneeAddressTableViewCell" owner:self options:nil]lastObject];
    }
    XXEStoreAddressModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    cell.nameLabel.text = model.name;
    cell.phoneLabel.text = model.phone;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", model.province, model.city, model.address];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
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

//滑动 删除 地址
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteFriend:indexPath];

    }
}


- (void)deleteFriend:(NSIndexPath *)path{
    /*
     【猩猩商城--删除购物地址】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/delete_shopping_address
     传参:
     address_id	//地址id
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/delete_shopping_address";
    
    XXEStoreAddressModel *model = _dataSourceArray[path.row];
    
    NSString *address_id = model.address_id;
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":@"18884982",
                             @"user_id":@"1",
                             @"user_type":USER_TYPE,
                             @"address_id":address_id
                             };

    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"删除 地址 %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            [self showHudWithString:@"删除成功!" forSecond:1.5];
            
            [_dataSourceArray removeObjectAtIndex:path.row];
            [_myTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
        }else {
            [self showHudWithString:@"删除失败!" forSecond:1.5];
        }
        
    } failure:^(NSError *error) {
        //
        [self showHudWithString:@"数据获取失败!" forSecond:1.5];
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
