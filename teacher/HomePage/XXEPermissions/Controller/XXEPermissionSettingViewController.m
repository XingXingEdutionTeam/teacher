
//
//  XXEPermissionSettingViewController.m
//  teacher
//
//  Created by Mac on 16/9/8.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEPermissionSettingViewController.h"
#import "XXEPermissionSettingTableViewCell.h"
#import "XXEGlobalPermissionSettingApi.h"
#import "XXEGlobalPermissionListApi.h"


@interface XXEPermissionSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
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
//黑名单
@property (nonatomic, copy) NSString *black_userStr;
//不让他看我的朋友圈
@property (nonatomic, copy) NSString *dt_let_him_seeStr;
//不接受对方消息
@property (nonatomic, copy) NSString *refuse_chatStr;
//不看他的朋友圈
@property (nonatomic, copy) NSString *dt_look_at_himStr;

@property (nonatomic) NSMutableArray *dataSourceArray;

//
@property (nonatomic, copy) NSString *action_nameStr;

//
@property (nonatomic, copy) NSString *action_numStr;

//
@property (nonatomic, copy) NSString *flagStr;


@end

@implementation XXEPermissionSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"权限设置";
    self.view.backgroundColor =UIColorFromRGB(229 , 232, 233);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    titleArray =[[NSMutableArray alloc]initWithObjects:@"不看他(她)的朋友圈",@"不让他(她)看我的朋友圈",@"不接受对方消息",@"拉入黑名单", nil];
    [self fetchNetData];
    
    [self createTable];
}

- (void)fetchNetData{

    XXEGlobalPermissionListApi *globalPermissionListApi = [[XXEGlobalPermissionListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:_XIDStr];
    [globalPermissionListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"权限列表 -- %@", request.responseJSONObject);
        /*
         Array
         (
         [code] => 1
         [msg] => Success!
         [data] => Array
         (
         [dt_look_at_him] => 2	// 不看他的朋友圈. 2:开启 1:关闭 (下面几个同理)
         [dt_let_him_see] => 1	//不让他看我的朋友圈
         [refuse_chat] => 1		//不接受对方消息
         [black_user] => 1		//拉入黑名单
         )
         
         )
         */
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            NSDictionary *dic = request.responseJSONObject[@"data"];
            
        _dt_look_at_himStr = dic[@"dt_look_at_him"];
        _dt_let_him_seeStr = dic[@"dt_let_him_see"];
        _refuse_chatStr = dic[@"refuse_chat"];
        _black_userStr = dic[@"black_user"];
            
        _dataSourceArray = [[NSMutableArray alloc] initWithObjects:_dt_look_at_himStr, _dt_let_him_seeStr, _refuse_chatStr, _black_userStr, nil];
            
        }else{
        
        }
      [_tableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据获取失败!" forSecond:1.5];
    }];
    
}


- (void)createTable{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
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
    
    return cell;
}
- (void)switchBtn:(UISwitch*)btn{
    //1 关闭 2 打开
    if (btn.on == YES) {
        _flagStr = @"2";
    }else{
        _flagStr = @"1";
    }
        //请求参数
        NSMutableArray *_action_nameArray = [[NSMutableArray alloc] initWithObjects:@"dt_look_at_him", @"dt_let_him_see", @"refuse_chat", @"black_user", nil];
        _action_nameStr = _action_nameArray[btn.tag - 100];
    
        _action_numStr = _flagStr;
    
    XXEGlobalPermissionSettingApi *globalPermissionSettingApi = [[XXEGlobalPermissionSettingApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:_XIDStr action_name:_action_nameStr action_num:_action_numStr];
    [globalPermissionSettingApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
//        NSLog(@"权限设置 -- %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"设置成功!" forSecond:1.5];
        }else{
        
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"数据请求失败!" forSecond:1.5];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSelector:@selector(select) withObject:nil afterDelay:0.5f];
    
}

- (void)select{
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
