




//
//  XXEFlowerbasketAddAccountViewController.m
//  teacher
//
//  Created by Mac on 16/8/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketAddAccountViewController.h"
#import "XXEFlowerbasketAddAccountApi.h"

#define URL @"http://www.xingxingedu.cn/Teacher/financial_account_add"


@interface XXEFlowerbasketAddAccountViewController ()
{
    CGFloat bgViewBottom;
    
    NSString *nameStr;
    NSString *accountStr;
    
    UITextField *nameTextfield;
    UITextField *accountTextfield;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEFlowerbasketAddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加账号";
    
    self.view.backgroundColor = XXEColorFromRGB(229, 232, 233);
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    [self createContent];
}

- (void)createContent{
    /**
    该支付宝账号绑定的真实姓名
     */
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 70 * KScreenWidth / 375, KScreenWidth, 50* KScreenWidth / 375)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView1];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * KScreenWidth / 375, 100 * KScreenWidth / 375, 30 * KScreenWidth / 375)];
    nameLabel.text = @"姓    名";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:12];
    [bgView1 addSubview:nameLabel];
    
    CGFloat nameLabelWidth = nameLabel.frame.size.width;
    
    nameTextfield = [UITextField createTextFieldWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabelWidth, 10 * KScreenWidth / 375, KScreenWidth - nameLabel.frame.origin.x - nameLabelWidth - 10 * KScreenWidth / 375, 30 * KScreenWidth / 375) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    nameTextfield.placeholder = @"请输入该支付宝账号绑定的真实姓名";
    nameTextfield.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:12];
    [bgView1 addSubview:nameTextfield];
    
    /**
     *  账号
     */
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, (70 + (50 + 20) * 1) * KScreenWidth / 375, KScreenWidth, 50* KScreenWidth / 375)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView2];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * KScreenWidth / 375, 100 * KScreenWidth / 375, 30 * KScreenWidth / 375)];
    accountLabel.textAlignment = NSTextAlignmentCenter;
    accountLabel.textColor = [UIColor darkGrayColor];
    accountLabel.text = @"支付宝账号";
    accountLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:12];
    [bgView2 addSubview:accountLabel];
    
    CGFloat LabelWidth = accountLabel.frame.size.width;
    
    accountTextfield = [UITextField createTextFieldWithFrame:CGRectMake(accountLabel.frame.origin.x + LabelWidth, 10 * KScreenWidth / 375, KScreenWidth - accountLabel.frame.origin.x - LabelWidth - 10 * KScreenWidth / 375, 30 * KScreenWidth / 375) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    accountTextfield.placeholder = @"请输入您的支付宝账号";
    
    accountTextfield.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:12];
    [bgView2 addSubview:accountTextfield];
    bgViewBottom = bgView2.frame.origin.y + bgView2.frame.size.height;
    
    CGFloat buttonWidth = 325 * KScreenWidth / 375;
    CGFloat buttonHeight = 42 * KScreenWidth / 375;
    
    UIButton *certenButton = [UIButton createButtonWithFrame:CGRectMake((KScreenWidth - buttonWidth) / 2, bgViewBottom + 50 * KScreenWidth / 375, buttonWidth, buttonHeight) backGruondImageName:@"login_green" Target:self Action:@selector(certenButtonClick) Title:@"完  成"];
    [certenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.view addSubview:certenButton];

}


- (void)certenButtonClick{    
    nameStr = nameTextfield.text;
    accountStr = accountTextfield.text;
    
    
    if([nameStr isEqualToString:@""]){
        
    [self showHudWithString:@"请输入该支付宝账号绑定的真实姓名" forSecond:1.5];
        
    }else if ([accountStr isEqualToString:@""]){
        
    [self showHudWithString:@"请输入您的支付宝账号" forSecond:1.5];
        
    }else{
    
        XXEFlowerbasketAddAccountApi *flowerbasketAddAccountApi = [[XXEFlowerbasketAddAccountApi alloc] initWithUrlString: URL appkey:APPKEY backtype:BACKTYPE xid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE tname:nameStr account:accountStr type:@"1"];
        [flowerbasketAddAccountApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
//                    NSLog(@"111   %@", request.responseJSONObject);
            
            NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
            
            if ([codeStr isEqualToString:@"1"]) {
                [self showHudWithString:@"添加成功!" forSecond:1.5];
            }else{
                
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
            [self showString:@"请求失败" forSecond:1.f];
        }];
    
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

@end
