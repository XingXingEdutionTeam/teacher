

//
//  XXERongCloudReplyListDetailViewController.m
//  teacher
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERongCloudReplyListDetailViewController.h"
#import "XXERongCloudPersonDetailInfoApi.h"



@interface XXERongCloudReplyListDetailViewController ()
{
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXERongCloudReplyListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    _titleLabel1.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _titleLabel2.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _titleLabel3.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _xidLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _positionLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _phoneNumLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    _signLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    
    [_chartButton addTarget:self action:@selector(chartButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self fetchNetData];
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
            
            _positionLabel.text = positionStr;
            
            //电话
            _phoneNumLabel.text = dict[@"phone"];
            
            //个人 签名
            _signLabel.text = dict[@"personal_sign"];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}


- (void)chartButtonClick:(UIButton *)button{

    [self.navigationController popViewControllerAnimated:YES];
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
