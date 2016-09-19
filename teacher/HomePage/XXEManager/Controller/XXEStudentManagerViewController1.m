

//
//  XXEStudentManagerViewController1.m
//  teacher
//
//  Created by Mac on 16/9/19.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentManagerViewController1.h"
#import "XXEStudentManagerTableViewCell.h"
#import "XXEStudentManagerApi.h"
#import "XXEClassInfoModel.h"


@interface XXEStudentManagerViewController1 ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEStudentManagerViewController1

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.topItem.title = @"小红花";
    _dataSourceArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"小红花";
    
    //    [self fetchNetData];
    
    [self createTableView];
    
}




- (void)fetchNetData{
    /*
     【小红花->赠送记录列表】
     
     接口类型:1
     
     接口:
     http://www.xingxingedu.cn/Teacher/give_flower_msg
     
     传参:
     
     page	//页码(加载更多,默认1)     */
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
//    XXERedFlowerSentHistoryApi *redFlowerSentHistoryApi = [[XXERedFlowerSentHistoryApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE page:pageStr];
//    [redFlowerSentHistoryApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
//        //        NSLog(@"2222---   %@", request.responseJSONObject);
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            
//            NSDictionary *dict = request.responseJSONObject[@"data"];
//            //已赠花篮数量
//            if (dict[@"give_num"] == nil) {
//                _give_num = @"";
//            }else{
//                _give_num = [NSString stringWithFormat:@"已颁发:%@朵", dict[@"give_num"]];
//            }
//            //剩余花篮 数量
//            if (dict[@"flower_able"] == nil) {
//                _flower_able = @"";
//            }else{
//                _flower_able = [NSString stringWithFormat:@"剩余:%@朵", dict[@"flower_able"]];
//            }
//            NSArray *modelArray = [XXERedFlowerSentHistoryModel parseResondsData:dict[@"list"]];
//            
//            [_dataSourceArray addObjectsFromArray:modelArray];
//        }else{
//            
//        }
//        
//        [self customContent];
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        
//        [self showString:@"数据请求失败" forSecond:1.f];
//    }];
    
}


// 有数据 和 无数据 进行判断
//- (void)customContent{
//    
//    if (_dataSourceArray.count == 0) {
//        
//        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        // 1、无数据的时候
//        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
//        CGFloat myImageWidth = myImage.size.width;
//        CGFloat myImageHeight = myImage.size.height;
//        
//        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
//        myImageView.image = myImage;
//        [self.view addSubview:myImageView];
//        
//    }else{
//        //2、有数据的时候
//        [_myTableView reloadData];
//        
//    }
//    
//}


- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    _myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterNewData)];
    
    
}

-(void)loadNewData{
    page ++;
    
    [self fetchNetData];
    [ _myTableView.header endRefreshing];
}
-(void)endRefresh{
    [_myTableView.header endRefreshing];
    [_myTableView.footer endRefreshing];
}

- (void)loadFooterNewData{
    page ++ ;
    
    [self fetchNetData];
    [ _myTableView.footer endRefreshing];
    
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEStudentManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEStudentManagerTableViewCell" owner:self options:nil]lastObject];
    }
    
//    //宝贝 信息
//    XXEClassInfoModel *classModel = classModelArray[indexPath.section];
//    XXEStudentInfoModel *studentModel = classModel.baby_list[indexPath.row];
//    
//    //宝贝 头像 全部 是拼接 的
//    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, studentModel.head_img]] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
//    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
//    cell.iconImageView.layer.masksToBounds = YES;
//    cell.titleLabel.text = studentModel.tname;
//    cell.timeLabel.text = [XXETool dateStringFromNumberTimer:studentModel.date_tm];
//    
//    //点击 头像 进入 宝贝详情 界面
//    cell.iconImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *iconTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap:)];
//    cell.iconImageView.tag =100+indexPath.row;
//    [cell.iconImageView addGestureRecognizer:iconTap];
//    
//    //移动 按钮
//    _moveBtn = [UIButton createButtonWithFrame:CGRectMake(260, 27, 50, 25) backGruondImageName:nil Target:self Action:@selector(onClickMoveBtn:) Title:@"移动"];
//    [_moveBtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
//    _moveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_moveBtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
//    [_moveBtn.layer setBorderWidth:1];
//    [_moveBtn.layer setMasksToBounds:YES];
//    
//    //删除 按钮
//    _deletebtn = [UIButton createButtonWithFrame:CGRectMake(315, 27, 50, 25) backGruondImageName:nil Target:self Action:@selector(onClickDeleteBtn:) Title:@"删除"];
//    [_deletebtn setTitleColor:UIColorFromRGB(0, 170, 42) forState:UIControlStateNormal];
//    _deletebtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_deletebtn.layer setBorderColor:UIColorFromRGB(0, 170, 42).CGColor];
//    [_deletebtn.layer setBorderWidth:1];
//    [_deletebtn.layer setMasksToBounds:YES];
//    
//    [cell.contentView addSubview:_moveBtn];
//    [cell.contentView addSubview:_deletebtn];
//    
//    _moveBtn.tag=100;
//    _deletebtn.tag=101;
    
    return cell;
}


