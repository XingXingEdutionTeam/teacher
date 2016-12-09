//
//  XXEPerfectInfoViewController.m
//  teacher
//
//  Created by codeDing on 16/9/2.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEPerfectInfoViewController.h"
#import "XXETabBarControllerConfig.h"
#import "XXESearchUniversityController.h"
#import "XXEEditorMySelfInfoApi.h"
#import "XXETeacherTableViewCell.h"
#import "XXEPerfectInfoViewCell.h"
#import "XXESearchUNModel.h"
#import "XXESelectMessageView.h"
@interface XXEPerfectInfoViewController ()<XXESearchSchoolNUMessageDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>{
    
    NSArray *_titleArr;
    NSArray *_titleTextArr;
    NSMutableArray *_perFectYear;
}

@property (nonatomic, strong)XXESearchUniversityController *searchUNVC;
@property (nonatomic, strong)NSMutableArray *perfectInfoDatasource;
/** 单元格 */
@property (nonatomic, strong)UITableView *perfectTableView;
/** 单元格 */
@property (nonatomic, strong)XXETeacherTableViewCell *perfectCell;
@property (nonatomic, strong)XXEPerfectInfoViewCell *perfectInfoCell;
/** 学校的ID */
@property (nonatomic, copy)NSString *perfectSchoolId;
/** 学校的专业 */
@property (nonatomic, copy)NSString *perfectSpecialty;
/** 教学年限 */
@property (nonatomic, copy)NSString *perfectExperYear;
/** 经历 */
@property (nonatomic, copy)NSString *perfectLift;
/** 感悟 */
@property (nonatomic, copy)NSString *perfectFeed;
@end

static NSString *IdentifierPerCELL = @"TeacherCell";
static NSString *IdentifierMessPerCELL = @"TeacherMessCell";

@implementation XXEPerfectInfoViewController

- (NSMutableArray *)perfectInfoDatasource
{
    if (!_perfectInfoDatasource) {
        _perfectInfoDatasource = [NSMutableArray array];
    }
    return _perfectInfoDatasource;
}


- (UITableView *)perfectTableView
{
    if (!_perfectTableView) {
        _perfectTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 500*kScreenRatioHeight) style:UITableViewStyleGrouped];
        _perfectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _perfectTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = XXEBackgroundColor;
    self.navigationItem.title = @"完善信息";
    self.navigationController.navigationBarHidden = NO;
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(-10,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    if ([self.perfectSchoolId isEqualToString:@""]) {
        //警告试图
        [self setupWarnView];
    }
    //布局页面
    [self setupPerfectView];
}

