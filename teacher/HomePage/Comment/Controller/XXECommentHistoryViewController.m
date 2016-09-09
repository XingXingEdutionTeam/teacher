



//
//  XXECommentHistoryViewController.m
//  teacher
//
//  Created by Mac on 16/8/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//


#import "XXECommentHistoryViewController.h"
//#import "XXECommentRequestTableViewCell.h"
#import "XXERedFlowerSentHistoryTableViewCell.h"
#import "XXECommentRequestModel.h"
#import "XXECommentRequestApi.h"
#import "XXERedFlowerSentHistoryViewController.h"
#import "XXECommentHistoryDetailInfoViewController.h"

#import "XXEUserInfo.h"


@interface XXECommentHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    //传参 xid
    NSString *parameterXid;
    //传参 user_id
    NSString *parameterUser_Id;
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
    
    [_myTableView.header beginRefreshing];
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
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    XXECommentRequestApi *commentRequestApi = [[XXECommentRequestApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE class_id:_classId require_con:@"1" page:pageStr];
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
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
    
    }
    [_myTableView reloadData];
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    
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
    XXECommentRequestModel *model = _dataSourceArray[indexPath.row];
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
    
    cell.titleLabel.text = model.baby_tname;
    
    cell.contentLabel.text = [NSString stringWithFormat:@"点评内容: %@", model.com_con];

    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.com_tm];
    if([model.collect_condit isEqualToString:@"2"]){
        [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"home_logo_registerteacher_uncollect_icon36x32"] forState:UIControlStateNormal];
    }else if([model.collect_condit isEqualToString:@"1"]){
        [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"home_logo_registerteacher_collect_icon36x32"] forState:UIControlStateNormal];
    }
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
    commentHistoryDetailInfoVC.collect_conditStr = model.collect_condit;
    commentHistoryDetailInfoVC.collect_id = model.commentId;
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

