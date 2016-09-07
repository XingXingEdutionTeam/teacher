


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
#import "XXERecipeDetailViewController.h"
#import "XXERecipeApi.h"
#import "XXERecipeDeleteApi.h"
#import "XXERecipeAddViewController.h"

@interface XXERecipeViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
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
    //某一天 食谱 id  cookbook_id
    NSMutableArray *cookbook_idArray;
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
    
    //删除 食谱 的 section
    NSInteger deleteSection;
    //记录 最初 历史 食谱 个数
    NSInteger historyCount;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@end

@implementation XXERecipeViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    titleArray = [[NSArray alloc] initWithObjects:@"早餐", @"午餐", @"晚餐", nil];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
//   NSLog(@"parameterXid:%@ *****parameterUser_Id:%@ ****   _schoolId  +++  %@",  parameterXid, parameterUser_Id, _schoolId);
    
    [self fetchNetData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = XXEColorFromRGB(0, 170, 42);
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"食谱";
    
    UIButton *addBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"comment_request_icon" Target:self Action:@selector(addBtnClick:) Title:@""];
    UIBarButtonItem *sentItem =[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem =sentItem;
    
//    [self fetchNetData];
    
    [self createTableView];
}



- (void)addBtnClick:(UIButton *)button{
    
    XXERecipeAddViewController *recipeAddVC = [[XXERecipeAddViewController alloc] init];
    
    recipeAddVC.schoolId = _schoolId;
//    sentToPeopleVC.classId = _classId;
//    sentToPeopleVC.basketNumStr = _flower_able;
    
    [self.navigationController pushViewController:recipeAddVC animated:YES];
    
}

- (void)fetchNetData{
    /*
     【学校食谱】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Parent/school_cookbook
     
     传参:
     school_id	//学校id (测试值:1)*/
    XXERecipeApi *recipeApi = [[XXERecipeApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId];
    [recipeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        dateArray = [[NSMutableArray alloc] init];
        cookbook_idArray = [[NSMutableArray alloc] init];
        historyRecipeArray = [[NSMutableArray alloc] init];
        nowAndFutureArray = [[NSMutableArray alloc] init];
        totalArray = [[NSMutableArray alloc] init];
        breakfastDataSource = [[NSMutableArray alloc] init];
        lunchDataSource =  [[NSMutableArray alloc] init];
        dinnerDataSource = [[NSMutableArray alloc] init];
        
        mealPicDataSource = [[NSMutableArray alloc] init];
        iconImageViewDataSource = [[NSMutableArray alloc] init];
        contentDataSource = [[NSMutableArray alloc] init];
//        NSLog(@"食谱 ---   %@", request.responseJSONObject);
        
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
                NSArray *array = [dateString componentsSeparatedByString:@" "];
                [dateArray addObject:array[0]];
                
                //食谱 id
                [cookbook_idArray addObject:dic[@"cookbook_id"]];
                
                mealPicArray = [[NSMutableArray alloc] init];
                iconImageViewArray = [[NSMutableArray alloc] init];
                contentArray = [[NSMutableArray alloc] init];
                
                if ([dic[@"breakfast"][@"pic_arr"] count] != 0) {
                    [mealPicArray addObject:dic[@"breakfast"][@"pic_arr"]];
                    [iconImageViewArray addObject:dic[@"breakfast"][@"pic_arr"][0][@"pic"]];
                }else{
                    NSArray *emptyArray = [[NSArray alloc] init];
                    [mealPicArray addObject:emptyArray];
                    [iconImageViewArray addObject:@""];
                }
                
                if ([dic[@"lunch"][@"pic_arr"] count] != 0) {
                  [mealPicArray addObject:dic[@"lunch"][@"pic_arr"]];
                  [iconImageViewArray addObject:dic[@"lunch"][@"pic_arr"][0][@"pic"]];
                }else{
                NSArray *emptyArray = [[NSArray alloc] init];
                [mealPicArray addObject:emptyArray];
                [iconImageViewArray addObject:@""];
                }
                
                
                if ([dic[@"dinner"][@"pic_arr"] count] != 0) {
                    [mealPicArray addObject:dic[@"dinner"][@"pic_arr"]];
                    [iconImageViewArray addObject:dic[@"dinner"][@"pic_arr"][0][@"pic"]];
                }else{
                    NSArray *emptyArray = [[NSArray alloc] init];
                    [mealPicArray addObject:emptyArray];
                    [iconImageViewArray addObject:@""];
                }
                
                [mealPicDataSource addObject:mealPicArray];
                [iconImageViewDataSource addObject:iconImageViewArray];
                
                [contentArray addObject:dic[@"breakfast"][@"title"]];
                [contentArray addObject:dic[@"lunch"][@"title"]];
                [contentArray addObject:dic[@"dinner"][@"title"]];
                [contentDataSource addObject:contentArray];

            }
            
            
        }else{
            
        }
//        NSLog(@"%@", iconImageViewDataSource);
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
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
//        NSLog(@"%ld", historyRecipeArray.count);
        //滚动到 时间 为今天 的食谱 cell
        [_myTableView setContentOffset:CGPointMake(0.0, historyRecipeArray.count  *(80 * 3 + 30) ) animated:NO];
    }
    [_myTableView reloadData];
    
}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
    
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

    if ([iconImageViewDataSource[indexPath.section] count] != 0) {
        
//        NSLog(@"gg --  oo%@", iconImageViewDataSource[indexPath.section]);
        NSString *iconStr = [NSString stringWithFormat:@"%@%@", kXXEPicURL, iconImageViewDataSource[indexPath.section][indexPath.row]];
        
//        NSLog(@"===  %@", iconStr);
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"home_recipe_placehoder_icon"]];
    }else{
    
        cell.iconImageView.image = [UIImage imageNamed:@"home_recipe_placehoder_icon"];
    }
    
    
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.contentLabel.text = contentDataSource[indexPath.section][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , 30)];
    if ([totalArray[section] count] != 0) {
        UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(20, 5, KScreenWidth / 2, 20) Font:14 Text:dateArray[section]];
        titleLabel1.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:titleLabel1];
        
        //home_recipe_delete_icon
        UIButton *deleteButton = [UIButton createButtonWithFrame:CGRectMake(KScreenWidth - 30, 5, 17, 21) backGruondImageName:@"home_recipe_delete_icon" Target:self Action:@selector(deleteButtonClick:) Title:@""];
        
        deleteButton.tag = 100 + section;
        
        [headerView addSubview:deleteButton];
        
    }
    

    return headerView;
}


