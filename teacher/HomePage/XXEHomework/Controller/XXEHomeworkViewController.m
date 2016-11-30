


//
//  XXEHomeworkViewController.m
//  teacher
//
//  Created by Mac on 16/8/18.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHomeworkViewController.h"
#import "XXEHomeworkTableViewCell.h"
#import "XXEHomeworkModel.h"
#import "XXEHomeworkApi.h"
#import "XXEHomeworkDetailInfoViewController.h"
#import "XXEHomeworkIssueViewController.h"



@interface XXEHomeworkViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    
    UIView *headerView;
    NSString * courseNameStr;
    NSString * dateNameStr;
    UIImageView *placeholderImageView;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property(nonatomic,strong)WJCommboxView *courseCombox;
@property(nonatomic,strong)WJCommboxView *dateNameCombox;
@property(nonatomic,strong)UIView *courseBgView;
@property(nonatomic,strong)UIView *monthBgView;

//科目
@property(nonatomic,strong)NSMutableArray *teach_course_groupArray;
//月份
@property(nonatomic,strong)NSMutableArray *month_groupArray;
//作业
@property(nonatomic,strong)NSArray *homework_listArray;
//作业 状态 图标
@property(nonatomic,strong)NSMutableArray *stateImageViewArray;

//科目
@property(nonatomic,strong)NSMutableArray *cityArray;
//月份
@property(nonatomic,strong)NSMutableArray *areaArray;

//bool值 判断 是否 是第一次 获取  数据
@property (nonatomic, assign) BOOL firstFetchNetData;

@end

@implementation XXEHomeworkViewController

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
    _firstFetchNetData = YES;
    
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


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.courseCombox.textField removeObserver:self forKeyPath:@"text" context:@"1"];
    [self.dateNameCombox.textField removeObserver:self forKeyPath:@"text" context:@"2"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self addHeadView];

    //[condit] => 3		//状态 1:急  2:写  3:新  4:结
    _stateImageViewArray = [[NSMutableArray alloc] initWithObjects:@"homework_urgent_icon", @"homework_write_icon", @"homework_new_icon", @"homework_end_icon", nil];
    
    courseNameStr = @"";
    dateNameStr = @"";
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"作业";
    //发布 作业 图标
    UIButton *issueBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(issueBtnClick:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:issueBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    [self createTableView];
    [self createHeaderView];
}



- (void)issueBtnClick:(UIButton *)button{
    
    XXEHomeworkIssueViewController *homeworkIssueVC = [[XXEHomeworkIssueViewController alloc] init];
    
//    homeworkIssueVC.schoolId = _schoolId;
//    homeworkIssueVC.classId = _classId;
    
    [self.navigationController pushViewController:homeworkIssueVC animated:YES];
    
}

- (void)fetchNetData{
    /*
     【班级作业】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Parent/class_homework_list
     
     传参:
     school_id	//学校id (测试值:1)
     class_id	//班级 (测试值:1)
     page		//页码(加载更多,不传值默认1,测试时每页加载6个)
     teach_course	//科目,筛选用,例如:英语
     month		//月份,筛选用,例如:3
     
     注:筛选时,学校id,班级id 2个传参都不能少*/
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
//    NSLog(@"%@ --- %@", _schoolId, _classId);
    
    XXEHomeworkApi *homeworkApi = [[XXEHomeworkApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId class_id:_classId page:pageStr teach_course:courseNameStr month:dateNameStr];
    [homeworkApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            _teach_course_groupArray = [[NSMutableArray alloc] init];
            _month_groupArray = [[NSMutableArray alloc] init];
            _homework_listArray = [[NSArray alloc] init];
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            if (_firstFetchNetData == YES) {
                _firstFetchNetData = NO;
                //科目
                [_teach_course_groupArray addObject:@"全部"];
                [_teach_course_groupArray addObjectsFromArray:dict[@"teach_course_group"]];
                
                //月份
                [_month_groupArray addObject:@"全部"];
                [_month_groupArray addObjectsFromArray:dict[@"month_group"]];
            }
            //作业 列表
            _homework_listArray = [XXEHomeworkModel parseResondsData:dict[@"homework_list"]];
            
            [_dataSourceArray addObjectsFromArray:_homework_listArray];
        }else{
            
        }

        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
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
        if (_teach_course_groupArray.count != 0) {
        self.courseCombox.dataArray = _teach_course_groupArray;
        [self.courseCombox.listTableView reloadData];
        
        }
        if (_month_groupArray.count != 0) {
        self.dateNameCombox.dataArray = _month_groupArray;
        [self.dateNameCombox.listTableView reloadData];
        }
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
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    
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
    XXEHomeworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEHomeworkTableViewCell" owner:self options:nil]lastObject];
    }
    
//    cell.iconImageView.frame.size.width = 75;
//    cell.iconImageView.frame.size.height = 75;
    
    XXEHomeworkModel *model = _dataSourceArray[indexPath.row];
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
    cell.nameLabel.text = model.tname;
    cell.courseLabel.text = model.teach_course;
    cell.subjectLabel.text = model.title;
    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:model.date_tm];
    //[condit] => 3		//状态 1:急  2:写  3:新  4:结
    NSInteger stateNum = [model.condit integerValue];
    cell.stateImageView.image = [UIImage imageNamed:_stateImageViewArray[stateNum - 1]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}

