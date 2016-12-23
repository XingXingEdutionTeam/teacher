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
{

    //数据model
    NSMutableArray *modelArray;
    
    NSString *strngXid;
    NSString *albumUserId;
}
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
        _classAlbumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49) style:UITableViewStyleGrouped];
    }
    return _classAlbumTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
    //获取数据
    [self loadClassAlbumMessage];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相册";
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        albumUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        albumUserId = USER_ID;
    }
    modelArray = [[NSMutableArray alloc] init];

    [self.classAlbumTableView registerClass:[XXEClassAlbumTableViewCell class] forCellReuseIdentifier:IdentifierCell];
     _classAlbumTableView.delegate = self;
    _classAlbumTableView.dataSource = self;
    [self.view addSubview:self.classAlbumTableView];
}

#pragma mark - 获取数据
- (void)loadClassAlbumMessage
{
    
//    NSLog(@"%@=== %@ ===== %@ ==== %@ === %@", _schoolID, _classID, strngXid, albumUserId, _userIdentifier);
    //427397=== 0 ===== 42233235 ==== 101 === 3
    
    if ([_headDatasource count] != 0) {
        [self.headDatasource removeAllObjects];
    }
    
    
    XXEClassAlbumApi *classApi = [[XXEClassAlbumApi alloc]initWithClassAlbumSchoolID:self.schoolID classID:self.classID UserXId:strngXid UserID:albumUserId position:_userIdentifier];
    [classApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"bbbb 相册 ****** %@",request.responseJSONObject);
        
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code intValue]==1) {
            if ([[request.responseJSONObject objectForKey:@"data"] isKindOfClass:[NSString class]]) {
                // 1、无数据的时候
                [self.imageViewDatasource addObject:@"album_icon"];
                [self.imageViewDatasource addObject:@"album_icon"];
                [self.imageViewDatasource addObject:@"album_icon"];
                
            }else{
                if (self.imageViewDatasource.count != 0) {
                    [self.imageViewDatasource removeAllObjects];
                }
                
                if (self.teacherDatasource.count != 0) {
                    [self.teacherDatasource removeAllObjects];
                }
                
                if (modelArray.count != 0) {
                    [modelArray removeAllObjects];
                }
                
                NSArray *data = [request.responseJSONObject objectForKey:@"data"];
                for (int i =0 ; i < data.count; i++) {
                    XXEClassAlbumModel *model = [[XXEClassAlbumModel alloc]initWithDictionary:data[i] error:nil];
                    NSString *stringName;
//                    if (self.userIdentifier != nil) {
//                        stringName = [NSString stringWithFormat:@"%@老师的相册",model.tname];
//                    }else{
                    
                      if (i==0) {
                        stringName = @"我的相册";
                      }else{
                        stringName = [NSString stringWithFormat:@"%@%@的相册",model.tname, model.position_name];
                      }
//                    }
                    [self.headDatasource addObject:stringName];
                    [self.imageViewDatasource addObject:model.pic_arr];
                    [self.teacherDatasource addObject:model.teacher_id];
                    [modelArray addObject:model];
                }
//                NSLog(@"数组%@",self.imageViewDatasource);
            }
            
        }
//        NSLog(@"jjjjj %@", modelArray);
        
       [self.classAlbumTableView reloadData];
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

//返回几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%lu",(unsigned long)self.headDatasource.count);
    return self.headDatasource.count;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return   self.headDatasource[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
//每组返回几个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXEClassAlbumTableViewCell *cell = (XXEClassAlbumTableViewCell*) [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.imageViewDatasource.count ==0) {
    
    }else{
//    NSLog(@"---------%@",self.imageViewDatasource);
    NSArray *model = self.imageViewDatasource[indexPath.section];

//        NSLog(@"model ==== %@", model);
        [cell getTheImageViewData:model];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([XXEUserInfo user].login) {
        XXEClassAlbumTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        XXEClassAlbumModel *model = modelArray[indexPath.section];
//        NSLog(@"model == %@", model);
        
            if (indexPath.row ==0 && indexPath.section==0) {
                
                XXEMyClassAlbumViewController *myClassVC = [[XXEMyClassAlbumViewController alloc]init];
                myClassVC.myAlbumClassId = model.class_id;
                myClassVC.myAlbumSchoolId=self.schoolID;
                
                myClassVC.myAlbumTeacherId = self.teacherDatasource[indexPath.section];
                myClassVC.userIdentifier = _userIdentifier;
                
                [self.navigationController pushViewController:myClassVC animated:YES];
                
            }
            else{
                XXEOtherTeacherAlbumViewController *otherVC = [[XXEOtherTeacherAlbumViewController alloc]init];
                otherVC.otherClassId=model.class_id;
                otherVC.otherSchoolId=self.schoolID;
                otherVC.otherTeacherId = self.teacherDatasource[indexPath.section];
//                otherVC.userIdentifier = model.otherTeacherPosition;
                //        NSLog(@"%@ %@ %@",otherVC.otherSchoolId,otherVC.otherClassId,otherVC.otherTeacherId);
                [self.navigationController pushViewController:otherVC animated:YES];
            }
            
//        }
 
    }else{
        [self showString:@"请用账号登录后查看" forSecond:1.5];
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
