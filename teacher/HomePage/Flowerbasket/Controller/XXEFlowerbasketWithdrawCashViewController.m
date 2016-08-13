


//
//  XXEFlowerbasketWithdrawCashViewController.m
//  teacher
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEFlowerbasketWithdrawCashViewController.h"
#import "XXEFlowerbasketWithdrawCashApi.h"
#import "XXEFlowerbasketSubmitAccountInfoApi.h"
#import "XXEFlowerbasketSentHistoryViewController.h"


#define requestUrl @"http://www.xingxingedu.cn/Teacher/fbasket_withdraw_page"

#define submitUrl @"http://www.xingxingedu.cn/Teacher/fbasket_withdraw_action"


@interface XXEFlowerbasketWithdrawCashViewController ()<UITextFieldDelegate>
//可用花篮数
@property (nonatomic, copy) NSString *fbasket_able;
//一个花篮 多少元
@property (nonatomic, copy) NSString *fbasket_value;
//手续费 百分率
@property (nonatomic, copy) NSString *fbasket_commission_per;


@end

@implementation XXEFlowerbasketWithdrawCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"花篮提现";
    
    _numberTextField.delegate = self;
    [_numberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self createRightBar];
    
    [self fetchNetData];
}

- (void)createRightBar{
    
    UIButton *buyBtn =[UIButton createButtonWithFrame:CGRectMake(0, 0, 21, 21) backGruondImageName:@"home_flowerbasket_historyIcon44x44" Target:self Action:@selector(buy:) Title:@""];
    UIBarButtonItem *buyItem =[[UIBarButtonItem alloc]initWithCustomView:buyBtn];
    self.navigationItem.rightBarButtonItem =buyItem;
    
}
- (void)buy:(UIButton*)bt{
    
    [self.navigationController pushViewController:[XXEFlowerbasketSentHistoryViewController alloc] animated:YES];
}


- (void)fetchNetData{

    XXEFlowerbasketWithdrawCashApi *flowerbasketWithdrawCashApi = [[XXEFlowerbasketWithdrawCashApi alloc] initWithUrlString:requestUrl appkey:APPKEY backtype:BACKTYPE xid:XID user_id:USER_ID user_type:USER_TYPE];
    [flowerbasketWithdrawCashApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"%@", request.responseJSONObject);

        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            _fbasket_able = dict[@"fbasket_able"];
            
            _fbasket_value = dict[@"fbasket_value"];
            
            _fbasket_commission_per = dict[@"fbasket_commission_per"];
            
        }else{
            
        }
     [self createContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"请求失败" forSecond:1.f];
    }];


}


- (void)createContent{

    _titleLabel1.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:14];
    _titleLabel2.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:14];
    _titleLabel3.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:14];
    _titleLabel4.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:14];
    _titleLabel5.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:14];
    
    _moneyLabel.font = [UIFont systemWithIphone6P:18 Iphone6:16 Iphone5:14 Iphone4:14];
    
    _numberTextField.placeholder = [NSString stringWithFormat:@"还有%@个花篮", _fbasket_able];
   NSInteger totalMoney = [_fbasket_able integerValue] * [_fbasket_value integerValue];
    _moneyLabel.text = [NSString stringWithFormat:@"%ld", totalMoney];
    //账号 中间 隐藏 一部分
    _aliPayAccountTextField.text = _aliPayAccountStr;
    
    _rateLabel.text = [NSString stringWithFormat:@"提示: 提现需要收取%@的手续费", _fbasket_commission_per];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)certenButton:(UIButton *)sender {
    
    if([_aliPayAccountTextField.text isEqualToString:@""]){
        
        [self showHudWithString:@"请输入支付宝账户" forSecond:1.5];
        
    }else if ([_numberTextField.text isEqualToString:@""]){

        [self showHudWithString:@"请输入花篮数" forSecond:1.5];
        
    }else if ([_numberTextField.text  integerValue] > [_fbasket_able integerValue]){

        [self showHudWithString:@"目前最多可提现5朵花篮" forSecond:1.5];
    }else if ([_nameTextField.text isEqualToString:@""]){

        [self showHudWithString:@"请输入姓名" forSecond:1.5];
    }else{
        
        [self submitAccountInfo];
        
    }
  
    
    
}

- (void)submitAccountInfo{
//    NSLog(@"账号%@ ---  数量%@", _account_id, _numberTextField.text);
    //账号13818657742 ---  数量1
    
        XXEFlowerbasketSubmitAccountInfoApi *flowerbasketSubmitAccountInfoApi = [[XXEFlowerbasketSubmitAccountInfoApi alloc] initWithUrlString:submitUrl appkey:APPKEY backtype:BACKTYPE xid:XID user_id:USER_ID user_type:USER_TYPE account_id:self.account_id num:_numberTextField.text];
        [flowerbasketSubmitAccountInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
//            NSLog(@"hahahah %@", request.responseJSONObject);
            
                    NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
            
                    if ([codeStr isEqualToString:@"1"]) {
                        [self showHudWithString:@"提现成功!" forSecond:1.5 ];
                    }else{
            
                    }
                    [self createContent];
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
            [self showString:@"请求失败" forSecond:1.5f];
        }];




}

- (void) textFieldDidChange:(UITextField *) TextField{
    
    if (TextField == _numberTextField) {
    _moneyLabel.text=[NSString stringWithFormat:@"%ld",[TextField.text intValue]*[_fbasket_value integerValue]];
    }
    

}



@end
