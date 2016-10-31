
//
//  XXEXingClassRoomTeacherHomePageViewController.m
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomTeacherHomePageViewController.h"
#import "XXEPermissionSettingViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"


@interface XXEXingClassRoomTeacherHomePageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation XXEXingClassRoomTeacherHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
//毕业院校/所学专业/授课范围/教龄/认证/手机/QQ/邮箱/  8个
    self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"myself_school_icon", @"myself_professional_icon", @"home_redflower_courseIcon",@"myself_age_icon40x46",@"classroom_certification icon40x50", @"home_logo_phone_icon40x40", @"home_logo_qq_icon40x40", @"home_logo_email_icon40x40", nil];
    self.titleArray =[[NSMutableArray alloc]initWithObjects:@"毕业院校:", @"所学专业:", @"授课范围:", @"教龄:", @"认证:", @"手机:", @"QQ:", @"邮箱:", nil];
    
//        NSLog(@"%@", _contentArray);
    
    [self createTableView];
}

- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 120 * kScreenRatioHeight - 64  - 49) style:UITableViewStyleGrouped];
    
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
    return _titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerDetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerDetialTableViewCell" owner:self options:nil]lastObject];
    }

    
    cell.iconImageView.image = [UIImage imageNamed:_pictureArray[indexPath.row]];
    cell.titleLabel.text = _titleArray[indexPath.row];
    
    cell.contentLabel.text = _contentArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
