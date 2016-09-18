

//
//  XXEReleaseViewController.m
//  teacher
//
//  Created by Mac on 16/9/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEReleaseViewController.h"
#import "XXENotificationReleaseApi.h"
#import "XXEAuditorApi.h"
#import "XXEAuditorModel.h"

@interface XXEReleaseViewController ()<UITextViewDelegate>
{
    //审核人员
    NSMutableArray *auditorArray;
    //审核人员 model
    NSMutableArray *auditorModelArray;
    NSString *notice_type;	//1:班级通知  2:学校通知
    NSString *examine_tid;	//审核人id
    //传参
    NSString *parameterXid;
    NSString *parameterUser_Id;

}

//通知 范围 下拉框
@property(nonatomic, strong)WJCommboxView *scopeCommbox;
//
@property (nonatomic, strong) UIView *scopeCommboxBgView;

//审核人员 下拉框
@property(nonatomic, strong)WJCommboxView *auditorCommbox;
//
@property (nonatomic, strong) UIView *auditorCommboxBgView;


@end

@implementation XXEReleaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    auditorArray = [[NSMutableArray alloc] init];
    auditorModelArray = [[NSMutableArray alloc] init];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];

    _contentTextView.delegate = self;
    
    [_certainButton addTarget:self action:@selector(certainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //创建 下拉框
    [self createContent];
    
}


- (void)createContent{

    //----------------------通知 范围 下拉框
    CGFloat scopeCommboxX = 90 * kScreenRatioWidth;
    CGFloat scopeCommboxY = _scopeView.frame.origin.y + 5 * kScreenRatioHeight;
    CGFloat scopeCommboxWidth = 280 * kScreenRatioWidth;
    CGFloat scopeCommboxHeight = 20 * kScreenRatioHeight;
    _scopeCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(scopeCommboxX, scopeCommboxY, scopeCommboxWidth, scopeCommboxHeight)];
    _scopeCommbox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    _scopeCommbox.textField.placeholder = @"通知范围";
    _scopeCommbox.textField.textAlignment = NSTextAlignmentLeft;
    _scopeCommbox.textField.tag = 1001;
    
    //通知 范围 position		//教职身份(传数字,1:授课老师  2:主任  3:管理  4:校长)
    //当 是 1/2 时, 是"班级通知/学校通知" -----  当 是 1/2 时, 只有"学校通知"
    _scopeCommbox.dataArray = [[NSArray alloc] initWithObjects:@"班级通知", @"学校通知", nil];
    
    [self.view addSubview:_scopeCommbox];
    //监听
    [_scopeCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"1"];
    
    _scopeCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kWidth,kHeight+300)];
    _scopeCommboxBgView.backgroundColor = [UIColor greenColor];
    _scopeCommboxBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [_scopeCommboxBgView addGestureRecognizer:singleTouch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    
    //-------------------审核人员 下拉框
    CGFloat auditorCommboxX = 90 * kScreenRatioWidth;
    CGFloat auditorCommboxY = _auditView.frame.origin.y + 5 * kScreenRatioHeight;
    CGFloat auditorCommboxWidth = 280 * kScreenRatioWidth;
    CGFloat auditorCommboxHeight = 20 * kScreenRatioHeight;
    
    _auditorCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(auditorCommboxX, auditorCommboxY, auditorCommboxWidth, auditorCommboxHeight)];
    _auditorCommbox.textField.backgroundColor =UIColorFromRGB(246, 246, 246);
    _auditorCommbox.textField.placeholder =@"审核人员";
    _auditorCommbox.textField.textAlignment =NSTextAlignmentLeft;
    _auditorCommbox.textField.tag =1002;
    
    [self.view addSubview:_auditorCommbox];
//    [_auditView addSubview:_auditorCommbox];
    //监听
    [_auditorCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"2"];
    
    _auditorCommboxBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight+300)];
    _auditorCommboxBgView.backgroundColor = [UIColor redColor];
    _auditorCommboxBgView.alpha = 0.5;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHi)];
    [_auditorCommboxBgView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
}

- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 1001:
        {
            
            [_scopeCommbox removeFromSuperview];
//            [self.view addSubview:_scopeCommboxBgView];
            [self.view addSubview:_scopeCommbox];
            
        }
            break;
        case 1002:
        {
            
            [_auditorCommbox removeFromSuperview];
//            [self.view addSubview:_auditorCommboxBgView];
            [self.view addSubview:_auditorCommbox];
        }
            break;
        default:
            break;
    }
    
}


- (void)commboxHidden{
    
    [_scopeCommboxBgView removeFromSuperview];
    [_scopeCommbox setShowList:NO];
    _scopeCommbox.listTableView.hidden = YES;
    
}
- (void)commboxHi{
    
    [_auditorCommboxBgView removeFromSuperview];
    [_auditorCommbox setShowList:NO];
    _auditorCommbox.listTableView.hidden = YES;
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [auditorArray removeAllObjects];
    
    switch ([[NSString stringWithFormat:@"%@",context] integerValue]) {
        case 1:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
                //notice_type	//1:班级通知  2:学校通知
                if ([newName isEqualToString:@"班级通知"]) {
                    notice_type = @"1";
                }else if ([newName isEqualToString:@"学校通知"]){
                    notice_type = @"2";
                }
                //获取 审核 人员
                [self getAuditorInfo];
            }
            
        }
            break;
        case 2:
        {
            if ([keyPath isEqualToString:@"text"]) {
                NSString * newName=[change objectForKey:@"new"];
            
                if (auditorModelArray.count != 0) {
                    for (XXEAuditorModel *model in auditorModelArray) {
                        if ([newName isEqualToString:model.tname]) {
                            examine_tid = model.auditorId;
                        }
                    }
                }

            }
            
        }
            break;
        default:
            break;
    }
}

- (void)getAuditorInfo{
    
//    NSLog(@"%@ --- %@ ---- %@ ----%@ ---- %@  ", parameterXid, parameterUser_Id, _schoolId, _classId, notice_type);
    
    XXEAuditorApi *auditorApi = [[XXEAuditorApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:_classId position:@"4" notice_type:notice_type];
    [auditorApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if (auditorModelArray.count != 0) {
            [auditorModelArray removeAllObjects];
        }
//                NSLog(@"2222---   %@", request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", dic[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSArray *modelArray = [XXEAuditorModel parseResondsData:dic[@"data"]];
            [auditorModelArray addObjectsFromArray:modelArray];
        }else{
            
        }
        [self updateAuditorCommboxDataArray];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];

}

- (void)updateAuditorCommboxDataArray{
    if (auditorModelArray.count != 0) {
        for (XXEAuditorModel *model in auditorModelArray) {
            [auditorArray addObject:model.tname];
        }
    }
    _auditorCommbox.dataArray = auditorArray;
    [_auditorCommbox.listTableView reloadData];
}


- (void)certainButtonClick:(UIButton *)button{
    
    if ([_subjectTextField.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善主题!" forSecond:1.5];
    }else if ([_contentTextView.text isEqualToString:@""]) {
        [self showHudWithString:@"请完善内容!" forSecond:1.5];
    }else{
        [self submitContentInfo];
    }
    
}

- (void)submitContentInfo{
    
    XXENotificationReleaseApi *notificationReleaseApi = [[XXENotificationReleaseApi alloc] initWithXid:parameterXid user_id:parameterUser_Id school_id:_schoolId class_id:_classId position:@"4" notice_type:notice_type examine_tid:examine_tid title:_subjectTextField.text con:_contentTextView.text];
    
    [notificationReleaseApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"2222---   %@", request.responseJSONObject);
        
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_scopeCommbox.textField removeObserver:self forKeyPath:@"text" context:@"1"];
    [_auditorCommbox.textField removeObserver:self forKeyPath:@"text" context:@"2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}


@end
