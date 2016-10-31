//
//  XXEBabyFamilyInfoViewController.m
//  teacher
//
//  Created by Mac on 16/8/29.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBabyFamilyInfoViewController.h"
#import "XXEBabyFamilyInfoDetailViewController.h"
#import "XXERongCloudAddFriendRequestApi.h"

@interface XXEBabyFamilyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEBabyFamilyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
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
    
    if ([_fromFlagStr isEqualToString:@"fromRCIM"]) {
        //从聊天界面 过来 添加 好友
        //被选中 家人 的xid
        NSString *teacherXid = _familyInfoArray[indexPath.row][@"xid"];
        [self addFriendRequestNotice:teacherXid];
    }else{
        //进入 家人 详情
        XXEBabyFamilyInfoDetailViewController *babyFamilyInfoDetailVC = [[XXEBabyFamilyInfoDetailViewController alloc] init];
        babyFamilyInfoDetailVC.baby_id = _baby_id;
        babyFamilyInfoDetailVC.parent_id = _familyInfoArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:babyFamilyInfoDetailVC animated:YES];
    }

}

- (void)addFriendRequestNotice:(NSString *)otherXid{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //
        textField.placeholder = @"申请备注";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self requestAddFriend:otherXid];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)requestAddFriend:(NSString *)otherXidStr{
    
    XXERongCloudAddFriendRequestApi *rongCloudAddFriendRequestApi = [[XXERongCloudAddFriendRequestApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:otherXidStr];
    [rongCloudAddFriendRequestApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //      NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        /*
         ★其他结果需提醒用户
         code:4	//不能请求自己
         code:5	//已经是好友了(不能对好友发起请求)
         code:6	//对方在我的黑名单中,无法发起请求!
         code:7	//您已经在对方黑名单中,无法发起请求!
         code:8	//不能重复对同一个人发起请求!
         code:9	//对方已同意,可以直接聊天了 (对方设置了任何人请求直接通过)
         */
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"请求发送成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [self showHudWithString:@"不能请求自己!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"5"]) {
            [self showHudWithString:@"对方已经是您的好友!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"6"]) {
            [self showHudWithString:@"对方在我的黑名单中,无法发起请求!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"7"]) {
            [self showHudWithString:@"您已经在对方黑名单中,无法发起请求!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"8"]) {
            [self showHudWithString:@"不能重复对同一个人发起请求!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"9"]) {
            [self showHudWithString:@"对方已同意,可以直接聊天了!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"10"]) {
            [self showHudWithString:@"添加成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHudWithString:@"请求发送失败!" forSecond:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
