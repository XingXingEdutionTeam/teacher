


//
//  XXEStudentSignInViewController.m
//  teacher
//
//  Created by Mac on 16/9/1.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStudentSignInViewController.h"
#import "HZQDatePickerView.h"
#import "XXEStudentSignInApi.h"

@interface XXEStudentSignInViewController ()<HZQDatePickerViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    HZQDatePickerView *_pikerView;//截止日期选择器
    NSMutableArray * studentArray;
    int checkNum;
    int noCheckNum;
    
    NSMutableArray *_dataSourceArray;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEStudentSignInViewController

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
    
    [self createContent];
    
    [self fetchNetData];
    
    
}

- (void)fetchNetData{

    XXEStudentSignInApi *studentSignInApi = [[XXEStudentSignInApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE position:@"4" class_id:_classId school_id:_schoolId];
    
    [studentSignInApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //        NSLog(@"111   %@", request.responseJSONObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            //@"昵称:",@"姓名:",@"年龄:", @"关系:", @"生日:", @"学校:", @"班级:", @"个性签名:", @"个人描述:"
//            contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"nickname"], dict[@"tname"],  dict[@"age"], dict[@"birthday"], @"学校", _babyClassName, dict[@"personal_sign"], dict[@"pdescribe"], nil];
//            headImageStr = dict[@"head_img"];
        }else{
            
        }
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}



// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (_dataSourceArray.count == 0) {
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"all_placeholder"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - myImageWidth / 2, (KScreenHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_myTableView reloadData];
        
    }
    
}


- (void)createContent{

   //选取 时间  按钮
    [_chooseTimeBtn addTarget:self action:@selector(chooseTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //未签到 人数 按钮
    [_unRegisterNumBtn addTarget:self action:@selector(unRegisterNumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //签到 人数 按钮
    [_registerNumBtn addTarget:self action:@selector(registerNumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //一键签到 按钮
    [_allRegisterBtn addTarget:self action:@selector(allRegisterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)chooseTimeBtnClick{



}

- (void)unRegisterNumBtnClick{
    
    
    
}

- (void)registerNumBtnClick{
    
    
    
}

- (void)allRegisterBtnClick{
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
