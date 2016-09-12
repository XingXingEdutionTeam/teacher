

//
//  XXEProblemFeedbackViewController.m
//  teacher
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEProblemFeedbackViewController.h"
#import "XXEFeedbackProblemApi.h"


@interface XXEProblemFeedbackViewController ()<UITextViewDelegate>
{
    //请求参数
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@end

@implementation XXEProblemFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题反馈";
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    _contentTextView.delegate = self;
    
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)submitButtonClick{

    if ([_contentTextView.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善内容!" forSecond:1.5];
    }else{
        [self submitFeedbackInfo];
    }

}

- (void)submitFeedbackInfo{

    XXEFeedbackProblemApi *feedbackProblemApi = [[XXEFeedbackProblemApi alloc] initWithXid:parameterXid user_id:parameterUser_Id con:_contentTextView.text];
    
    [feedbackProblemApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //               NSLog(@"2222---   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            [self showHudWithString:@"提交成功!" forSecond:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showHudWithString:@"提交失败!" forSecond:1.5];
    }];



}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView == _contentTextView) {
        _numLabel.text =[NSString stringWithFormat:@"%ld/200",textView.text.length];
    }

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
