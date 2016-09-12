

//
//  XXEMyselfPrivacySettingViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEMyselfPrivacySettingViewController.h"
#import "XXEPermissionSettingTableViewCell.h"
#import "XXEWhoCanSeeMyNameViewController.h"
#import "XXEMyselfPrivacySettingApi.h"
#import "XXEMyselfPrivacyApi.h"

@interface XXEMyselfPrivacySettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *titleArray;
    //请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
    UILabel *nameLabel;
    NSMutableArray *nameArray;
    
    NSMutableArray *flagNumArray;
    NSMutableArray *flagStrArray;

    //手机公开 1:班级通讯录可见  2:好友可见  3:所有人可见(含陌生人)  4:仅自己
    NSString *show_phone;
    //真实姓名公开 1:班级通讯录可见  2:好友可见  3:所有人可见(含陌生人)  4:仅自己
    NSString *show_tname;
    //搜索手机  0:公开  1:保密 (默认0)
    NSString *search_phone;
    //搜索xid   0:公开  1:保密 (默认0)
    NSString *search_xid;
    //附近      0:公开  1:保密 (默认0)
    NSString *search_nearby;
    //加好友设置0:需要同意才能加好友  1:可以直接加好友 (默认0)
    NSString *add_friend_set;
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

@implementation XXEMyselfPrivacySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私设置";
    self.view.backgroundColor =UIColorFromRGB(229 , 232, 233);
    
    
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    titleArray =[[NSMutableArray alloc]initWithObjects:@"实名对谁可见:",@"手机号对谁可见:",@"允许被附近的人查看:",@"通过猩猩ID搜索到我:",@"通过手机号搜索到我:",@"直接通过加好友请求:", nil];
    
    [self createTable];
    [self fetchNetData];
}

