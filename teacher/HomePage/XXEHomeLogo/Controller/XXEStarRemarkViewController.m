

//
//  XXEStarRemarkViewController.m
//  teacher
//
//  Created by Mac on 16/8/31.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStarRemarkViewController.h"
#import "XXEStarRemarkTableViewCell.h"
#import "XXEStarRemarkModel.h"
#import "XXEStarRemarkApi.h"


@interface XXEStarRemarkViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    UIImageView *starImageView;
    UIView *starView;
    //照片墙 的图片 可以排列几行
    NSInteger picRow;
    //照片墙 照片 宽
    CGFloat picWidth;
    //照片墙 照片 高
    CGFloat picHeight;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXEStarRemarkViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
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
    
    [_myTableView.mj_header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    
}

- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Global/sch_course_comment
     
     传参:
     school_id		//学校id  //测试阶段 7/8/10  有数据
     page			//页码(加载更多),不传参默认1
     */
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
//    NSLog(@"***  %@", _schoolId);
    
    XXEStarRemarkApi *starRemarkApi = [[XXEStarRemarkApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:@"7" page:pageStr];
    [starRemarkApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//            NSLog(@"2222---   %@", request.responseJSONObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            NSArray *modelArray = [XXEStarRemarkModel parseResondsData:dict];
            
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
    XXEStarRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEStarRemarkTableViewCell" owner:self options:nil]lastObject];
    }
    XXEStarRemarkModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     判断是否是第三方头像
     */
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
    cell.nameLabel.text = model.nickname;
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    cell.contentTextView.text = model.con;
    //************************  评分  ******************
    CGFloat k = [model.school_score doubleValue] ;
    CGFloat i;
    
    starView  = [[UIView alloc] initWithFrame:CGRectMake(120 + 16, 47, 80, 16)];
    
    for ( i = 0; i < 5; i++) {
        
        starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16 * i , 0, 16, 16)];
        
        starImageView.image = [UIImage imageNamed:@"home_logo_star_icon32x32"];
        
        [starView addSubview:starImageView];
    }
    
    [cell.contentView addSubview:starView];
    
    CGRect rect = starView.frame;
    rect.size.width = starView.frame.size.width / 5 * k;
    starView.frame = rect;
    
    //设置填充模式为靠左
    starView.contentMode = UIViewContentModeLeft;
    //超出边界剪切掉
    starView.clipsToBounds = YES;
    
    //*********************   照片   ********************
    picHeight = 0;
    picRow = 0;
    picWidth = 0;
    
    if (model.pic_arr.count == 0) {
        cell.picLabel.hidden = YES;
    }else{
        
        if (model.pic_arr.count % 5 == 0) {
            picRow = model.pic_arr.count / 5;
        }else{
            picRow = model.pic_arr.count / 5 + 1;
        }
        //创建 十二宫格  三行、四列
        int margin = 10;
        picWidth = (KScreenWidth - 6 * margin) / 5;
        picHeight = picWidth;
        
        for (int i = 0; i < model.pic_arr.count; i++) {
            
            //行
            int buttonRow = i / 5;
            
            //列
            int buttonLine = i % 5;
            
            CGFloat buttonX = (picWidth + margin) * buttonLine;
            CGFloat buttonY = 120 + (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90 * kScreenRatioWidth + buttonX, buttonY, picWidth, picHeight)];
            
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, model.pic_arr[i]]]];
            pictureImageView.tag = 20 + i;
            pictureImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:pictureImageView];
        }

    }

    return cell;
}


- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    
    //    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
    //    NSMutableArray *imageArr = picMArr;
    //    redFlowerVC.index = tap.view.tag - 20;
    //    redFlowerVC.imageArr = imageArr;
    //    //举报 来源 7:作业图片
    //    redFlowerVC.origin_pageStr = @"7";
    //    redFlowerVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:redFlowerVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    XXEStarRemarkModel *model = _dataSourceArray[indexPath.row];
//    if (<#condition#>) {
//        <#statements#>
//    }
    
    return 120 + picRow * (picHeight + 10);
    
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
    //    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