-(void)onClickMoveBtn:(UIButton *)button{
//    XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[button superview] superview];
//    NSIndexPath *path = [_myTableView indexPathForCell:cell];
//    XXEClassInfoModel *classModel = classModelArray[path.section];
//    XXEStudentInfoModel *stuModel = classModel.baby_list[path.row];
//    
//    XXEStudentManagerMoveToClassViewController *studentManagerMoveToClassVC = [[XXEStudentManagerMoveToClassViewController alloc] init];
//    
//    studentManagerMoveToClassVC.schoolId = _schoolId;
//    studentManagerMoveToClassVC.schoolType = _schoolType;
//    studentManagerMoveToClassVC.currentSelectedClassId = _classId;
//    studentManagerMoveToClassVC.babyId = stuModel.babyId;
//    
//    [self.navigationController pushViewController:studentManagerMoveToClassVC animated:YES];
}

-(void)onClickDeleteBtn:(UIButton *)button{
//    XXEStudentManagerTableViewCell *cell = (XXEStudentManagerTableViewCell *)[[button superview] superview];
//    NSIndexPath *path = [_myTableView indexPathForCell:cell];
//    XXEClassInfoModel *classModel = classModelArray[path.section];
//    XXEStudentInfoModel *stuModel = classModel.baby_list[path.row];
//    
//    //当前 所要删除 学生 的 babyid 及 所在 的classid
////    NSString *currentClassId = classModel.class_id;
////    NSString *currentBabyId = stuModel.babyId;
//    NSString *currentClassId = _class_id;
//    NSString *currentBabyId = _babyId;
//    
//    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定删除？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
//    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//#pragma mark - 删除=======================================
//        [self deleteStudentInfo:currentClassId andWithBabyId:currentBabyId andIndexPath:path];
//        
//    }];
//    [alert addAction:ok];
//    [alert addAction:cancel];
//    [self presentViewController:alert animated:YES completion:nil];
}


- (void)deleteStudentInfo:(NSString *)currentClassId andWithBabyId:(NSString *)currentBabyId andIndexPath:(NSIndexPath *)path{
    
//    XXEStudentManagerDeleteApi *studentManagerDeleteApi = [[XXEStudentManagerDeleteApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:currentClassId baby_id:currentBabyId];
//    
//    [studentManagerDeleteApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        
//        //              NSLog(@"2222---   %@", request.responseJSONObject);
//        
//        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
//        
//        if ([codeStr isEqualToString:@"1"]) {
//            
//            [self showHudWithString:@"删除成功!" forSecond:1.5];
//            //从 数据源中 删除
//            XXEClassInfoModel *classModel = classModelArray[path.section];
//            [classModel.baby_list removeObjectAtIndex:path.row];
//            //从 列表 中 删除
//            [_myTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }else{
//            
//        }
//        [_myTableView reloadData];
//        
//    } failure:^(__kindof YTKBaseRequest *request) {
//        
//        [self showHudWithString:@"提交失败!" forSecond:1.5];
//    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    
//    CGFloat labelWidth = KScreenWidth / 3;
//    UILabel *titleLabel1 = [UILabel createLabelWithFrame:CGRectMake(0, 5, labelWidth, 20) Font:14 Text:@"历史记录"];
//    titleLabel1.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:titleLabel1];
//    
//    UILabel *titleLabel2 = [UILabel createLabelWithFrame:CGRectMake(labelWidth, 5, labelWidth, 20) Font:14 Text:@""];
//    titleLabel2.text = _give_num;
//    titleLabel2.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:titleLabel2];
//    
//    UILabel *titleLabel3 = [UILabel createLabelWithFrame:CGRectMake(labelWidth * 2, 5, labelWidth, 20) Font:14 Text:@""];
//    titleLabel3.text = _flower_able;
//    titleLabel3.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:titleLabel3];
//    
//    return headerView;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    XXERedFlowerDetialViewController *redFlowerDetialVC = [[XXERedFlowerDetialViewController alloc] init];
//    
//    XXERedFlowerSentHistoryModel *model = _dataSourceArray[indexPath.row];
//    redFlowerDetialVC.name = model.tname;
//    redFlowerDetialVC.time = [XXETool dateStringFromNumberTimer:model.date_tm];
//    redFlowerDetialVC.schoolName = model.school_name;
//    redFlowerDetialVC.className = model.class_name;
//    redFlowerDetialVC.course = model.teach_course;
//    redFlowerDetialVC.content = model.con;
//    redFlowerDetialVC.picWallArray = model.pic_arr;
//    redFlowerDetialVC.iconUrl = model.head_img;
//    redFlowerDetialVC.collect_conditStr =model.collect_condit;
//    redFlowerDetialVC.collect_id = model.collectionId;
//    [self.navigationController pushViewController:redFlowerDetialVC animated:YES];
    
}


@end