- (void)fetchNetData{
    XXEMyselfPrivacyApi *myselfPrivacyApi = [[XXEMyselfPrivacyApi alloc] initWithXid:parameterXid user_id:parameterUser_Id];
    [myselfPrivacyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
                NSLog(@"111   %@", request.responseJSONObject);
        /*
         [show_phone] => 1		//0手机公开 1:班级通讯录可见  2:好友可见  3:所有人可见(含陌生人)  4:仅自己
         [show_tname] => 1		//真实姓名公开 1:班级通讯录可见  2:好友可见  3:所有人可见(含陌生人)  4:仅自己
         [search_phone] => 0		//搜索手机  0:公开  1:保密 (默认0)
         [search_xid] => 0		//搜索xid   0:公开  1:保密 (默认0)
         [search_nearby] => 0	//附近      0:公开  1:保密 (默认0)
         [add_friend_set] => 0	//加好友设置0:需要同意才能加好友  1:可以直接加好友 (默认0)
         */
        
//        flagNumArray = [[NSMutableArray alloc] init];
//        flagStrArray = [[NSMutableArray alloc] init];
        
        NSDictionary *dict = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dict[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dic = dict[@"data"];
            NSString *str1;
            NSInteger t1 = [dic[@"show_tname"] integerValue];
            if (t1 == 1) {
               str1 = @"班级联系人";
            }else if (t1 == 2) {
                str1 = @"好友";
            }else if (t1 == 3) {
                str1 = @"所有人";
            }else if (t1 == 4) {
                str1 = @"仅自己";
            }
            
            NSString *str2;
            NSInteger t2 = [dic[@"show_phone"] integerValue];
            if (t2 == 1) {
                str2 = @"班级联系人";
            }else if (t2 == 2) {
                str2 = @"好友";
            }else if (t2 == 3) {
                str2 = @"所有人";
            }else if (t2 == 4) {
                str2 = @"仅自己";
            }
            
            nameArray = [[NSMutableArray alloc] initWithObjects:str1, str2, dic[@"search_nearby"], dic[@"search_xid"], dic[@"search_phone"], dic[@"add_friend_set"], nil];
        }else{
            
        }
        
        [_tableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"请求失败" forSecond:1.f];
    }];


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
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.switchButton.hidden = YES;
        
        nameLabel = [UILabel createLabelWithFrame:CGRectMake(KScreenWidth - 100 * kScreenRatioWidth, 10, 100 * kScreenRatioWidth, 20) Font:14.0 Text:nameArray[indexPath.row]];
        
        [cell.contentView addSubview:nameLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
    
        cell.switchButton.tag =indexPath.row +100;
        if ( [nameArray[indexPath.row] integerValue] == 1) {
            cell.switchButton.on = NO;
        }else if([nameArray[indexPath.row] integerValue] == 0){
            cell.switchButton.on = YES;
        }
        [cell.switchButton addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (void)switchBtn:(UISwitch*)btn{
    //0 打开 1 关闭
    if (btn.on == YES) {
        _flagStr = @"0";
    }else{
        _flagStr = @"1";
    }
    
    [nameArray replaceObjectAtIndex:btn.tag - 100 withObject:_flagStr];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //@"实名对谁可见:",@"手机号对谁可见:",@"允许被附近的人查看:",@"通过猩猩ID搜索到我:",@"通过手机号搜索到我:",@"直接通过加好友请求:",
    if (indexPath.row == 0) {
        //实名对谁可见
        XXEWhoCanSeeMyNameViewController *whoCanSeeMyNameVC = [[XXEWhoCanSeeMyNameViewController alloc] init];
        [whoCanSeeMyNameVC returnText:^(NSString *showText) {
            if (showText != nil) {
                [nameArray replaceObjectAtIndex:indexPath.row withObject:showText];
                [_tableView reloadData];
            }
         }];
        [self.navigationController pushViewController:whoCanSeeMyNameVC animated:YES];

    }else if (indexPath.row == 1){
        //手机号对谁可见
        XXEWhoCanSeeMyNameViewController *whoCanSeeMyNameVC = [[XXEWhoCanSeeMyNameViewController alloc] init];
        [whoCanSeeMyNameVC returnText:^(NSString *showText) {
            
            if (showText != nil) {
                [nameArray replaceObjectAtIndex:indexPath.row withObject:showText];
                [_tableView reloadData];
            }
            
        }];
        [self.navigationController pushViewController:whoCanSeeMyNameVC animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSString *str1;
    if ([nameArray[0] isEqualToString:@"班级联系人"]) {
        str1 = @"1";
    }else if ([nameArray[0] isEqualToString:@"好友"]) {
        str1 = @"2";
    }else if ([nameArray[0] isEqualToString:@"所有人"]) {
        str1 = @"3";
    }else if ([nameArray[0] isEqualToString:@"仅自己"]) {
        str1 = @"4";
    }
    
    NSString *str2;
    if ([nameArray[1] isEqualToString:@"班级联系人"]) {
        str2 = @"1";
    }else if ([nameArray[1] isEqualToString:@"好友"]) {
        str2 = @"2";
    }else if ([nameArray[1] isEqualToString:@"所有人"]) {
        str2 = @"3";
    }else if ([nameArray[1] isEqualToString:@"仅自己"]) {
        str2 = @"4";
    }

//    NSLog(@"str1:%@ -- str2:%@ -- nameArray:%@", str1, str2, nameArray);
    
    XXEMyselfPrivacySettingApi *myselfPrivacySettingApi = [[XXEMyselfPrivacySettingApi alloc] initWithXid:parameterXid user_id:parameterUser_Id show_tname:str1 show_phone:str2 search_nearby:nameArray[2] search_xid:nameArray[3] search_phone:nameArray[4] add_friend_set:nameArray[5]];
    [myselfPrivacySettingApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"%@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"设置成功!" forSecond:1.5];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
            
        }else{
            
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"设置失败,请检查网络!" forSecond:1.5];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
