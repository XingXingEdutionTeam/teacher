



//
//  XXECommentHistoryViewController.m
//  teacher
//
//  Created by Mac on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//


#import "XXECommentHistoryViewController.h"
#import "XXECommentRequestTableViewCell.h"
#import "XXECommentRequestModel.h"
#import "XXECommentRequestApi.h"
#import "XXERedFlowerSentHistoryViewController.h"
#import "XXECommentHistoryDetailInfoViewController.h"



@interface XXECommentHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    
}


@end

@implementation XXECommentHistoryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    //标题
    self.title = @"点评请求";

    
    [self createTableView];
    
}




- (void)fetchNetData{
    /*
     【点评->点评列表(含请求和历史)】 ★注:详情页没有接口,从这里的数据传递
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/teacher_com_msg
     
     
     传参:
     class_id	//班级id
     require_con	//请求数据内容 1:点评历史,2:请求点评
     page		//页码默认1 (加载更多)    */
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    if (_classId == nil) {
        _classId = @"";
    }
    
    XXECommentRequestApi *commentRequestApi = [[XXECommentRequestApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE class_id:_classId require_con:@"1" page:pageStr];
    [commentRequestApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXECommentRequestModel parseResondsData:request.responseJSONObject[@"data"]];
            //
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    
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
    XXECommentRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXECommentRequestTableViewCell" owner:self options:nil]lastObject];
    }
    XXECommentRequestModel *model = _dataSourceArray[indexPath.row];
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
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@", model.baby_tname, model.relation_name];
    
    cell.contentLabel.text = [NSString stringWithFormat:@"点评内容: %@", model.com_con];

    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.com_tm];
    cell.stateImageView.image = [UIImage imageNamed:@"comment_state_commented_icon"];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        XXECommentHistoryDetailInfoViewController *commentHistoryDetailInfoVC = [[XXECommentHistoryDetailInfoViewController alloc] init];
    
        XXECommentRequestModel *model = _dataSourceArray[indexPath.row];
        commentHistoryDetailInfoVC.name = model.baby_tname;
        commentHistoryDetailInfoVC.ask_con = model.ask_con;
        commentHistoryDetailInfoVC.ask_time = model.ask_tm;
        commentHistoryDetailInfoVC.com_con = model.com_con;
        commentHistoryDetailInfoVC.picString = model.com_pic;
        commentHistoryDetailInfoVC.type = model.type;
    
        [self.navigationController pushViewController:commentHistoryDetailInfoVC animated:YES];
    
}

-(UIButton *)createButtonFrame:(CGRect)frame unseletedImageName:(NSString *)unseletedImageName seletedImageName:(NSString *)seletedImageName title:(NSString *)title unseletedTitleColor:(UIColor *)unseletedTitleColor seletedTitleColor:(UIColor *)seletedTitleColor font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    //未选中 时 图片
    if (unseletedImageName)
    {
        [btn setImage:[UIImage imageNamed:unseletedImageName] forState:UIControlStateNormal];
    }
    //选中 时 图片
    if (seletedImageName)
    {
        UIImage *commentSeletedImage = [UIImage imageNamed:seletedImageName];
        commentSeletedImage = [commentSeletedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [btn setImage:commentSeletedImage forState:UIControlStateSelected];
    }
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    //未选中 时 标题 颜色
    if (unseletedTitleColor)
    {
        [btn setTitleColor:unseletedTitleColor forState:UIControlStateNormal];
    }
    //选中 时 标题 颜色
    if (seletedTitleColor)
    {
        [btn setTitleColor:seletedTitleColor forState:UIControlStateSelected];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}




@end

