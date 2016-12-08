

//
//  XXESotreGoodsCollectionViewController.m
//  teacher
//
//  Created by Mac on 2016/11/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESotreGoodsCollectionViewController.h"
#import "XXESotreGoodsCollectionTableViewCell.h"
#import "XXESotreGoodsCollectionModel.h"
#import "XXEStoreGoodDetailInfoViewController.h"


@interface XXESotreGoodsCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    //占位图
    UIImageView *placeholderImageView;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXESotreGoodsCollectionViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_dataSourceArray.count != 0) {
        [_dataSourceArray removeAllObjects];
    }
    
    //    page = 0;
    [self fetchNetData];
    
    [_myTableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    _dataSourceArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
//    [self fetchNetData];
    
    [self createTableView];
    
}

- (void)fetchNetData{
    /*
     【猩猩商城--我收藏的商品列表】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/collect_goods_show
     传参:*/
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/collect_goods_show";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//                NSLog(@"hhhh %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            
            NSArray *modelArray = [[NSArray alloc] init];
            
            modelArray = [XXESotreGoodsCollectionModel parseResondsData:responseObj[@"data"]];
            
            if (_dataSourceArray.count != 0) {
                [_dataSourceArray removeAllObjects];
            }
            
            [_dataSourceArray addObjectsFromArray:modelArray];
            
        }
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
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
    XXESotreGoodsCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXESotreGoodsCollectionTableViewCell" owner:self options:nil]lastObject];
    }
    XXESotreGoodsCollectionModel *model = _dataSourceArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, model.pic]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    //    NSLog(@"课程  %@", model.teach_course);
    cell.nameLabel.text = model.title;
    cell.nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    cell.iconNumLabel.text = model.exchange_coin;
    cell.dateLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXEStoreGoodDetailInfoViewController*storeGoodDetailInfoVC=  [[XXEStoreGoodDetailInfoViewController alloc]init];
    XXESotreGoodsCollectionModel *model = _dataSourceArray[indexPath.row];
    storeGoodDetailInfoVC.orderNum=model.good_id;
    [self.navigationController pushViewController:storeGoodDetailInfoVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
