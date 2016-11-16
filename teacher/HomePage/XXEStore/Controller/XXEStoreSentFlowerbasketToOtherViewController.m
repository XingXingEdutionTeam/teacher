

//
//  XXEStoreSentFlowerbasketToOtherViewController.m
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreSentFlowerbasketToOtherViewController.h"
#import "XXEStoreSentFlowerbasketToOtherHistoryViewController.h"
#import "XXEStoreSentFlowerbasketToOtherPersonViewController.h"


@interface XXEStoreSentFlowerbasketToOtherViewController ()<UITextFieldDelegate>
{

    UIView *bgView;
    
    
    UILabel *leftLabel;
    //当前花篮数
    NSString *flowerbasketNumStr;
    //可送花篮数
    UITextField *numTextField;
    
    //
    UIButton *toOtherButton;
    
    UITextView *conTextView;
    
    //赠送对象 名称
    NSString *toName;
    //赠送对象 id
    NSString *toID;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEStoreSentFlowerbasketToOtherViewController

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
    
    //转赠历史
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"home_flowerbasket_historyIcon44x44.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(sentFlowerbasketHistory)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;

    //剩余花篮
    [self fetchFlowerbasketNunInfo];
    
    //创建 内容
    [self createContent];

}

#pragma mark ======== //转赠历史 ==========
- (void)sentFlowerbasketHistory{

    XXEStoreSentFlowerbasketToOtherHistoryViewController *sentFlowerbasketToOtherHistoryVC = [[XXEStoreSentFlowerbasketToOtherHistoryViewController alloc] init];
    
    [self.navigationController pushViewController:sentFlowerbasketToOtherHistoryVC animated:YES];
}


- (void)fetchFlowerbasketNunInfo{
/*
 【猩猩商城--获取用户当前可用花篮数】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/get_user_fbasket_num
 */
   NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_user_fbasket_num";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"%@", responseObj);
        if ([responseObj[@"code"] integerValue] == 1) {
            flowerbasketNumStr = responseObj[@"data"];
            leftLabel.text = [NSString stringWithFormat:@"%@", flowerbasketNumStr];
            numTextField.placeholder = [NSString stringWithFormat:@"最多可赠送%@个", flowerbasketNumStr];
        }
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
    
}

- (void)createContent{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200 * kScreenRatioHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    //花篮 剩余
   UILabel *leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80 * kScreenRatioWidth, 20)];
    leftTitleLabel.text = @"花篮剩余:";
    leftTitleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//    leftTitleLabel.backgroundColor = [UIColor redColor];
    [bgView addSubview:leftTitleLabel];
    
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftTitleLabel.frame.origin.x + leftTitleLabel.width, 10, KScreenWidth - 120 * kScreenRatioWidth, 20)];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
//    leftLabel.backgroundColor = [UIColor greenColor];
    [bgView addSubview:leftLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, leftLabel.frame.origin.y + leftLabel.height + 5, KScreenWidth, 1)];
    line1.backgroundColor = XXEBackgroundColor;
    [bgView addSubview:line1];
    
    //赠送对象
    UILabel *toOtherLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line1.frame.origin.y + 5, 100 * kScreenRatioWidth, 20)];
    toOtherLabel.text = @"赠送对象:";
    toOtherLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [bgView addSubview:toOtherLabel];
    
    toOtherButton = [UIButton createButtonWithFrame:CGRectMake(toOtherLabel.frame.origin.x + toOtherLabel.width, toOtherLabel.frame.origin.y, KScreenWidth - 120 * kScreenRatioWidth, 20) backGruondImageName:nil Target:self Action:@selector(toOtherButtonClick) Title:@"请选择赠送对象"];
    toOtherButton.titleLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [bgView addSubview:toOtherButton];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, toOtherLabel.frame.origin.y + toOtherLabel.height + 5, KScreenWidth, 1)];
    line2.backgroundColor = XXEBackgroundColor;
    [bgView addSubview:line2];
    
    //赠送数量
    UILabel *numTitlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.frame.origin.y + 5, 100 * kScreenRatioWidth, 20)];
    numTitlelabel.text = @"赠送数量:";
    numTitlelabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [bgView addSubview:numTitlelabel];
    
    numTextField = [[UITextField alloc] initWithFrame:CGRectMake(numTitlelabel.frame.origin.x + numTitlelabel.width, numTitlelabel.frame.origin.y , KScreenWidth - 120 * kScreenRatioWidth, 20)];
    numTextField.delegate = self;
    numTextField.textAlignment = NSTextAlignmentCenter;
    numTextField.keyboardType=UIKeyboardTypeNumberPad;
    numTextField.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    [bgView addSubview:numTextField];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(10, numTitlelabel.frame.origin.y + numTitlelabel.height + 5, KScreenWidth, 1)];
    line3.backgroundColor = XXEBackgroundColor;
    [bgView addSubview:line3];
    
    //赠言
    UILabel *conLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line3.frame.origin.y + 5, 50 * kScreenRatioWidth, 20)];
    conLabel.text = @"赠言:";
    conLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [bgView addSubview:conLabel];
    
    conTextView = [[UITextView alloc] initWithFrame:CGRectMake(conLabel.frame.origin.x + conLabel.width, conLabel.frame.origin.y, KScreenWidth - 80 * kScreenRatioWidth, 90)];
