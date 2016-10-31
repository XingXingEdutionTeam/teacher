

//
//  XXEModifyCodeViewController.m
//  teacher
//
//  Created by Mac on 16/10/27.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEModifyCodeViewController.h"
#import "XXEForgetPassWordViewController.h"
#import "XXEModifyCodeApi.h"


@interface XXEModifyCodeViewController ()<UITextFieldDelegate>{
    
    //标题
    UILabel *titleLabel;
    //修改密码 背景
    UIView *modifyBgView;
    
    //旧密码
    UITextField *_oldCodeTextField;
    
    //新密码1
    UITextField *_nowCodeTextField1;
    //新密码2
    UITextField *_nowCodeTextField2;
    //code icon
//    UIImageView *codeIconImageView;
    
    //忘记密码 button
    UIButton *_forgetButton;
    //确定 按钮
    UIButton *_certainButton;
    
    NSString *action_type;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXEModifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XXEBackgroundColor;
    
    self.title = @"修改密码";
    //修改登录密码  modifyLoginCode  /修改支付密码 modifyPayCode
    if ([_fromflagStr isEqualToString:@"modifyLoginCode"]) {
        action_type = @"1";
    }else if ([_fromflagStr isEqualToString:@"modifyPayCode"]){
        action_type = @"2";
    }
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
//    NSLog(@"8888888");
    
    [self createContent];
}

- (void)createContent{
    //标题
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KScreenWidth - 40, 20)];
    if ([action_type integerValue] == 1) {
        titleLabel.text = @"修改登录密码";
    }else if ([action_type integerValue] == 2){
        titleLabel.text = @"修改支付密码(原始支付密码为登录密码)";
    }
    titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [self.view addSubview:titleLabel];
    
    //背景
    modifyBgView = [[UIView alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + titleLabel.height + 10, KScreenWidth - 40, 130 * kScreenRatioHeight)];
    modifyBgView.layer.cornerRadius = 5;
    modifyBgView.layer.masksToBounds = YES;
    
    modifyBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:modifyBgView];
    
    //code icon
    CGFloat iconWidth = 30 * kScreenRatioWidth;
    CGFloat iconHeight = iconWidth;

    for (int i = 0; i < 3; i++) {
        //
        UIImageView *codeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (10 + (10 + 30) * i) * kScreenRatioHeight, iconWidth, iconHeight)];
        codeIconImageView.image = [UIImage imageNamed:@"code_icon"];
        [modifyBgView addSubview:codeIconImageView];
    }
    
    //旧密码
    CGFloat textFieldWidth = modifyBgView.width - 60 * kScreenRatioWidth;
    CGFloat textFieldHeight = 30 * kScreenRatioHeight;
    
    _oldCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(50 * kScreenRatioWidth, 10 * kScreenRatioHeight, textFieldWidth, textFieldHeight)];
    _oldCodeTextField.placeholder = @"请输入旧密码(6--20位字母或数字)";
    _oldCodeTextField.clearButtonMode = UITextFieldViewModeAlways;
    _oldCodeTextField.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];;
    _oldCodeTextField.delegate = self;
    [modifyBgView addSubview:_oldCodeTextField];

    _nowCodeTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(50 * kScreenRatioWidth, (10 + 30 + 10) * kScreenRatioHeight, textFieldWidth, textFieldHeight)];
    _nowCodeTextField1.placeholder = @"请输入新密码(6--20位字母或数字)";
    _nowCodeTextField1.clearButtonMode = UITextFieldViewModeAlways;
    _nowCodeTextField1.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];;
    _nowCodeTextField1.delegate = self;
    [modifyBgView addSubview:_nowCodeTextField1];
    
    _nowCodeTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(50 * kScreenRatioWidth, (10 + 30 + 10 + 30 + 10) * kScreenRatioHeight, textFieldWidth, textFieldHeight)];
    _nowCodeTextField2.placeholder = @"请再次输入新密码(6--20位字母或数字)";
    _nowCodeTextField2.clearButtonMode = UITextFieldViewModeAlways;
    _nowCodeTextField2.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];;
    _nowCodeTextField2.delegate = self;
    [modifyBgView addSubview:_nowCodeTextField2];

    //忘记 密码
    _forgetButton = [UIButton createButtonWithFrame:CGRectMake(KScreenWidth - 100, modifyBgView.frame.origin.y + modifyBgView.height + 10, 100, 20) backGruondImageName:nil Target:self Action:@selector(forgetButtonClick) Title:@"忘记密码?"];
    _forgetButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _forgetButton.titleLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_forgetButton];
    
    //确定 按钮
    CGFloat btnW = 325 * kScreenRatioWidth;
    CGFloat btnH = 42 * kScreenRatioHeight;
    CGFloat btnX = (KScreenWidth - btnW) / 2;
    CGFloat btnY = modifyBgView.frame.origin.y + modifyBgView.height + 50 * kScreenRatioHeight;
    _certainButton = [UIButton createButtonWithFrame:CGRectMake(btnX, btnY, btnW, btnH) backGruondImageName:@"login_green" Target:self Action:@selector(certainButtonClick) Title:@"确      定"];
    [_certainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_certainButton];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _oldCodeTextField || textField == _nowCodeTextField1 || textField == _nowCodeTextField2) {
        if (textField.text.length < 6 || textField.text.length > 20) {
            [self showHudWithString:@"请输入6--20位字母或数字" forSecond:1.5];
            textField.text = @"";
        }
    }
    
}


