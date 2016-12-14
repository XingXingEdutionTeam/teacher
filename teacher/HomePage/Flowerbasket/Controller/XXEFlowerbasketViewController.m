



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
    
    //
    UIImageView *placeholderImageView;
    
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
    
    [_myTableView.header beginRefreshing];
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
    if ([XXEUserInfo user].login) {
        XXEAccountManagerViewController *XXEAccountManagerVC = [[XXEAccountManagerViewController alloc] init];
        
        [self.navigationController pushViewController:XXEAccountManagerVC animated:YES];
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
    }

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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    

}

-(void)loadNewData{
    page ++ ;
    
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
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    cell.nameLabel.text = model.tname;
    cell.numberLabel.text = [NSString stringWithFormat:@"数量:%@   订单号:%@", model.num, model.idStr];
    cell.contentLabel.text = [NSString stringWithFormat:@"赠言:%@", model.con];
//    cell.contentLabel.numberOfLines
    CGFloat height = [StringHeight contentSizeOfString:model.con maxWidth:KScreenWidth - 100 * kScreenRatioWidth fontSize:14];
    
    CGSize size = cell.contentLabel.size;
    size.height = height;
    cell.contentLabel.size = size;
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXEFlowerbasketModel *model = _dataSourceArray[indexPath.row];
    if (![model.con isEqualToString:@""]) {
        CGFloat height = [StringHeight contentSizeOfString:model.con maxWidth:KScreenWidth - 70 fontSize:14];
        
        return 70 + height;
    }else{
        return 80;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.00001;
}

@end
