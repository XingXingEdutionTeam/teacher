



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

@interface XXECommentHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    
}


@end

@implementation XXECommentHistoryViewController

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
    //标题
    self.title = @"点评请求";
    //自定义  tabbar视图
//    [self createBottomView];
    
    //    [self fetchNetData];
    
    [self createTableView];
    
}


- (void)createBottomView{
    
    UIImageView *bottomView= [[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 64 - 49, KScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.userInteractionEnabled =YES;
    
    CGFloat itemWidth = KScreenWidth / 3;
    CGFloat itemHeight = 49;
    
    CGFloat buttonWidth = itemWidth;
    CGFloat buttonHeight = itemHeight;
    
    //----------------------------请求 点评
    UIButton *commentRequestButton = [self createButtonFrame:CGRectMake(buttonWidth / 2 * 0, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"comment_tabbar_request_unseleted_icon" seletedImageName:@"comment_tabbar_request_seleted_icon" title:@"请求点评" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(commentRequestButtonClick:)];
    [commentRequestButton setBackgroundColor:[UIColor redColor]];
    //设置 图片 位置
    commentRequestButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    commentRequestButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -commentRequestButton.titleLabel.bounds.size.width-30, 0, 0);
    [bottomView addSubview:commentRequestButton];
    
    //---------------------------点评 历史
    UIButton *commentHistoryButton = [self createButtonFrame:CGRectMake(buttonWidth, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"comment_tabbar_history_unseleted_icon" seletedImageName:@"comment_tabbar_history_seleted_icon" title:@"点评历史" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(commentHistoryButtonClick:)];
    [commentHistoryButton setBackgroundColor:[UIColor yellowColor]];
    //设置 图片 位置
    commentHistoryButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    commentHistoryButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -commentHistoryButton.titleLabel.bounds.size.width-30, 0, 0);
    [bottomView addSubview:commentHistoryButton];
    
    //--------------------------------小红花
    UIButton *commentFlowerButton = [self createButtonFrame:CGRectMake(buttonWidth * 2, 2 * kScreenRatioHeight, buttonWidth, buttonHeight) unseletedImageName:@"comment_tabbar_flower_unseleted_icon" seletedImageName:@"comment_tabbar_flower_seleted_icon" title:@"小红花" unseletedTitleColor:[UIColor lightGrayColor] seletedTitleColor:XXEColorFromRGB(0, 170, 42) font:[UIFont systemFontOfSize:10] target:self action:@selector(commentFlowerButtonClick:)];
    [commentFlowerButton setBackgroundColor:[UIColor blueColor]];
    //设置 图片 位置
    commentFlowerButton.imageEdgeInsets = UIEdgeInsetsMake(-10 * kScreenRatioHeight, buttonWidth / 2 - 30 * kScreenRatioWidth, 0, 0);
    //设置title在button上的位置（上top，左left，下bottom，右right）
    commentFlowerButton.titleEdgeInsets = UIEdgeInsetsMake(30 * kScreenRatioHeight, -commentFlowerButton.titleLabel.bounds.size.width-20, 0, 0);
    
    [bottomView addSubview:commentFlowerButton];
    
}

//点评 请求
- (void)commentRequestButtonClick:(UIButton *)button{
    
//    NSLog(@"点评 请求");
//    [self.navigationController popViewControllerAnimated:NO];
    
}

//点评 历史
- (void)commentHistoryButtonClick:(UIButton *)button{
    
//    NSLog(@"点评 历史");
    
}

//小红花
- (void)commentFlowerButtonClick:(UIButton *)button{
    
//    NSLog(@"小红花");
//    XXERedFlowerSentHistoryViewController *redFlowerSentHistoryVC = [[XXERedFlowerSentHistoryViewController alloc] init];
//    
//    [self.navigationController pushViewController:redFlowerSentHistoryVC animated:NO];
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
    cell.contentLabel.text = [NSString stringWithFormat:@"请求内容: %@", model.ask_con];
    //    [condit] => 1		//点评状态  0:家长发送的请求 (待老师点评), 1:老师已点评
    if ([model.condit isEqualToString:@"0"]) {
        cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.ask_tm];
        
        cell.stateImageView.image = [UIImage imageNamed:@"comment_state_uncommented_icon"];
    }else if ([model.condit isEqualToString:@"1"]){
        cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.com_tm];
        cell.stateImageView.image = [UIImage imageNamed:@"comment_state_commented_icon"];
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
    
    //    XXERedFlowerDetialViewController *redFlowerDetialVC = [[XXERedFlowerDetialViewController alloc] init];
    //
    //    XXERedFlowerSentHistoryModel *model = _dataSourceArray[indexPath.row];
    //    redFlowerDetialVC.name = model.tname;
    //    redFlowerDetialVC.time = model.date_tm;
    //    redFlowerDetialVC.schoolName = model.school_name;
    //    redFlowerDetialVC.className = model.class_name;
    //    redFlowerDetialVC.course = model.teach_course;
    //    redFlowerDetialVC.content = model.con;
    //    redFlowerDetialVC.picWallArray = model.pic_arr;
    //    redFlowerDetialVC.iconUrl = model.head_img;
    //    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];
    
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

