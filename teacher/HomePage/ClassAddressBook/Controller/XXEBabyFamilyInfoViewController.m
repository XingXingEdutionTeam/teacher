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
    //注意 先 注册
//    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"telCell"];
    
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
    /*
     {
     id = 17;
     lv = 1;
     "relation_name" = "\U7238\U7238";
     tname = "\U674e\U529f\U6210";
     xid = 18886379;
     }*/
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = _familyInfoArray[indexPath.row][@"tname"];
//    NSString *levelStr = [NSString stringWithFormat:@"等级%@",_familyInfoArray[indexPath.row][@"lv"]];
//    cell.detailTextLabel.text = levelStr;
////    NSLog(@"%@", levelStr);
//    
//    cell.detailTextLabel.textColor =UIColorFromRGB(168, 254, 84);
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    return cell;
    
    static NSString *cellId = @"telCell";
    UITableViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
//    cell.imageView.layer.cornerRadius = 30;
//    cell.imageView.clipsToBounds = YES;
    
    cell.textLabel.text = _familyInfoArray[indexPath.row][@"tname"];
    cell.detailTextLabel.textColor =UIColorFromRGB(168, 254, 84);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"等级%@",_familyInfoArray[indexPath.row][@"lv"]];
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
