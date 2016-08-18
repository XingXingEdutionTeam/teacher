


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


@interface XXEHomeworkViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    
    UIView *headerView;
    NSString * courseNameStr;
    NSString * dateNameStr;
}

@property(nonatomic,strong)WJCommboxView *courseCombox;
@property(nonatomic,strong)WJCommboxView *dateNameCombox;
@property(nonatomic,strong)UIView *courseBgView;
@property(nonatomic,strong)UIView *monthBgView;

//科目
@property(nonatomic,strong)NSArray *teach_course_groupArray;
//月份
@property(nonatomic,strong)NSArray *month_groupArray;
//作业
@property(nonatomic,strong)NSArray *homework_listArray;
//作业 状态 图标
@property(nonatomic,strong)NSMutableArray *stateImageViewArray;

//科目
@property(nonatomic,strong)NSMutableArray *cityArray;
//月份
@property(nonatomic,strong)NSMutableArray *areaArray;



@end

@implementation XXEHomeworkViewController

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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
//    [self.courseCombox.textField removeObserver:self forKeyPath:@"text"];
//    [self.dateNameCombox.textField removeObserver:self forKeyPath:@"text"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _teach_course_groupArray = [[NSArray alloc] init];
    _month_groupArray = [[NSArray alloc] init];
    _homework_listArray = [[NSArray alloc] init];
    //[condit] => 3		//状态 1:急  2:写  3:新  4:结
    _stateImageViewArray = [[NSMutableArray alloc] initWithObjects:@"homework_urgent_icon", @"homework_write_icon", @"homework_new_icon", @"homework_end_icon", nil];
    
    self.cityArray = [[NSMutableArray alloc]initWithObjects:@"全部",@"英语",@"数学",@"语文",nil];
    self.areaArray = [[NSMutableArray alloc]initWithObjects:@"全部",@"6",@"7",@"8",@"9",@"10",@"11",nil];
    
    courseNameStr = @"0";
    dateNameStr = @"0";
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"作业";
    //发布 作业 图标
    UIButton *issueBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(issueBtnClick:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:issueBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    [self createTableView];
    
}



- (void)issueBtnClick:(UIButton *)button{
    
//    XXESentToPeopleViewController *sentToPeopleVC = [[XXESentToPeopleViewController alloc] init];
//    
//    sentToPeopleVC.schoolId = _schoolId;
//    sentToPeopleVC.classId = _classId;
//    sentToPeopleVC.basketNumStr = _flower_able;
//    
//    [self.navigationController pushViewController:sentToPeopleVC animated:YES];
    
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
    
    XXEHomeworkApi *homeworkApi = [[XXEHomeworkApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId class_id:_classId page:pageStr teach_course:@"" month:@""];
    [homeworkApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//     NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            //科目
            _teach_course_groupArray = dict[@"teach_course_group"];
            
            //月份
            _month_groupArray = dict[@"month_group"];
            
            //作业 列表
            _homework_listArray = [XXEHomeworkModel parseResondsData:dict[@"homework_list"]];
            
            [_dataSourceArray addObjectsFromArray:_homework_listArray];
        }else{
            
        }
        
        
//        NSLog(@"科目 %@ ------- 月份 %@", _teach_course_groupArray, _month_groupArray);
        
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
    XXEHomeworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEHomeworkTableViewCell" owner:self options:nil]lastObject];
    }
    XXEHomeworkModel *model = _dataSourceArray[indexPath.row];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 34)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    
    //----------------------科目 下拉框
    self.courseCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(0, 2, kWidth/2, 30)];
    self.courseCombox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    self.courseCombox.textField.placeholder = @"科目";
    self.courseCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.courseCombox.textField.tag = 1001;
    
    if (_teach_course_groupArray.count != 0) {
        self.courseCombox.dataArray = _teach_course_groupArray;
    }
    /**
     * 待接 真数据
     */
//    self.courseCombox.dataArray = self.cityArray;
    
    [headerView addSubview:self.courseCombox];
    //监听
//    [self.courseCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"1"];
    
    self.courseBgView = [[UIView alloc]initWithFrame:CGRectMake(120, 0,kWidth,kHeight+300)];
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
    
    if (_month_groupArray.count != 0) {
        self.dateNameCombox.dataArray = _month_groupArray;
    }
    
//    self.dateNameCombox.dataArray = _areaArray;
    
    [headerView addSubview:self.dateNameCombox];
    //监听
//    [self.dateNameCombox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"2"];
    self.monthBgView = [[UIView alloc]initWithFrame:CGRectMake(120, 0, kWidth,kHeight+300)];
    self.monthBgView.backgroundColor = [UIColor clearColor];
    self.monthBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHi)];
    [self.monthBgView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];

    return headerView;
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
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXEHomeworkModel *model = _dataSourceArray[indexPath.row];

    XXEHomeworkDetailInfoViewController *homeworkDetailInfoVC = [[XXEHomeworkDetailInfoViewController alloc] init];
    homeworkDetailInfoVC.homeworkId = model.homeworkId;
    [self.navigationController pushViewController:homeworkDetailInfoVC animated:YES];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
//    筛选的时候 让 page =  1
    page = 1;
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 1:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                
                if ([newName isEqualToString:@"全部"]) {
                    courseNameStr = @"0";
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
                    dateNameStr = @"0";
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
