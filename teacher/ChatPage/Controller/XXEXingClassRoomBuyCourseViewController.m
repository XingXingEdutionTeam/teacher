

//
//  XXEXingClassRoomBuyCourseViewController.m
//  teacher
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomBuyCourseViewController.h"
#import "XXECreateCourseOrderApi.h"



@interface XXEXingClassRoomBuyCourseViewController ()<UITextFieldDelegate>
{
    //科目
    UIView *subjectBgView;
    //人数
    UIView *peopleNumBgView;
    UITextField *numTextField;
    
    //学生姓名
    UIView *nameBackgroundView;
    
    //联系方式
    UIView *phoneBgView;
    UITextField *phoneTextField;
    
    //支付
    UIView *payBgView;
    
    UIButton *payButton;
    
    UITextField *coinTextField;
    UILabel *moneyLabel;
    
    NSInteger num;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    

    NSString *buy_num;			//购买数量(报名人数)
    NSString *baby_name;		//孩子名字,多个用逗号隔开
    NSString *parent_phone;		//手机号
    NSString *deduct_coin;		//抵扣猩币数
    NSString *deduct_price;		//抵扣金额
    NSString *pay_price;		//实付金额
    
    NSString *baby_name1;
    NSString *baby_name2;
    NSString *baby_name3;
    NSString *baby_name4;
    
    UILabel *deductionLabel;//可抵扣 标题
    CGFloat deduct1; //抵扣金额
    CGFloat deduct2; //抵扣金额 上限
}



@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation XXEXingClassRoomBuyCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    buy_num = @"1";
    baby_name = @"";
    parent_phone = @"";
    deduct_coin = @"";
    deduct_price = @"";
    pay_price = @"";
    baby_name1 = @"";
    baby_name2 = @"";
    baby_name3 = @"";
    baby_name4 = @"";
    
    self.pictureArray =[[NSMutableArray alloc]initWithObjects:@"home_redflower_courseIcon", @"peoplenum_icon_40x40", @"babyinfo_tname_icon", @"home_logo_phone_icon40x40", nil];

    [self createContent];
    
}

- (void)createContent{
    //=================== 科目 ==================
    subjectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    subjectBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:subjectBgView];
    
    //科目头像
    UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    icon1.image = [UIImage imageNamed:self.pictureArray[0]];
    [subjectBgView addSubview:icon1];
    //科目标题
    UILabel *subjectLabel = [UILabel createLabelWithFrame:CGRectMake(icon1.frame.origin.x + icon1.frame.size.width + 5, 10, 40, 20) Font:14 Text:@"科目:"];
    subjectLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [subjectBgView addSubview:subjectLabel];
    //科目内容
    UILabel *subLabel = [UILabel createLabelWithFrame:CGRectMake(subjectLabel.frame.origin.x + subjectLabel.frame.size.width + 5, 10, KScreenWidth - 100, 20) Font:14 Text:_dict[@"course_name"]];
    subLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [subjectBgView addSubview:subLabel];
    
    //====================== 人数==================
    peopleNumBgView = [[UIView alloc] initWithFrame:CGRectMake(0, subjectBgView.frame.origin.y + subjectBgView.frame.size.height + 5, KScreenWidth, 40)];
    peopleNumBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:peopleNumBgView];
    
    //人数 头像
    UIImageView *icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    icon2.image = [UIImage imageNamed:self.pictureArray[1]];
    [peopleNumBgView addSubview:icon2];
    //人数 标题
    UILabel *numberLabel = [UILabel createLabelWithFrame:CGRectMake(icon2.frame.origin.x + icon2.frame.size.width + 5, 10, 40, 20) Font:14 Text:@"人数:"];
    numberLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [peopleNumBgView addSubview:numberLabel];
    //人数 内容
    numTextField = [[UITextField alloc] initWithFrame:CGRectMake(numberLabel.frame.origin.x + numberLabel.frame.size.width + 5, 6, KScreenWidth - 100, 30)];
    numTextField.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    numTextField.delegate = self;
    numTextField.placeholder = @"请输入购买人数(1~4)";
    numTextField.text = @"1";
    numTextField.keyboardType = UIKeyboardTypeNumberPad;
    [peopleNumBgView addSubview:numTextField];
    //==================== 学生姓名============
    [self createNameContent];
}

