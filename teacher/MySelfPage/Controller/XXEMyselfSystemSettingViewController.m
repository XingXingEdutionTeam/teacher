

//
//  XXEMyselfSystemSettingViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfSystemSettingViewController.h"
#import "XXEPermissionSettingTableViewCell.h"
#import "XXEAboutMyselfInfoViewController.h"
#import "XXEProblemFeedbackViewController.h"

@interface XXEMyselfSystemSettingViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *titleArray;
    //请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

/*
 //2:开启 1:关闭 (下面几个同理)
 */
//消息提醒
@property (nonatomic, copy) NSString *black_userStr;
//消息提醒音
@property (nonatomic, copy) NSString *dt_let_him_seeStr;
//非WIFI网络播放提醒
@property (nonatomic, copy) NSString *refuse_chatStr;

@property (nonatomic) NSMutableArray *dataSourceArray;

//
@property (nonatomic, copy) NSString *flagStr;


@end

@implementation XXEMyselfSystemSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    self.view.backgroundColor =UIColorFromRGB(229 , 232, 233);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    titleArray =[[NSMutableArray alloc]initWithObjects:@"消息提醒",@"消息提醒音",@"非WIFI网络播放提醒",@"关于我们", @"分享", @"去AppleStore评分", @"清除缓存", @"反馈问题送猩币", nil];
    
    [self createTable];
}


- (void)createTable{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEPermissionSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEPermissionSettingTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.titleLabel.text =titleArray[indexPath.row];
    cell.switchButton.tag =indexPath.row +100;
    if ( [_dataSourceArray[indexPath.row] integerValue] == 1) {
        cell.switchButton.on = NO;
    }else if([_dataSourceArray[indexPath.row] integerValue] == 2){
        cell.switchButton.on = YES;
    }
    [cell.switchButton addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row > 2 && indexPath.row < 8) {
        cell.switchButton.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (void)switchBtn:(UISwitch*)btn{
    //1 关闭 2 打开
    if (btn.on == YES) {
        _flagStr = @"2";
    }else{
        _flagStr = @"1";
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//@"消息提醒",@"消息提醒音",@"非WIFI网络播放提醒",@"关于我们", @"分享", @"去AppleStore评分", @"清除缓存", @"反馈问题送猩币",
    if (indexPath.row == 0) {
        //消息提醒
        
    }else if (indexPath.row == 1){
        //消息提醒音

    }else if (indexPath.row == 2){
        //非WIFI网络播放提醒
    
    }else if (indexPath.row == 3){
        //关于我们
        XXEAboutMyselfInfoViewController *aboutMyselfInfoVC = [[XXEAboutMyselfInfoViewController alloc] init];
        
        [self.navigationController pushViewController:aboutMyselfInfoVC animated:YES];
        
    }else if (indexPath.row == 4){
        //分享
    
    }else if (indexPath.row == 5){
        //去AppleStore评分
    
    }else if (indexPath.row == 6){
        //清除缓存
//        [self clearCacheFlies];
        [self createAlertView];
        
    }else if (indexPath.row == 7){
        //反馈问题送猩币
        XXEProblemFeedbackViewController *problemFeedbackVC = [[XXEProblemFeedbackViewController alloc] init];
        
        [self.navigationController pushViewController:problemFeedbackVC animated:YES];
    }
}

- (void)createAlertView{
    //清除缓存计算缓存大小
    // 获取要清除缓存的路径
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    // 调用folderSizeAtPath方法计算缓存路径下的文件size
    CGFloat fileSize = [self folderSizeAtPath:cachPath];
    NSString *str = [NSString stringWithFormat:@"缓存%.1fM", fileSize];
    //    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES));
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:@"确定清除数据缓存?"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            //取消
            break;
            
        case 1:
        {
            [self clearCacheFlies];
            
        }
            break;
    }
}

//二、计算缓存cache文件夹下文件大小。
//单个文件的大小
- (CGFloat)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        return[[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
    
}


//遍历文件夹获得文件夹大小，返回多少M
- (float) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize =0;
    
    while((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);//得到缓存大小M
    
}

//一、清理缓存cache文件夹，删除文件方法
-(void)clearCacheFlies
{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//        NSLog(@"files :%ld",[files count]);
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                // 删除缓存
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
            NSLog(@"清理成功！");
        }
        [self showHudWithString:@"清除成功!" forSecond:1.5];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