- (void)createHeaderView{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 34)];
    headerView.backgroundColor = [UIColor whiteColor];
    _myTableView.tableHeaderView = headerView;
    headerView.userInteractionEnabled = YES;
    
    //----------------------科目 下拉框
    self.courseCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(0, 2, kWidth/2, 30)];
    self.courseCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.courseCombox.textField.placeholder = @"科目";
    self.courseCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.courseCombox.textField.tag = 1001;
    
    [headerView addSubview:self.courseCombox];
    //监听
    [self.courseCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"1"];
    
    self.courseBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    self.courseBgView.backgroundColor = [UIColor clearColor];
    self.courseBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.courseBgView addGestureRecognizer:singleTouch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    //-------------------月份 下拉框
    self.dateNameCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(kWidth/2, 2, kWidth/2, 30)];
    self.dateNameCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.dateNameCombox.textField.placeholder =@"月份";
    self.dateNameCombox.textField.textAlignment =NSTextAlignmentLeft;
    self.dateNameCombox.textField.tag =1002;

    [headerView addSubview:self.dateNameCombox];
    //监听
    [self.dateNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"2"];

    self.monthBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight+300)];
    self.monthBgView.backgroundColor = [UIColor clearColor];
    self.monthBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHi)];
    [self.monthBgView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 1001:
        {
            
            [self.courseCombox removeFromSuperview];
            
            [_myTableView addSubview:self.courseBgView];
            [_myTableView addSubview:self.courseCombox];
            
        }
            break;
        case 1002:
        {
            
            [self.dateNameCombox removeFromSuperview];
            [_myTableView addSubview:self.monthBgView];
            [_myTableView addSubview:self.dateNameCombox];
        }
            break;
        default:
            break;
    }
    
}


- (void)commboxHidden{
    
    [self.courseBgView removeFromSuperview];
    [self.courseCombox setShowList:NO];
    self.courseCombox.listTableView.hidden = YES;
    
}
- (void)commboxHi{
    
    [self.monthBgView removeFromSuperview];
    [self.dateNameCombox setShowList:NO];
    self.dateNameCombox.listTableView.hidden = YES;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 34;
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataSourceArray.count != 0) {
        XXEHomeworkModel *model = _dataSourceArray[indexPath.row];
        
        XXEHomeworkDetailInfoViewController *homeworkDetailInfoVC = [[XXEHomeworkDetailInfoViewController alloc] init];
        homeworkDetailInfoVC.homeworkId = model.homeworkId;
        [self.navigationController pushViewController:homeworkDetailInfoVC animated:YES];
    }
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    [_dataSourceArray removeAllObjects];
    
    //    筛选的时候 让 page =  1
    page = 1;
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 1:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                
                if ([newName isEqualToString:@"全部"]) {
                    courseNameStr = @"";
                }
                else{
                    courseNameStr = newName;
                }
                
                [self fetchNetData];
            }
            
        }
            break;
        case 2:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                
                
                if ([newName isEqualToString:@"全部"]) {
                    dateNameStr = @"";
                }
                else{
                    dateNameStr = newName;
                }
                
                [self fetchNetData];
            }
            
        }
            break;
        default:
            break;
    }
}




@end
