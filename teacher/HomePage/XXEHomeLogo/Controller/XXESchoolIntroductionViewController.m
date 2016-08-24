
//
//  XXESchoolIntroductionViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXESchoolIntroductionViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"
#import "XXESchoolRegisterTeacherInfoViewController.h"
#import "XXESchoolPhoneNumModifyViewController.h"
#import "XXESchoolQQModifyViewController.h"
#import "XXESchoolEmailModiyfViewController.h"
#import "XXESchoolCertificateModifyViewController.h"
#import "XXESchoolFeatureModifyViewController.h"
#import "XXESchoolIntroductionDetailViewController.h"
#import "XXESchoolAlbumViewController.h"
#import "XXESchoolVideoViewController.h"

@interface XXESchoolIntroductionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UITableView *myTableView;


@end

@implementation XXESchoolIntroductionViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"home_logo_register_icon40x40", @"home_logo_teacher_icon40x40", @"home_logo_phone_icon40x40", @"home_logo_qq_icon40x40", @"home_logo_email_icon40x40", @"home_logo_certificate_icon40x40", @"home_logo_feature_icon40x40",  @"home_logo_introduction_icon40x44", @"home_redflower_picIcon", @"home_logo_video_icon40x40", nil];
    self.titleArray =[[NSMutableArray alloc]initWithObjects:@"注册学生:", @"注册教师:", @"联系方式:", @"联系QQ:", @"邮箱:", @"资质:",@"特点:",@"简介:", @"相册:", @"视频:",  nil];

//    NSLog(@"%@", _contentArray);
    
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
    return _pictureArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerDetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerDetialTableViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //@"注册学生:", @"注册教师:", @"联系方式:", @"联系QQ:", @"邮箱:", @"资质:",@"特点:",@"简介:", @"相册:", @"视频:"
    //注册学生
    
    //注册教师
    if (indexPath.row == 1) {
    XXESchoolRegisterTeacherInfoViewController *schoolRegisterTeacherInfoVC = [[XXESchoolRegisterTeacherInfoViewController alloc] init];
    [self.navigationController pushViewController:schoolRegisterTeacherInfoVC animated:YES];
        
    }
    
    //教师 91 只有教师不能改
    
//    NSString * name =[[NSUserDefaults standardUserDefaults] objectForKey:@"KEENTEAM"];
//    if ([name integerValue] == 91) {
//        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
        
//    }else{
    //修改电话
      if (indexPath.row == 2){
      XXESchoolPhoneNumModifyViewController *schoolPhoneNumModifyVC = [[XXESchoolPhoneNumModifyViewController alloc] init];
    [self.navigationController pushViewController:schoolPhoneNumModifyVC animated:YES];
          
            //修改QQ
        }else if (indexPath.row == 3){
            XXESchoolQQModifyViewController *schoolQQModifyVC = [[XXESchoolQQModifyViewController alloc] init];
            [self.navigationController pushViewController:schoolQQModifyVC animated:YES];
            //修改邮箱
        }else if (indexPath.row == 4){
            XXESchoolEmailModiyfViewController *schoolEmailModiyfVC = [[XXESchoolEmailModiyfViewController alloc] init];
            [self.navigationController pushViewController:schoolEmailModiyfVC animated:YES];
            
            //修改 资质
        }else if (indexPath.row == 5) {
            XXESchoolCertificateModifyViewController *schoolCertificateModifyVC = [[XXESchoolCertificateModifyViewController alloc] init];
            [self.navigationController pushViewController:schoolCertificateModifyVC animated:YES];
            //修改 特点
        }else if (indexPath.row == 6) {
          XXESchoolFeatureModifyViewController *schoolFeatureModifyVC =[[XXESchoolFeatureModifyViewController alloc]init];
        [self.navigationController pushViewController:schoolFeatureModifyVC animated:YES];
        }
        
//    }
    
    //简介
    if (indexPath.row == 7) {
        XXESchoolIntroductionDetailViewController *schoolIntroductionDetailVC = [[XXESchoolIntroductionDetailViewController alloc] init];
        [self.navigationController pushViewController:schoolIntroductionDetailVC animated:YES];
        //相册
    }else if (indexPath.row == 8) {
        XXESchoolAlbumViewController *albumVC = [[XXESchoolAlbumViewController alloc] init];
        [self.navigationController pushViewController:albumVC animated:YES];
        //视频
    }else if (indexPath.row == 9){
        XXESchoolVideoViewController *schoolVideoVC = [[XXESchoolVideoViewController alloc] init];
        [self.navigationController pushViewController:schoolVideoVC animated:YES];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