- (void)createNameContent{
    if (nameBackgroundView) {
        [nameBackgroundView removeFromSuperview];
    }
    
    nameBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, peopleNumBgView.frame.origin.y + peopleNumBgView.frame.size.height + 5 , KScreenWidth, 40 + 45 * ([buy_num integerValue] - 1))];
    [self.view addSubview:nameBackgroundView];
    NSString *newStr = @"";
    
        for (int i = 0; i < [buy_num integerValue]; i++) {
            UIView  *nameBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 * i, KScreenWidth, 40)];
            nameBackgroundView.backgroundColor = [UIColor whiteColor];
            [nameBackgroundView addSubview:nameBgView];
            
            //人数 头像
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
            icon.image = [UIImage imageNamed:self.pictureArray[2]];
            [nameBgView addSubview:icon];
            //人数 标题
            UILabel *nameLabel = [UILabel createLabelWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 5, 10, 40, 20) Font:14 Text:@"人数:"];
            nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
            [nameBgView addSubview:nameLabel];
            //人数 内容
            UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 5, 6, KScreenWidth - 100, 30)];
            nameTextField.placeholder = @"请输入学生姓名";
            nameTextField.delegate = self;
            nameTextField.tag = 1 + i;
//            newStr = [NSString stringWithFormat:@"%@,%@", newStr, nameTextField.text];
            nameTextField.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
            [nameBgView addSubview:nameTextField];
        }
    
    baby_name = newStr;
//    NSLog(@"baby_name ***  %@", baby_name);
    
    //==================== 联系方式 ===========
        if (phoneBgView) {
            [phoneBgView removeFromSuperview];
        }
       [self createPhoneContent];
    
    //==================== 支付 ===========
    if (payBgView) {
        [payBgView removeFromSuperview];
    }
    [self createPayContent];
    
    //============== 支付 按钮 =============
    if (payButton) {
        [payButton removeFromSuperview];
    }
    
    [self createPayButton];
}

- (void)createPhoneContent{
    phoneBgView = [[UIView alloc] initWithFrame:CGRectMake(0, nameBackgroundView.frame.origin.y + nameBackgroundView.frame.size.height + 5 , KScreenWidth, 40)];
    phoneBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneBgView];
    
    //联系方式 头像
    UIImageView *icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    icon3.image = [UIImage imageNamed:self.pictureArray[3]];
    [phoneBgView addSubview:icon3];
    //联系方式 标题
    UILabel *phoneLabel = [UILabel createLabelWithFrame:CGRectMake(icon3.frame.origin.x + icon3.frame.size.width + 5, 10, 40, 20) Font:14 Text:@"联系方式:"];
    phoneLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [phoneBgView addSubview:phoneLabel];
    //联系方式 内容
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneLabel.frame.origin.x + phoneLabel.frame.size.width + 5, 6, KScreenWidth - 100, 30)];
    phoneTextField.placeholder = @"请输入联系方式";
    phoneTextField.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneBgView addSubview:phoneTextField];

}

- (void)createPayContent{
    payBgView = [[UIView alloc] initWithFrame:CGRectMake(0, phoneBgView.frame.origin.y + phoneBgView.frame.size.height + 5, KScreenWidth, 160)];
    payBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payBgView];
    
    //间隔线
    for (int i = 1; i < 4; i ++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, payBgView.size.height/4 *i, KScreenWidth - 40, 1)];
        line.backgroundColor = UIColorFromRGB(229, 232, 233);
        [payBgView addSubview:line];
    }
    
    //合计
    CGFloat totalMoney1 = [_dict[@"now_price"] floatValue]* [numTextField.text floatValue];
    UILabel *totalLabel = [UILabel createLabelWithFrame:CGRectMake(KScreenWidth - 200, 10, 180, 20) Font:14 Text:[NSString stringWithFormat:@"%.2f元", totalMoney1]];
    totalLabel.textAlignment = NSTextAlignmentRight;
    [payBgView addSubview:totalLabel];
    
    //猩币 抵扣
    //[coin] => 0				//0:不允许猩币抵扣  1:允许猩币抵扣
    //左边✔️按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(KScreenWidth / 4, 10 + 40 *1, 18, 18);
    [btn setBackgroundImage:[UIImage imageNamed:@"report_unselected_icon"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"report_selected_icon"] forState:UIControlStateSelected];
    
    [payBgView addSubview:btn];
    
    //输入 兑换金币数
    coinTextField = [[UITextField alloc] initWithFrame:CGRectMake(btn.frame.origin.x + btn.width + 5, 10 + 40 *1, 100, 25)];
    coinTextField.delegate = self;
    coinTextField.textAlignment = NSTextAlignmentCenter;
    coinTextField.placeholder = @"兑换猩币数";
    coinTextField.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    [payBgView addSubview:coinTextField];
    
    UIImage *btnImage = [[UIImage alloc] init];
    
    if ([_dict[@"coin"] integerValue ] == 0) {
        btnImage = [UIImage imageNamed:@"report_unselected_icon"];
        coinTextField.enabled = NO;
        coinTextField.placeholder = @"不支持猩币抵扣";
        
    }else if ([_dict[@"coin"] integerValue] == 1){
        coinTextField.placeholder = @"支持猩币抵扣";
        btnImage = [UIImage imageNamed:@"report_selected_icon"];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
         coinTextField.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    
    //可抵扣 ......
    deductionLabel = [UILabel createLabelWithFrame:CGRectMake(KScreenWidth - 200, 10 + 40 *1, 180, 20) Font:10 Text:@""];
    deductionLabel.textAlignment = NSTextAlignmentRight;
    deductionLabel.text = @"个猩币 可抵扣0元";
    [payBgView addSubview:deductionLabel];
    
    //=================== 实付 金额=====================
    moneyLabel = [UILabel createLabelWithFrame:CGRectMake(KScreenWidth - 200, 10 + 40 *2, 180, 20) Font:14 Text:@""];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.text = [NSString stringWithFormat:@"%.2f元", totalMoney1];
    [payBgView addSubview:moneyLabel];
    
    //================= 说明 ==========================
    UILabel *declareLabel = [UILabel createLabelWithFrame:CGRectMake(KScreenWidth / 3, 10 + 40 *3, KScreenWidth / 2, 20) Font:14 Text:@"特别说明:发票请到机构前台领取"];
    declareLabel.font = [UIFont systemWithIphone6P:14 Iphone6:12 Iphone5:10 Iphone4:8];
    [payBgView addSubview:declareLabel];


}