- (void)deleteButtonClick:(UIButton *)button{

    deleteSection = button.tag - 100;
//        NSLog(@"%ld", deleteSection);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除这天的食谱信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
}


#pragma mark - 
#pragma mark - delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //取消
            break;
         
        case 1:
        {
        [self deleteRecipeInfo];
        
        }
            break;
    }

}

- (void)deleteRecipeInfo{
    /*
     传参:
     position	//身份,传数字(1教师/2班主任/3管理/4校长)
     cookbook_id	//食谱id
     school_id	//学校id
     */
    NSString *cookbook_idStr = cookbook_idArray[deleteSection];
    
    XXERecipeDeleteApi *recipeDeleteApi = [[XXERecipeDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE school_id:_schoolId position:@"4" cookbook_id:cookbook_idStr];
    [recipeDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
        }else{
            
        }
        [self fetchNetData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"删除失败" forSecond:1.f];
    }];


}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XXERecipeDetailViewController *recipeDetailVC = [[XXERecipeDetailViewController alloc] init];

    if ([mealPicDataSource[indexPath.section] count] != 0) {
        recipeDetailVC.mealPicDataSource = mealPicDataSource[indexPath.section][indexPath.row];
    }

    recipeDetailVC.titleStr = titleArray[indexPath.row];
    recipeDetailVC.dateStr = dateArray[indexPath.section];
    recipeDetailVC.contentStr = contentDataSource[indexPath.section][indexPath.row];
    recipeDetailVC.cookbook_idStr = cookbook_idArray[indexPath.section];
    
    recipeDetailVC.schoolId = _schoolId;
    
    [self.navigationController pushViewController:recipeDetailVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
