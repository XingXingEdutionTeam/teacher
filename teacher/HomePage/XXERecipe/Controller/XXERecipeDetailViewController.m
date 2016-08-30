
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


@interface XXERecipeDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    UITableView *_myTableView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"食谱详情";
    picArray = [[NSMutableArray alloc] init];
    picIdArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
//    NSLog(@"%@", _cookbook_idStr);
    
    [self createData];
    [self createTableView];
    
}

- (void)createData{
    
    if (_mealPicDataSource.count != 0) {
        for (NSDictionary *dic in _mealPicDataSource) {
            
            [picArray addObject:dic[@"pic"]];
            [picIdArray addObject:dic[@"id"]];
        }
    }
    if (_titleStr != nil) {
        if ([_titleStr isEqualToString:@"早餐"]) {
        
            iconStr = @"home_recipe_breakfast_icon38x34";
            
        }else if ([_titleStr isEqualToString:@"午餐"]) {
            
            iconStr = @"home_recipe_lunch_icon38x34";
            
        }else if ([_titleStr isEqualToString:@"晚餐"]) {
            
            iconStr = @"home_recipe_dinner_icon38x34";
        }
    }
    
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
    [cell.foodImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, picArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    iconImageView.image = [UIImage imageNamed:iconStr];
    [headerView addSubview:iconImageView];
    
    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(35, 15, 40, 20) Font:14 Text:_titleStr];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel1];
    
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(80, 10, 250, 40)];
    contentTextView.text = _contentStr;
    contentTextView.editable = NO;
    [headerView addSubview:contentTextView];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    
    CGFloat buttonWidth = 325 * kScreenRatioWidth;
    CGFloat buttonHeight = 42 * kScreenRatioHeight;
    
    UIButton *modifyButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth) / 2, 10, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(modifyButtonClick) Title:@"修    改"];
    [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:modifyButton];
    
    return footerView;
}

- (void)modifyButtonClick{
    XXERecipeModifyViewController *recipeModifyVC = [[XXERecipeModifyViewController alloc] init];
    recipeModifyVC.schoolId = _schoolId;
    recipeModifyVC.titleStr = _titleStr;
    recipeModifyVC.contentStr = _contentStr;
    recipeModifyVC.cookbook_idStr = _cookbook_idStr;
    recipeModifyVC.dateStr = _dateStr;
    
    [self.navigationController pushViewController:recipeModifyVC animated:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    deleteRow = indexPath.row;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
    
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
    
    XXERecipePicDeleteApi *recipePicDeleteApi = [[XXERecipePicDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE pic_id:pic_idStr position:@"4" cookbook_id:_cookbook_idStr];
    [recipePicDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
        }else{
            
        }
        [self updateData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"删除失败" forSecond:1.f];
    }];


}

- (void)updateData{

    [picArray removeObjectAtIndex:deleteRow];
    [picIdArray removeObjectAtIndex:deleteRow];
    
    [_myTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
