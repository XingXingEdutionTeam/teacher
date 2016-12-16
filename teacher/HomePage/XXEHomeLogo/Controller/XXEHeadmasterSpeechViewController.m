


//
//  XXEHeadmasterSpeechViewController.m
//  teacher
//
//  Created by Mac on 16/8/24.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEHeadmasterSpeechViewController.h"

@interface XXEHeadmasterSpeechViewController ()
{
    //文字
    UITextView *myTextView;
    //提交 按钮
    UIButton *submitButton;
    
    //计数label
    UILabel *numLabel;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEHeadmasterSpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

//    NSLog(@"%@", _head_img);

    [self createContentImageView];

}


- (void)createContentImageView{
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 * kWidth / 375 + 5, kWidth - 20, kHeight - 10)];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = [UIColor whiteColor];
//    CGFloat contentViewHeight = contentView.frame.size.height;
    
    //校长头像
    
    UIImageView *headmasterIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 60 / 2,15, 60, 60)];
    
    headmasterIconImageView.layer.cornerRadius = headmasterIconImageView.frame.size.width / 2;
    headmasterIconImageView.layer.masksToBounds = YES;
    
    [headmasterIconImageView sd_setImageWithURL:[NSURL URLWithString:_head_img] placeholderImage:[UIImage imageNamed:@"home_logo_headermaster_icon118x118"]];
    [contentView addSubview:headmasterIconImageView];
    
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,15 + 59 +10, kWidth - 10 * 2, KScreenHeight / 3 + 70 * kScreenRatioHeight)];
    myTextView.text = _pdt_speech;
    //    myTextView.scrollEnabled = YES;
    myTextView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:myTextView];

    //校长致辞 只有 学校 的校长 能编辑
    //不同 身份 1:老师 2:班主任 3:管理员 4:校长
    if ([self.position isEqualToString:@"4"]) {
        myTextView.editable = YES;
        
        CGSize size1 = myTextView.size;
        size1.height = KScreenHeight / 3;
        myTextView.size = size1;
        
        CGFloat buttonW = 325 * kScreenRatioWidth;
        CGFloat buttonH = 42 * kScreenRatioHeight;
        CGFloat buttonX = (KScreenWidth - buttonW) / 2;
        CGFloat buttonY = myTextView.frame.origin.y + myTextView.height + 20;
        
        submitButton = [UIButton createButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) backGruondImageName:@"login_green" Target:self Action:@selector(submitButtonClick:) Title:@"提        交"];
        [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:submitButton];
        
    }else{
        myTextView.editable = NO;
    }
    
    //计数 label
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 150 * kScreenRatioWidth, myTextView.frame.origin.y + myTextView.height - 30, 120 * kScreenRatioWidth, 20)];
    numLabel.textColor = [UIColor lightGrayColor];
    [contentView addSubview:numLabel];
    
    [self.view addSubview:contentView];
    
}

- (void)submitButtonClick:(UIButton *)button{
    if ([myTextView.text isEqualToString:@""]) {
        [self showString:@"修改后的信息不能为空" forSecond:1.5];
    }else{
        /*
         【修改学校信息】
         接口类型:2
         接口:
         http://www.xingxingedu.cn/Teacher/school_edit
         
         school_id		//学校id(必须传参)
         position		//身份 (必须传参),只允许管理和校长才可以修改学校信息
         pdt_speech		//校长致辞
         */
        NSString *urlStr = @"http://www.xingxingedu.cn/Teacher/school_edit";
        NSDictionary *params = @{@"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"xid":parameterXid,
                                 @"user_id":parameterUser_Id,
                                 @"user_type":USER_TYPE,
                                 @"school_id": _schoolId,
                                 @"position": _position,
                                 @"pdt_speech":myTextView.text
                                 };
        [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
            //
//            NSLog(@"修改校长 致辞 === %@", responseObj);
            if ([responseObj[@"code"] integerValue] == 1) {
                [self showString:@"修改成功!" forSecond:1.5];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
                
            }else{
                [self showString:@"修改失败!" forSecond:1.5];
            }
            
        } failure:^(NSError *error) {
            //
            [self showString:@"获取数据失败!" forSecond:1.5];
        }];
    
    }
    
}


- (void)textViewDidChange:(UITextView *)textView{
    if (textView == myTextView) {
        
        if (myTextView.text.length <= 200) {
            numLabel.text=[NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        }else{
            [self showHudWithString:@"最多可输入200个字符"];
            myTextView.text = [myTextView.text substringToIndex:200];
        }
//        conStr = myTextView.text;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
