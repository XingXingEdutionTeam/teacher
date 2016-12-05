
//
//  XXERecipeDetailViewController.m
//  teacher
//
//  Created by Mac on 16/8/23.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERecipeDetailViewController.h"
#import "XXERecipeDetailTableViewCell.h"
#import "XXERecipePicDeleteApi.h"
#import "XXERecipeModifyViewController.h"
#import "XXERecipeSingleMealDetailInfoApi.h"

@interface XXERecipeDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    UITableView *_myTableView;
    //上面 文字 部分
    UIView *headerView;
    
   //pic
    NSMutableArray *picArray;
   //pic id
    NSMutableArray *picIdArray;
    //图标
    NSString *iconStr;
    //删除 图片 row
    NSInteger deleteRow;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXERecipeDetailViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    picArray = [[NSMutableArray alloc] init];
    picIdArray = [[NSMutableArray alloc] init];
//    _dataSourceArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"食谱详情";
    


    [self createTableView];
    
}

#pragma mark ====== 创建 文字 部分 =========
- (void)createTextContent{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    iconImageView.image = [UIImage imageNamed:iconStr];
    [headerView addSubview:iconImageView];
    
    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(35, 10, 40, 20) Font:14 Text:_titleStr];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel1];
    
    //    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(80, 10, 250, 40)];
    //    contentTextView.text = _contentStr;
    //    contentTextView.editable = NO;
    //    [headerView addSubview:contentTextView];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 280 * kScreenRatioWidth, 20)];
    contentLabel.text = _contentStr;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:contentLabel];
    
//    NSLog(@"_contentStr == %@", _contentStr);
    
    CGFloat height = [StringHeight contentSizeOfString:_contentStr maxWidth:contentLabel.width fontSize:14];
    CGSize size1 = contentLabel.size;
    size1.height = height;
    contentLabel.size = size1;
    
//    NSLog(@"height === %lf", height);
    
    if (height > 20) {
        CGSize size2 = headerView.size;
        size2.height = height + 20;
        headerView.size = size2;
        
   }

    [_myTableView reloadData];

}

- (void)createData{
    if (_titleStr != nil) {
        if ([_titleStr isEqualToString:@"早餐"]) {
        
            iconStr = @"home_recipe_breakfast_icon38x34";
            _meal_type = @"1";
        }else if ([_titleStr isEqualToString:@"午餐"]) {
            
            iconStr = @"home_recipe_lunch_icon38x34";
            _meal_type = @"2";
            
        }else if ([_titleStr isEqualToString:@"晚餐"]) {
            
            iconStr = @"home_recipe_dinner_icon38x34";
            _meal_type = @"3";
        }
    }
    
    [self fetchNetData];
    
}

- (void)fetchNetData{

    XXERecipeSingleMealDetailInfoApi *recipeSingleMealDetailInfoApi = [[XXERecipeSingleMealDetailInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId date_tm:_date_tm meal_type:_meal_type];
    [recipeSingleMealDetailInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            _contentStr = dict[@"title"];
            if ([dict[@"pic_arr"] count] != 0) {
                for (NSDictionary *dic in dict[@"pic_arr"]) {
                    
                    [picArray addObject:dic[@"pic"]];
                    [picIdArray addObject:dic[@"id"]];
                }
            }
        }else{
            
        }
        //创建 文字 部分
        [self createTextContent];
        
        [_myTableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}




- (void)createTableView{
    
//    NSLog(@"头部 == %lf", headerView.height);
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y + headerView.height + 5, KScreenWidth, KScreenHeight - 64 - headerView.height) style:UITableViewStyleGrouped];
    
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
    return picArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERecipeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERecipeDetailTableViewCell" owner:self options:nil]lastObject];
    }
    [cell.foodImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, picArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.position isEqualToString:@"3"] || [self.position isEqualToString:@"4"]) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
        
        CGFloat buttonWidth = 325 * kScreenRatioWidth;
        CGFloat buttonHeight = 42 * kScreenRatioHeight;
        
        UIButton *modifyButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth) / 2, 10, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(modifyButtonClick) Title:@"修    改"];
        [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [footerView addSubview:modifyButton];
        
        return footerView;
    }else{
        return nil;
    }
    
}

- (void)modifyButtonClick{
    XXERecipeModifyViewController *recipeModifyVC = [[XXERecipeModifyViewController alloc] init];
    recipeModifyVC.schoolId = _schoolId;
    recipeModifyVC.titleStr = _titleStr;
    recipeModifyVC.contentStr = _contentStr;
    recipeModifyVC.cookbook_idStr = _cookbook_idStr;
    recipeModifyVC.dateStr = _date_tm;
    recipeModifyVC.position = _position;
    
    [self.navigationController pushViewController:recipeModifyVC animated:YES];

}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 60;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.position isEqualToString:@"3"] || [self.position isEqualToString:@"4"]) {
        deleteRow = indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
            //取消
            break;
            
        case 1:
        {
            [self deletePicInfo];
        
        }
        break;
            
    }

}

- (void)deletePicInfo{
/*
 传参:
	position	//身份,传数字(1教师/2班主任/3管理/4校长)
	cookbook_id	//食谱id
	pic_id		//图片id*/

    NSString *pic_idStr = picIdArray[deleteRow];
    
    XXERecipePicDeleteApi *recipePicDeleteApi = [[XXERecipePicDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE pic_id:pic_idStr position:_position cookbook_id:_cookbook_idStr];
    [recipePicDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"删除成功!"];
            [self updateData];
        }else{
            [self showHudWithString:@"删除失败!"];
        }
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"获取数据失败!" forSecond:1.f];
    }];


}

- (void)updateData{

    [picArray removeObjectAtIndex:deleteRow];
    [picIdArray removeObjectAtIndex:deleteRow];
    
    [_myTableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
