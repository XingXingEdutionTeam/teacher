
//
//  XXERongCloudAddFirendListDetailViewController.m
//  teacher
//
//  Created by Mac on 16/10/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudAddFirendListDetailViewController.h"
#import "XXERongCloudAgreeFriendRequestApi.h"
#import "XXERongCloudPersonDetailInfoApi.h"
#import "XXERongCloudAddToBlackListApi.h"
#import "ReportPicViewController.h"

@interface XXERongCloudAddFirendListDetailViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
}
@end

@implementation XXERongCloudAddFirendListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
//    _other_xid = @"";
    
    _titleLabel1.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _titleLabel2.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _titleLabel3.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _xidLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _addressLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _signLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _phoneLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    [self fetchNetData];
    
    [self createButtons];

}


- (void)fetchNetData{

    XXERongCloudPersonDetailInfoApi *rongCloudPersonDetailInfoApi = [[XXERongCloudPersonDetailInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:_other_xid];
    [rongCloudPersonDetailInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            
            /*
             {
             age = 30;
             "head_img" = "app_upload/head_img/2016/09/06/20160906155856_7177.png";
             "head_img_type" = 0;
             id = 1;
             nickname = "\U6c34\U6c34ha";
             "personal_sign" = "";
             phone = 13938493974;
             sex = "\U5973";
             tname = "\U6881\U7ea2\U6c34";
             "user_type" = 2;  //1:家长 2:老师
             xid = 18886389;
             };
             */
            /*
             0 :表示 自己 头像 ，需要添加 前缀
             1 :表示 第三方 头像 ，不需要 添加 前缀
             //判断是否是第三方头像
             */
            NSString * head_img;
            if([dict[@"head_img_type"] integerValue] == 0){
                head_img = [kXXEPicURL stringByAppendingString:dict[@"head_img"]];
            }else{
                head_img = dict[@"head_img"];
            }
            _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
            _iconImageView.layer.masksToBounds = YES;
            
            [_iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
            //昵称
            _nameLabel.text = dict[@"nickname"];
            
            //xid
            _xidLabel.text = dict[@"xid"];
            
            //身份: 家长 或 老师
            
            NSString *positionStr = @"";
            if ([dict[@"user_type"] integerValue] == 1) {
                positionStr = @"家长";
            }else if ([dict[@"user_type"] integerValue] == 2) {
                positionStr = @"老师";
            }
            
            _addressLabel.text = positionStr;
            
            //电话
            _phoneLabel.text = dict[@"phone"];
            
            //个人 签名
            _signLabel.text = dict[@"personal_sign"];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


- (void)createButtons{
    [_agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addToBlackListButton addTarget:self action:@selector(addToBlackListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)agreeButtonClick:(UIButton *)button{
    
    XXERongCloudAgreeFriendRequestApi *rongCloudAgreeFriendRequestApi = [[XXERongCloudAgreeFriendRequestApi alloc] initWithXid:parameterXid user_id:parameterUser_Id request_id:_requestIdStr];
    [rongCloudAgreeFriendRequestApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//                NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"添加好友成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHudWithString:@"添加好友失败!" forSecond:1.5];
        }

    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];


}

- (void)addToBlackListButtonClick:(UIButton *)button{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定将好友加入黑名单？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //加入 黑名单
        [self addToBlackList];
        
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)addToBlackList{
    XXERongCloudAddToBlackListApi *rongCloudAddToBlackListApi = [[XXERongCloudAddToBlackListApi alloc] initWithXid:parameterXid user_id:parameterUser_Id other_xid:_other_xid];
    [rongCloudAddToBlackListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //      NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        /*
         ★其他结果需提醒用户
         code:4		//此人已在黑名单中
         */
        if ([codeStr isEqualToString:@"1"]) {
            [self showHudWithString:@"拉黑成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else if ([codeStr isEqualToString:@"4"]) {
            [self showHudWithString:@"此人已在黑名单中!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showHudWithString:@"拉黑失败!" forSecond:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
    
}


- (void)reportButtonClick:(UIButton *)button{
    ReportPicViewController * vc=[[ReportPicViewController alloc]init];
    
    /*
     【举报提交】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/report_sub
     
     传参:
     other_xid	//被举报人xid (举报用户时才有此参数)
     report_name_id	//举报内容id , 多个逗号隔开
     report_type	//举报类型 1:举报用户  2:举报图片
     */
    vc.other_xidStr = _other_xid;
    vc.report_type = @"1";
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
