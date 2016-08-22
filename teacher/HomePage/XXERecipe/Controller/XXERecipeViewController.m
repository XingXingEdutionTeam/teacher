


//
//  XXERecipeViewController.m
//  teacher
//
//  Created by Mac on 16/8/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeViewController.h"
#import "XXERecipeTableViewCell.h"
#import "XXERecipeBreAndLunAndDinModel.h"
#import "XXERecipeApi.h"


@interface XXERecipeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    //历史 食谱
    NSMutableArray *historyRecipeArray;
    //现在和未来 食谱
    NSMutableArray *nowAndFutureArray;
    //所有 食谱
    NSMutableArray *totalArray;

    //日期 年-月-日 星期几
    NSMutableArray *dateArray;
    //早餐
    NSMutableArray *breakfastDataSource;
    //午餐
    NSMutableArray *lunchDataSource;
    //晚餐
    NSMutableArray *dinnerDataSource;
    
    //食物 图片
    NSMutableArray *mealPicArray;
    NSMutableArray *mealPicDataSource;
    
    //头像
    NSMutableArray *iconImageViewArray;
    NSMutableArray *iconImageViewDataSource;
    //标题 早 午 晚
    NSArray *titleArray;
    //饭菜 组成
    NSMutableArray *contentArray;
    NSMutableArray *contentDataSource;
    
    
//    XXERecipeBreAndLunAndDinModel *breAndLunAndDinModel;
}

@end

@implementation XXERecipeViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.topItem.title = @"小红花";
    historyRecipeArray = [[NSMutableArray alloc] init];
    nowAndFutureArray = [[NSMutableArray alloc] init];
    totalArray = [[NSMutableArray alloc] init];
    breakfastDataSource = [[NSMutableArray alloc] init];
    lunchDataSource =  [[NSMutableArray alloc] init];
    dinnerDataSource = [[NSMutableArray alloc] init];
    
    mealPicDataSource = [[NSMutableArray alloc] init];
    iconImageViewDataSource = [[NSMutableArray alloc] init];
    contentDataSource = [[NSMutableArray alloc] init];
    
    titleArray = [[NSArray alloc] initWithObjects:@"早餐", @"午餐", @"晚餐", nil];
//    page = 0;
//    
//    [_myTableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"食谱";
    
    UIButton *addBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(addBtnClick:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
    [self fetchNetData];
    
    [self createTableView];
    
}



- (void)addBtnClick:(UIButton *)button{
    
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
     【学校食谱】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Parent/school_cookbook
     
     传参:
     school_id	//学校id (测试值:1)*/
    
    XXERecipeApi *recipeApi = [[XXERecipeApi alloc] initWithXid:XID user_id:USER_ID user_type:USER_TYPE school_id:_schoolId];
    [recipeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            //历史 食谱
            historyRecipeArray = dict[@"history_food"];
            
            //现在和未来 食谱
            nowAndFutureArray = dict[@"totay_food"];

            //总共 食谱
            [totalArray addObjectsFromArray:historyRecipeArray];
            [totalArray addObjectsFromArray:nowAndFutureArray];
            
            for (NSDictionary *dic in totalArray) {
                //日期
                NSString *dateString = [XXETool dateStringFromNumberTimer:dic[@"date_tm"]];
                [dateArray addObject:dateString];
                
                mealPicArray = [[NSMutableArray alloc] init];
                iconImageViewArray = [[NSMutableArray alloc] init];
                contentArray = [[NSMutableArray alloc] init];
                
                [mealPicArray addObject:dic[@"breakfast"][@"pic_arr"]];
                [mealPicArray addObject:dic[@"lunch"][@"pic_arr"]];
                [mealPicArray addObject:dic[@"dinner"][@"pic_arr"]];
                [mealPicDataSource addObject:mealPicArray];
                
                
                [iconImageViewArray addObject:dic[@"breakfast"][@"pic_arr"][0][@"pic"]];
                [iconImageViewArray addObject:dic[@"lunch"][@"pic_arr"][0][@"pic"]];
                [iconImageViewArray addObject:dic[@"dinner"][@"pic_arr"][0][@"pic"]];
                [iconImageViewDataSource addObject:iconImageViewArray];
                
                [contentArray addObject:dic[@"breakfast"][@"title"]];
                [contentArray addObject:dic[@"lunch"][@"title"]];
                [contentArray addObject:dic[@"dinner"][@"title"]];
                [contentDataSource addObject:contentArray];

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
    
    if (totalArray.count == 0) {
        
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
    
}



#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return totalArray.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERecipeTableViewCell" owner:self options:nil]lastObject];
    }

    NSString *iconStr = [NSString stringWithFormat:@"%@%@", kXXEPicURL, iconImageViewDataSource[indexPath.section][indexPath.row]];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"home_recipe_placehoder_icon184x154"]];
    
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.contentLabel.text = contentDataSource[indexPath.section][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
//    if ([totalArray[section] count] != 0) {
//        NSLog(@"日期  -- %@", totalArray[section]);
//        NSString *dateStr = [XXETool dateStringFromNumberTimer:totalArray[section]];
//        
//        UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(0, 5, KScreenWidth, 20) Font:14 Text:dateStr];
//        titleLabel1.textAlignment = NSTextAlignmentCenter;
//        [headerView addSubview:titleLabel1];
//    }
    

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
