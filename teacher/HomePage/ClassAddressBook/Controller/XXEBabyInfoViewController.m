

//
//  XXEBabyInfoViewController.m
//  teacher
//
//  Created by Mac on 16/8/30.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEBabyInfoViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"
#import "XXEBabyInfoApi.h"


@interface XXEBabyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *pictureArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
    //宝贝 头像
    NSString *headImageStr;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
    
}

@end

@implementation XXEBabyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学生中心";
    pictureArray = [[NSMutableArray alloc] initWithObjects:@"babyinfo_nickname_icon", @"babyinfo_tname_icon", @"babyinfo_age_icon", @"babyinfo_birthday_icon", @"babyinfo_school_icon", @"babyinfo_class_icon", @"babyinfo_personal_sign_icon", @"babyinfo_pdescribe_icon", nil];
    titleArray =[[NSMutableArray alloc]initWithObjects:@"昵称:",@"姓名:",@"年龄:", @"生日:", @"学校:", @"班级:", @"个性签名:", @"个人描述:", nil];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self fetchNetData];
    [self createTableView];
}

- (void)fetchNetData{

    
    XXEBabyInfoApi *babyApi = [[XXEBabyInfoApi alloc] initWithXid:parameterXid user_id:parameterUser_Id user_type:USER_TYPE baby_id:_babyId];
    
    
    [babyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
//        NSLog(@"111   %@", request.responseJSONObject);

        NSString *codeStr = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            NSDictionary *dict = request.responseJSONObject[@"data"];
            //@"昵称:",@"姓名:",@"年龄:", @"关系:", @"生日:", @"学校:", @"班级:", @"个性签名:", @"个人描述:"
            contentArray = [[NSMutableArray alloc] initWithObjects:dict[@"nickname"], dict[@"tname"],  dict[@"age"], dict[@"birthday"], @"学校", _babyClassName, dict[@"personal_sign"], dict[@"pdescribe"], nil];
            headImageStr = dict[@"head_img"];
        }else{
            
        }
        [self customContent];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self showString:@"数据请求失败" forSecond:1.f];
    }];
    
}



// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (contentArray.count == 0) {
        
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



- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return titleArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerDetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerDetialTableViewCell" owner:self options:nil]lastObject];
    }

    cell.iconImageView.image = [UIImage imageNamed:pictureArray[indexPath.row]];
    cell.titleLabel.text = titleArray[indexPath.row];

    cell.contentLabel.text = contentArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 130 * kScreenRatioHeight)];
    headerView.backgroundColor = XXEColorFromRGB(0, 170, 42);
    
    CGFloat iconWidth = 87 * kScreenRatioWidth;
    CGFloat iconHeight = iconWidth;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - iconWidth) / 2, (headerView.frame.size.height - iconHeight) / 2, iconWidth, iconHeight)];
    
        icon.image = [UIImage imageNamed:@"headplaceholder"];
    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, headImageStr]] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    icon.layer.cornerRadius = icon.frame.size.width / 2;
    icon.layer.masksToBounds = YES;
    
    [headerView addSubview:icon];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 130 * kScreenRatioHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
