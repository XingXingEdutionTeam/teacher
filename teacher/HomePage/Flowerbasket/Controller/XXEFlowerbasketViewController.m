



//
//  XXEFlowerbasketViewController.m
//  teacher
//
//  Created by Mac on 16/8/9.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketViewController.h"
#import "XXEFlowerbasketTableViewCell.h"
#import "XXEFlowerbasketModel.h"
#import "XXEFlowerbasketApi.h"
#import "XXEAccountManagerViewController.h"


#define URL @"http://www.xingxingedu.cn/Teacher/give_fbasket_record"


@interface XXEFlowerbasketViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_myTableView;

    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEFlowerbasketViewController

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
    
    [_myTableView.mj_header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"花篮";
    
    UIButton *sentBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 42, 25) backGruondImageName:@"home_flowerbasket_withdrawIcon72x44" Target:self Action:@selector(sent:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:sentBtn];
    self.navigationItem.rightBarButtonItem =sentItem;

//    [self fetchNetData];
    
    [self createTableView];

}



- (void)sent:(UIButton *)button{
#warning 访客登录 不允许 提现-----------------------------
    XXEAccountManagerViewController *XXEAccountManagerVC = [[XXEAccountManagerViewController alloc] init];
    
    [self.navigationController pushViewController:XXEAccountManagerVC animated:YES];
    
}

- (void)fetchNetData{
        /*
         【花篮->赠送记录列表】
    
         接口类型:1
    
         接口:
         http://www.xingxingedu.cn/Teacher/give_fbasket_record
    
         传参:
         page	//页码(加载更多,默认1)
         */
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    XXEFlowerbasketApi *flowerbasketApi = [[XXEFlowerbasketApi alloc] initWithUrlString:URL appkey:APPKEY backtype:BACKTYPE xid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE page:pageStr];
    [flowerbasketApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"111   %@", request.responseJSONObject);
        
                NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
                if ([codeStr isEqualToString:@"1"]) {
                    NSArray *modelArray = [XXEFlowerbasketModel parseResondsData:request.responseJSONObject[@"data"]];
        
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    

}

-(void)loadNewData{
    page ++ ;
    
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
    XXEFlowerbasketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEFlowerbasketTableViewCell" owner:self options:nil]lastObject];
    }
    XXEFlowerbasketModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString * head_img;
    if([[NSString stringWithFormat:@"%@",model.head_img_type]isEqualToString:@"0"]){
        head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    }else{
        head_img = model.head_img;
    }
    
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
    cell.nameLabel.text = model.tname;
    cell.numberLabel.text = [NSString stringWithFormat:@"数量:%@", model.num];
    cell.contentLabel.text = [NSString stringWithFormat:@"赠言:%@", model.con];
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.00001;
}

@end
