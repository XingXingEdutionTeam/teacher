


//
//  XXEManagerAndHeadmasterViewController.m
//  teacher
//
//  Created by Mac on 16/8/16.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEManagerAndHeadmasterViewController.h"
#import "XXEChiefAndTeacherTableViewCell.h"
#import "XXEChiefAndTeacherModel.h"
#import "XXEManagerAndHeadmasterApi.h"
#import "DynamicScrollView.h"


@interface XXEManagerAndHeadmasterViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;

    NSMutableArray *class_idArray;
    NSMutableArray *class_nameArray;
    NSMutableArray *baby_listArray;
    
    UIButton *arrowButton;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@property (nonatomic,strong) NSMutableArray *flagArray;
@property (nonatomic , strong) NSMutableArray *selectedBabyInfoArr;


@end

@implementation XXEManagerAndHeadmasterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    
    
    self.title = @"";
    
    //    [self fetchNetData];
    
    [self createTableView];
    

    
}


- (void)fetchNetData{
    /*
     //管理员和校长 调用 下面接口
     【学生列表(某个学校所有班级)】多个模块用到此接口
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/baby_list_allclass
     
     传参:
     
     school_id	//学校id   */
    XXEManagerAndHeadmasterApi *managerAndHeadmasterApi = [[XXEManagerAndHeadmasterApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId];
    [managerAndHeadmasterApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        class_idArray =  [[NSMutableArray alloc] init];
        class_nameArray = [[NSMutableArray alloc] init];
        baby_listArray = [[NSMutableArray alloc] init];
        
//                NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in request.responseJSONObject[@"data"]) {
                
                [class_idArray addObject:dic[@"class_id"]];
                [class_nameArray addObject:dic[@"class_name"]];
                [baby_listArray addObject:dic[@"baby_list"]];
//                [baby_listArray addObjectsFromArray:dic[@"baby_list"]];

            }
            
            for (NSArray *arr in baby_listArray) {
                NSArray *modelArray = [XXEChiefAndTeacherModel parseResondsData:arr];
//                [_dataSourceArray addObjectsFromArray:modelArray];
                [_dataSourceArray addObject:modelArray];
            }
            
            self.flagArray = [[NSMutableArray alloc]init];
            for (int j=0; j<class_idArray.count; j++) {
                NSNumber *flagN = [NSNumber numberWithBool:NO];
                [self.flagArray addObject:flagN];
            }
            
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
    
    [self fetchNetData];
    [ _myTableView.mj_header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_footer endRefreshing];
}

- (void)loadFooterNewData{
    
    [self fetchNetData];
    [ _myTableView.mj_footer endRefreshing];
    
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return class_idArray.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.flagArray[section] boolValue] == YES) {
        return [_dataSourceArray[section] count];
    }else{
    
        return 0;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEChiefAndTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEChiefAndTeacherTableViewCell" owner:self options:nil]lastObject];
    }
    XXEChiefAndTeacherModel *model = _dataSourceArray[indexPath.section][indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    NSString *head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"home_flowerbasket_placehoderIcon120x120"]];
    cell.nameLabel.text = model.tname;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXEChiefAndTeacherModel *model = _dataSourceArray[indexPath.section][indexPath.row];
    //选中 宝贝 头像/名称/id
    _selectedBabyInfoArr = [[NSMutableArray alloc] initWithObjects:model.head_img, model.tname, model.baby_id, model.school_id, model.class_id, nil];
    
    self.ReturnArrayBlock(_selectedBabyInfoArr);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)returnArray:(ReturnArrayBlock)block{
    self.ReturnArrayBlock = block;

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    
    view.tag = 100 + section;
    
    UITapGestureRecognizer *viewPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPressClick:)];
    [view addGestureRecognizer:viewPress];
    
    arrowButton = [[UIButton alloc]initWithFrame:CGRectMake(10, (44-24)/2, 17.5, 20)];
    NSNumber *flagN = self.flagArray[section];
    
    if ([flagN boolValue]) {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
        CGAffineTransform currentTransform =arrowButton.transform;
        CGAffineTransform newTransform =CGAffineTransformRotate(currentTransform, M_PI/2);
        arrowButton.transform =newTransform;
        
    }else
    {
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal ];
        
    }
    arrowButton.tag = 300+section;
    //    [arrowButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:arrowButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 200, 30)];
    label.text = [NSString stringWithFormat:@"%@",class_nameArray[section]];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:label];
    
    return view;
}

- (void)viewPressClick:(UITapGestureRecognizer *)press{
    
    //    NSLog(@" 头视图  tag  %ld", press.view.tag - 100);
    
    if ([self.flagArray[press.view.tag - 100] boolValue]) {
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber  numberWithBool:NO]];
        
    }else{
        [self.flagArray replaceObjectAtIndex:(press.view.tag - 100) withObject:[NSNumber numberWithBool:YES]];
    }
    [_myTableView reloadData ];
    
    
}
//返回每个分组的表头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}



@end