- (void)createPayButton{

    CGFloat buttonWidth = 325 * kScreenRatioWidth;
    CGFloat buttonHeight = 42 * kScreenRatioHeight;
    
    payButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth) / 2, payBgView.frame.origin.y + payBgView.height + 20, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(payButtonClick:) Title:@"立即支付"];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:payButton];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == numTextField) {
        if (numTextField.text != nil && [numTextField.text integerValue] >0 && [numTextField.text integerValue] <= 4) {
            buy_num = numTextField.text;
            [self createNameContent];
            
        }else if ([numTextField.text integerValue] > 4){
            [self showHudWithString:@"最多只能输入4个人" forSecond:1.5];
        }else if ([numTextField.text integerValue]  <= 0){
            [self showHudWithString:@"请输入1~4" forSecond:1.5];
        }
    }else if (textField.tag == 1){
    baby_name1 = textField.text;
        
    }else if (textField.tag == 2){
    baby_name2 = textField.text;
    
    }else if (textField.tag == 3){
    baby_name3 = textField.text;
        
    }else if (textField.tag == 4){
    baby_name4 = textField.text;
        
    }else if (textField == coinTextField){
        if (![coinTextField.text isEqualToString:@""]) {
            /*
             [now_price] => 1800			//单个课程现价
             [coin_deduct_per] => 0.010		//猩币抵扣率,  抵扣金额=猩币数*抵扣率
             [coin_deduct_per_limit] => 0.050	//猩币抵金额上限率, 金额上限=合计金额*金额上限率
             [coin_able] => 3000			//用户可用猩币(用户输入的猩币不能超过可用猩币)
             */
            //抵扣的金额 <= 抵扣金额上限
            // 抵扣金额
            deduct1 = [coinTextField.text floatValue] * [_dict[@"coin_deduct_per"] floatValue];
            //抵扣金额上限
            deduct2 = [numTextField.text floatValue] * [_dict[@"now_price"] floatValue] * [_dict[@"coin_deduct_per_limit"] floatValue];
            
            //用户输入的抵扣猩币数 <= 用户可用猩币数
            if ([coinTextField.text integerValue] > [_dict[@"coin_able"] integerValue]) {
                [self showHudWithString:[NSString stringWithFormat:@"最多可使用%@个猩币", _dict[@"coin_able"]] forSecond:1.5];
            }else if(deduct1 > deduct2){
                NSString *str = [NSString stringWithFormat:@"抵扣金额上限为%lf", deduct2];
                [self showHudWithString:str forSecond:1.5];
            }else{
            
                deductionLabel.text = [NSString stringWithFormat:@"个猩币 可抵扣%.2f元", deduct1];
                moneyLabel.text = [NSString stringWithFormat:@"%.2f元", [_dict[@"now_price"] floatValue]* [numTextField.text floatValue] - deduct1];
            }
        }
    
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)btnClick{



}

