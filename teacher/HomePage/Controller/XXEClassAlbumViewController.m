//
//  XXEClassAlbumViewController.m
//  teacher
//
//  Created by codeDing on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEClassAlbumViewController.h"
#import "XXEClassAlbumTableViewCell.h"
#import "XXEClassAlbumApi.h"
#import "XXEClassAlbumModel.h"
#import "XXEMyClassAlbumViewController.h"
#import "XXEOtherTeacherAlbumViewController.h"

@interface XXEClassAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *classAlbumTableView;
/** 头不文字显示数组 */
@property (nonatomic, strong)NSMutableArray *headDatasource;
/** 相片的数组 */
@property (nonatomic, strong)NSMutableArray *imageViewDatasource;
/** 老师ID */
@property (nonatomic, strong)NSMutableArray *teacherDatasource;

@end

static NSString *const IdentifierCell = @"classAlbunCell";

@implementation XXEClassAlbumViewController

-(NSMutableArray *)headDatasource
{
    if (!_headDatasource) {
        _headDatasource = [NSMutableArray array];
    }
    return _headDatasource;
}

-(NSMutableArray *)imageViewDatasource
{
    if (!_imageViewDatasource) {
        _imageViewDatasource = [NSMutableArray array];
    }
    return _imageViewDatasource;
}

- (NSMutableArray *)teacherDatasource
{
    if (!_teacherDatasource) {
        _teacherDatasource = [NSMutableArray array];
    }
    return _teacherDatasource;
}

- (UITableView *)classAlbumTableView
{
    if (!_classAlbumTableView) {
        _classAlbumTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    return _classAlbumTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相册";
    //获取数据
    [self loadClassAlbumMessage];
    [self.classAlbumTableView registerClass:[XXEClassAlbumTableViewCell class] forCellReuseIdentifier:IdentifierCell];
     _classAlbumTableView.delegate = self;
    _classAlbumTableView.dataSource = self;
    [self.view addSubview:self.classAlbumTableView];

}

#pragma mark - 获取数据
- (void)loadClassAlbumMessage
{
    XXEClassAlbumApi *classApi = [[XXEClassAlbumApi alloc]initWithClassAlbumSchoolID:self.schoolID classID:self.classID];
    [classApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSArray *data = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@"我的相册:%lu",(unsigned long)data.count );
        if (data.count ==0) {
            [self showString:@"赶紧上传照片哦" forSecond:1.f];
        }else{
        NSLog(@"%@",data);
         
            [self showHudWithString:@"正在请求数据" forSecond:1.f];
            for (int i =0 ; i < data.count; i++) {
                XXEClassAlbumModel *model = [[XXEClassAlbumModel alloc]initWithDictionary:data[i] error:nil];
                NSString *stringName;
                if (i==0) {
                    stringName = @"我的相册";
                }else{
                    stringName = [NSString stringWithFormat:@"%@老师的相册",model.tname];
                }
                [self.headDatasource addObject:stringName];
                [self.imageViewDatasource addObject:model.pic_arr];
                [self.teacherDatasource addObject:model.teacher_id];
                //            NSLog(@"老师的ID%@",self.teacherDatasource);
            }
            [self.classAlbumTableView reloadData];
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showHudWithString:@"数据请求失败" forSecond:1.f];
    }];
}

#define mark - delegate 单元格的代理方法 datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 30;
    }
    
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headDatasource.count;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return   self.headDatasource[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXEClassAlbumTableViewCell *cell = (XXEClassAlbumTableViewCell*) [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        NSArray *model = self.imageViewDatasource[indexPath.section];
    NSLog(@"---------%@",self.imageViewDatasource);
    
        [cell getTheImageViewData:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     XXEClassAlbumTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row ==0 && indexPath.section==0) {
    
        XXEMyClassAlbumViewController *myClassVC = [[XXEMyClassAlbumViewController alloc]init];
        myClassVC.myAlbumClassId=self.classID;
        myClassVC.myAlbumSchoolId=self.schoolID;
        myClassVC.myAlbumTeacherId = self.teacherDatasource[indexPath.section];
        NSLog(@"%@ %@ %@",myClassVC.myAlbumSchoolId,myClassVC.myAlbumClassId,myClassVC.myAlbumTeacherId);
    [self.navigationController pushViewController:myClassVC animated:YES];
        
    }
    else{
        XXEOtherTeacherAlbumViewController *otherVC = [[XXEOtherTeacherAlbumViewController alloc]init];
        otherVC.otherClassId=self.classID;
        otherVC.otherSchoolId=self.schoolID;
        otherVC.otherTeacherId = self.teacherDatasource[indexPath.section];
        NSLog(@"%@ %@ %@",otherVC.otherSchoolId,otherVC.otherClassId,otherVC.otherTeacherId);
        [self.navigationController pushViewController:otherVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
