//
//  XXEBabyFamilyInfoViewController.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBabyFamilyInfoViewController.h"
#import "XXEBabyFamilyInfoDetailViewController.h"


@interface XXEBabyFamilyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    
}


@end

@implementation XXEBabyFamilyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"------  %@", _familyInfoArray);
    [self createTableView];
    
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
    return _familyInfoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"telCell";
    UITableViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.textLabel.text = _familyInfoArray[indexPath.row][@"tname"];
//    cell.detailTextLabel.textColor =UIColorFromRGB(168, 254, 84);
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"等级%@",_familyInfoArray[indexPath.row][@"lv"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXEBabyFamilyInfoDetailViewController *babyFamilyInfoDetailVC = [[XXEBabyFamilyInfoDetailViewController alloc] init];
    babyFamilyInfoDetailVC.baby_id = _baby_id;
    babyFamilyInfoDetailVC.parent_id = _familyInfoArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:babyFamilyInfoDetailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