- (void)payButtonClick:(UIButton *)button{

    if ([numTextField.text integerValue] == 1) {
        if ([baby_name1 isEqualToString:@""]) {
            [self showHudWithString:@"请完善学生名称" forSecond:1.5];
        }else if ([phoneTextField.text isEqualToString:@""]) {
            [self showHudWithString:@"请完善联系方式" forSecond:1.5];
        }else if ([self isChinaMobile:phoneTextField.text] == NO) {
            [self showHudWithString:@"请核对手机号" forSecond:1.5];
        }else if ([moneyLabel.text isEqualToString:@""]) {
            [self showHudWithString:@"请核对支付金额" forSecond:1.5];
        }else {
            baby_name = baby_name1;
            parent_phone = phoneTextField.text;
            pay_price = moneyLabel.text;
            
            [self createCoursePayOrder];
        
        }
    
    }else if ([numTextField.text integerValue] == 2) {
        if ([baby_name1 isEqualToString:@""] || [baby_name2 isEqualToString:@""]) {
            [self showHudWithString:@"请完善学生名称" forSecond:1.5];
        }else if ([phoneTextField.text isEqualToString:@""]) {
            [self showHudWithString:@"请完善联系方式" forSecond:1.5];
        }else if ([self isChinaMobile:phoneTextField.text] == NO) {
            [self showHudWithString:@"请核对手机号" forSecond:1.5];
        }else if ([moneyLabel.text isEqualToString:@""]) {
            [self showHudWithString:@"请核对支付金额" forSecond:1.5];
        }else {
            baby_name = [NSString stringWithFormat:@"%@,%@", baby_name1, baby_name2];
            parent_phone = phoneTextField.text;
            pay_price = moneyLabel.text;
            
            [self createCoursePayOrder];
            
        }
        
    }else if ([numTextField.text integerValue] == 3){
        if ([baby_name1 isEqualToString:@""] || [baby_name2 isEqualToString:@""] || [baby_name3 isEqualToString:@""]) {
            [self showHudWithString:@"请完善学生名称" forSecond:1.5];
        }else if ([phoneTextField.text isEqualToString:@""]) {
            [self showHudWithString:@"请完善联系方式" forSecond:1.5];
        }else if ([self isChinaMobile:phoneTextField.text] == NO) {
            [self showHudWithString:@"请核对手机号" forSecond:1.5];
        }else if ([moneyLabel.text isEqualToString:@""]) {
            [self showHudWithString:@"请核对支付金额" forSecond:1.5];
        }else {
            baby_name = [NSString stringWithFormat:@"%@,%@,%@", baby_name1, baby_name2, baby_name3];
            parent_phone = phoneTextField.text;
            pay_price = moneyLabel.text;
            
            [self createCoursePayOrder];
            
        }
        
    }else if ([numTextField.text integerValue] == 4){
        if ([baby_name1 isEqualToString:@""] || [baby_name2 isEqualToString:@""] || [baby_name3 isEqualToString:@""] || [baby_name4 isEqualToString:@""]) {
            [self showHudWithString:@"请完善学生名称" forSecond:1.5];
        }else if ([phoneTextField.text isEqualToString:@""]) {
            [self showHudWithString:@"请完善联系方式" forSecond:1.5];
        }else if ([self isChinaMobile:phoneTextField.text] == NO) {
            [self showHudWithString:@"请核对手机号" forSecond:1.5];
        }else if ([moneyLabel.text isEqualToString:@""]) {
            [self showHudWithString:@"请核对支付金额" forSecond:1.5];
        }else {
            baby_name = [NSString stringWithFormat:@"%@,%@,%@,%@", baby_name1, baby_name2, baby_name3, baby_name4];
            parent_phone = phoneTextField.text;
            pay_price = moneyLabel.text;
            
            [self createCoursePayOrder];
            
        }
        
    }

}





- (void)createCoursePayOrder{
    XXECreateCourseOrderApi *createCourseOrderApi = [[XXECreateCourseOrderApi alloc] initWithXid:parameterXid user_id:parameterUser_Id course_id:_course_id buy_num:numTextField.text baby_name:baby_name parent_phone:parent_phone deduct_coin:coinTextField.text deduct_price:[NSString stringWithFormat:@"%lf",deduct1] pay_price:pay_price];
    
    [createCourseOrderApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //
        NSLog(@"%@", request.responseJSONObject);
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];

}


/** 判断 输入的是否是手机号  */
- (BOOL)isChinaMobile:(NSString *)phoneNum{
    BOOL isChinaMobile = NO;
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    if([regextestcm evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国移动");
    }
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    if([regextestcu evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国联通");
    }
    
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if([regextestct evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国电信");
    }
    return isChinaMobile;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