/** 这个方法都可以,改变当前控制器的电池条颜色 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化所有的信息
    [self initializationParame];
    
    _titleArr = @[@"毕业院校:",@"所学专业:",@"教学年限:",@"从教经历:",@"教学感悟"];
    
    _titleTextArr = @[@"请点击搜索按钮,选择毕业院校",@"请输入所学专业",@"教龄",@"",@""];
    NSArray *array = @[@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年",@"11年",@"12年",@"13年",@"14年",@"15年",@"16年",@"17年",@"18年",@"19年",@"20年",@"21年",@"22年",@"23年",@"年24",@"25年",@"26年",@"27年",@"28年",@"29年",@"30年",@"31年",@"32年",@"33年",@"34年",@"35年",@"36年",@"37年",@"38年",@"39年",@"40年",@"41年",@"42年",@"43年",@"44年",@"45年",@"46年",@"47年",@"48年",@"49年",@"50年",@"51年",@"52年",@"53年",@"54年",@"55年",@"56年",@"57年",@"58年",@"59年",@"60年"];
    _perFectYear = [array copy];
    
    self.perfectTableView.delegate = self;
    self.perfectTableView.dataSource = self;
    [self.perfectTableView registerNib:[UINib nibWithNibName:@"XXETeacherTableViewCell" bundle:nil] forCellReuseIdentifier:IdentifierPerCELL];
    [self.perfectTableView registerNib:[UINib nibWithNibName:@"XXEPerfectInfoViewCell" bundle:nil] forCellReuseIdentifier:IdentifierMessPerCELL];
    [self.view addSubview:self.perfectTableView];
}
//初始化
- (void)initializationParame
{
    self.perfectSchoolId = @"";
    self.perfectFeed = @"";
    self.perfectLift = @"";
    self.perfectExperYear = @"";
    self.perfectSpecialty = @"";
    self.perfectCell = [self cellAtIndexRow:1 andAtSection:0 Message:@""];
    self.perfectCell = [self cellAtIndexRow:2 andAtSection:0 Message:@""];
}

#pragma mark - UITableViewDelegate  UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3 || indexPath.row == 4) {
        return 132*kScreenRatioHeight;
    }else {
        return 53*kScreenRatioHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        _perfectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
    

    if (indexPath.row == 3 || indexPath.row== 4) {
        XXEPerfectInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierMessPerCELL forIndexPath:indexPath];
        cell.perFectLabel.text = [_titleArr objectAtIndex:indexPath.row];
        
        return cell;
    }
    else {
        XXETeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierPerCELL forIndexPath:indexPath];
        cell.teacherRegisLabel.text = [_titleArr objectAtIndex:indexPath.row];
        cell.teacherRegisTextField.placeholder = [_titleTextArr objectAtIndex:indexPath.row];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    switch (indexPath.row) {
        case 1:{
            self.perfectCell = [self cellAtIndexRow:1 andAtSection:0 Message:@""];
            [self tureOrFalseCellClick:YES Tag:200];
            break;
        }
        case 2:{
            XXESelectMessageView *perfectYear = [[XXESelectMessageView alloc]initWithTWFrame:self.view.bounds TWselectCityTitle:@"教学年限" MessageArray:_perFectYear];
            [perfectYear showCityView:^(NSString *proviceStr) {
                self.perfectCell = [self cellAtIndexRow:2 andAtSection:0 Message:proviceStr];
                self.perfectExperYear = proviceStr;
            }];
        }
        case 3:{
            self.perfectInfoCell = [self cellInfoAtIndexRow:3 andAtSection:0 Message:@""];
            [self tureOrFalseInfoCellClick:YES Tag:400];
            break;
        }
        case 4:{
            self.perfectInfoCell = [self cellInfoAtIndexRow:4 andAtSection:0 Message:@""];
            [self tureOrFalseInfoCellClick:YES Tag:500];
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - 判断单元格能不能点击
- (void)tureOrFalseCellClick:(BOOL)click Tag:(NSInteger)tags
{
    self.perfectCell.teacherRegisTextField.enabled = click;
    self.perfectCell.teacherRegisTextField.tag = tags;
    self.perfectCell.teacherRegisTextField.delegate = self;
}

- (void)tureOrFalseInfoCellClick:(BOOL)click Tag:(NSInteger)tags
{
    self.perfectInfoCell.perFectTextView.editable = click;
    self.perfectInfoCell.perFectTextView.tag = tags;
    self.perfectInfoCell.perFectTextView.delegate = self;
}

- (void)setupPerfectView
{
    //添加按钮
    __weak typeof(self)weakSelf = self;
    UIButton *sureButton = [[UIButton alloc]init];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"login_green"] forState:UIControlStateNormal];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.perfectTableView.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(335*kScreenRatioWidth, 41*kScreenRatioHeight));
    }];
}

#pragma mark - 搜索的按钮点击事件
- (void)searchButtonClick:(UIButton *)sender
{  NSLog(@"点击搜搜");
    XXESearchUniversityController *searchUNVC = [[XXESearchUniversityController alloc]init];
    self.searchUNVC = searchUNVC;
    [searchUNVC returnArray:^(NSMutableArray *mArr) {
        
        [self initializationParame];
        self.perfectInfoDatasource = mArr;
        self.searchUNVC.delegate = self;
    }];
    [self.navigationController pushViewController:searchUNVC animated:YES];
}

#pragma mark - 搜索的代理方法
- (void)searchSchoolNUMessage:(XXESearchUNModel *)model
{
    NSLog(@"%@",model);
    NSLog(@"%@",model.schoolName);
//    NSString *schoolAdd = [NSString stringWithFormat:@"%@%@%@",model.schoolProvince,model.schoolCity,model.schoolDistrict];
    self.perfectCell = [self cellAtIndexRow:0 andAtSection:0 Message:model.schoolName];
//    self.perfectCell = [self cellAtIndexRow:1 andAtSection:0 Message:schoolAdd];
    self.perfectSchoolId = model.schoolId;
}

//获取tableView的cell
- (XXETeacherTableViewCell *)cellAtIndexRow:(NSInteger)row andAtSection:(NSInteger) section Message:(NSString *)message
{
    XXETeacherTableViewCell *cell = [_perfectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    cell.teacherRegisTextField.text = message;
    return cell;
}

- (XXEPerfectInfoViewCell *)cellInfoAtIndexRow:(NSInteger)row andAtSection:(NSInteger)section Message:(NSString *)message
{
    XXEPerfectInfoViewCell *cell = [_perfectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}

#pragma mark  - UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 200:
            self.perfectSpecialty = textField.text;
            break;
        default:
            break;
    }
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    NSLog(@"开始编辑");
//    
//    switch (textView.tag) {
//        case 500:
//        {
//            self.perfectTableView.frame = CGRectMake(0, -144, KScreenWidth, 500*kScreenRatioHeight);
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case 400:
            NSLog(@"经历:%@",textView.text);
            self.perfectLift = textView.text;
            break;
        case 500:
            self.perfectFeed = textView.text;
            break;
            
        default:
            break;
    }
    
}

#pragma mark - ActionButton
- (void)sureButtonClick:(UIButton *)sender
{
    NSLog(@"学校ID%@ 所学专业%@ 经历%@ 感受%@ 教育年限%@",self.perfectSchoolId,self.perfectSpecialty,self.perfectLift,self.perfectFeed,self.perfectExperYear);
    
    if ([self.perfectSchoolId isEqualToString:@""]) {
        [self showString:@"请选择毕业院校" forSecond:1.f];
    }else if ([self.perfectSpecialty isEqualToString:@""]){
        [self showString:@"请填写专业" forSecond:1.f];
    }else{
        [self sureChangeMessage];
    }
}

- (void)sureChangeMessage
{
    NSString *strngXid;
    NSString *homeUserId;
    if ([XXEUserInfo user].login) {
        strngXid = [XXEUserInfo user].xid;
        homeUserId = [XXEUserInfo user].user_id;
    }else {
        strngXid = XID;
        homeUserId = USER_ID;
    }
    XXEEditorMySelfInfoApi *editorApi = [[XXEEditorMySelfInfoApi alloc]initWithEditorInfoUserXid:strngXid UserID:homeUserId NickName:@"" Phone:@"" Email:@"" TeachLife:self.perfectLift TeachFeel:self.perfectFeed GraduateSchoolId:self.perfectSchoolId Specialyt:self.perfectSpecialty ExperYear:self.perfectExperYear PersonalSign:@"" file:@""];
    [editorApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
        NSLog(@"%@",[request.responseJSONObject objectForKey:@"msg"]);
        NSString *code = [request.responseJSONObject objectForKey:@"code"];
        if ([code intValue]== 1) {
            [self showString:@"完善资料成功" forSecond:2.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = tabBarControllerConfig;
                [self.view removeFromSuperview];
            });
            
        }else{
            [self showString:@"完善失败" forSecond:1.f];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [self showString:@"网络请求失败" forSecond:1.f];
    }];

}

- (void)setupWarnView
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否完善信息赚取200猩币" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"完善" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"跳过" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        XXETabBarControllerConfig *tabBarControllerConfig = [[XXETabBarControllerConfig alloc]init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = tabBarControllerConfig;
        [self.view removeFromSuperview];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.perfectInfoCell.perFectTextView resignFirstResponder];
    [self.perfectCell.teacherRegisTextField resignFirstResponder];
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