//    conTextView.backgroundColor = [UIColor yellowColor];
    conTextView.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    [bgView addSubview:conTextView];
    
    //确认转赠
    CGFloat buttonX = (KScreenWidth - 325 * kScreenRatioWidth) / 2;
    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    
    UIButton *sentButton = [UIButton createButtonWithFrame:CGRectMake(buttonX, bgView.frame.origin.y + bgView.height + 20, buttonW, buttonH) backGruondImageName:@"login_green" Target:self Action:@selector(affirmBtn) Title:@"确认转赠"];
    [sentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sentButton];
    
}

- (void)affirmBtn{

    if([toOtherButton.titleLabel.text isEqualToString:@"请选择赠送对象"]){
        [self showString:@"请选择增送对象" forSecond:1.5];
    }
    else if([numTextField.text isEqualToString:@""]){
        [self showString:@"请输入转赠数目" forSecond:1.5];
    }else if([numTextField.text intValue]> [flowerbasketNumStr integerValue]){
        [self showString:@"花篮不足，转赠失败" forSecond:1.5];
    } else if([[numTextField.text substringToIndex:1]isEqualToString:@"0"]){
        [self showString:@"赠送数目不能以0开头" forSecond:1.5];
    }else if([conTextView.text isEqualToString:@""]){
        [self showString:@"请输入赠言" forSecond:1.5];
    }else{
        
        [self sentFlowerbasketToOtherPerson];
    }

}

//选择赠送对象
- (void)toOtherButtonClick{

    XXEStoreSentFlowerbasketToOtherPersonViewController *sentFlowerbasketToOtherPersonVC = [[XXEStoreSentFlowerbasketToOtherPersonViewController alloc] init];
    
    [sentFlowerbasketToOtherPersonVC returnArrayBlock:^(NSMutableArray *returnArray) {
        //
        toName = returnArray[0];
        toID = returnArray[1];
        
        [toOtherButton setTitle:toName forState:UIControlStateNormal];
        
    }];

    
    [self.navigationController pushViewController:sentFlowerbasketToOtherPersonVC animated:YES];
   
}

- (void)sentFlowerbasketToOtherPerson{
    /*
     【猩猩商城--花篮赠送】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/give_fbasket
     传参:
     tid		//教师id
     num		//赠送数量
     con		//赠言
     */
   NSString *urlStr = @"http://www.xingxingedu.cn/Global/give_fbasket";
//    NSLog(@"toID:%@ ----- numTextField.text:%@ ===== conTextView.text:%@", toID, numTextField.text, conTextView.text);
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"tid":toID,
                             @"num":numTextField.text,
                             @"con":conTextView.text
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"赠送 === %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            [self showString:@"赠送成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
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