- (void)forgetButtonClick{
    
    XXEForgetPassWordViewController *forgetVC = [[XXEForgetPassWordViewController alloc]init];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    XXENavigationViewController *navi = [[XXENavigationViewController alloc]initWithRootViewController:forgetVC];
//    window.rootViewController = navi;
    NSLog(@"-----忘记密码-----");
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)certainButtonClick{
    
    if ([_oldCodeTextField.text isEqualToString:@""])
    {
        [self showHudWithString:@"请输入旧密码" forSecond:1.5];
        
    }else if ([_nowCodeTextField1.text isEqualToString:@""]){
        [self showHudWithString:@"请输入新密码" forSecond:1.5];
    }else if ([_nowCodeTextField2.text isEqualToString:@""]){
        
        [self showHudWithString:@"请再次输入新密码" forSecond:1.5];
    }else if (![_nowCodeTextField1.text isEqualToString:_nowCodeTextField2.text]){
        [self showHudWithString:@"您两次输入的新密码不同,请重新操作" forSecond:1.5];
    }else{
        
        [self modifyCode];
    }
    
}

- (void)modifyCode{
    /*
     【修改密码,两端通用(登陆密码和支付密码)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/edit_pass
     传参
     user_type	//用户类型 1:家长 2:教师
     old_pass	//老密码
     new_pass	//新密码
     action_type	//1: 修改登录密码   2:修改支付密码
     */
    
    XXEModifyCodeApi *modifyCodeApi = [[XXEModifyCodeApi alloc] initWithXid:parameterXid user_id:parameterUser_Id old_pass:_oldCodeTextField.text new_pass:_nowCodeTextField1.text action_type:action_type];
    [modifyCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        NSLog(@"%@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"修改成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else if ([codeStr isEqualToString:@"6"]){
            [self showHudWithString:@"旧密码错误" forSecond:1.5];
            _oldCodeTextField.text = @"";
            _nowCodeTextField1.text = @"";
            _nowCodeTextField2.text = @"";
            
//            [_oldCodeTextField setNeedsDisplay];
            
            
        }else if ([codeStr isEqualToString:@"5"]){
            [self showHudWithString:@"旧密码与新密码相同" forSecond:1.5];
            _oldCodeTextField.text = @"";
            _nowCodeTextField1.text = @"";
            _nowCodeTextField2.text = @"";
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
