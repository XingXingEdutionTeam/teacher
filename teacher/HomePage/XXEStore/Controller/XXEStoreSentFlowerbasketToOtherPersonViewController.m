
//
//  XXEStoreSentFlowerbasketToOtherPersonViewController.m
//  teacher
//
//  Created by Mac on 2016/11/15.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreSentFlowerbasketToOtherPersonViewController.h"
#import "XXEClassAddressTeacherInfoModel.h"
#import "XXEClassAddressTableViewCell.h"

@interface XXEStoreSentFlowerbasketToOtherPersonViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    NSInteger page;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEStoreSentFlowerbasketToOtherPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XXEBackgroundColor;
    
    _dataSourceArray = [[NSMutableArray alloc] init];
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
    /*
     【猩猩商城--花篮转增下的通讯录(针对某个班级的)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/fbasket_give_teacher
     
     传参:
     school_id	//学校id
     class_id	//班级id*/
    
    /*
     [DEFAULTS setObject:self.schoolHomeId forKey:@"SCHOOL_ID"];
     [DEFAULTS setObject:self.classHomeId forKey:@"CLASS_ID"];
     */
    NSString *school_id = [DEFAULTS objectForKey:@"SCHOOL_ID"];
    NSString *class_id = [DEFAULTS objectForKey:@"CLASS_ID"];
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/fbasket_give_teacher";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"school_id":school_id,
                             @"class_id":class_id
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
//        NSLog(@"hhhh %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            
            NSDictionary *dict = responseObj[@"data"];
            
            NSArray *teacherModelArray = [[NSArray alloc] init];
            NSArray *managerModelArray = [[NSArray alloc] init];
            
//            NSLog(@"oooooo %@", dict[@"teacher"]);
            
            teacherModelArray = [XXEClassAddressTeacherInfoModel parseResondsData:dict[@"teacher"]];
            managerModelArray  = [XXEClassAddressTeacherInfoModel parseResondsData:dict[@"manager"]];
            
            [_dataSourceArray addObjectsFromArray:teacherModelArray];
            [_dataSourceArray addObjectsFromArray:managerModelArray];
            
        }
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        [self showString:@"获取数据失败!" forSecond:1.5];
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
    
    return _dataSourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEClassAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEClassAddressTableViewCell" owner:self options:nil]lastObject];
    }
    XXEClassAddressTeacherInfoModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    
    NSString *head_img;
    if ([model.head_img_type integerValue] == 0) {
        head_img = [kXXEPicURL stringByAppendingString:model.head_img];
    }else if([model.head_img_type integerValue] == 1){
        head_img = model.head_img;
    }
    
    cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width / 2;
    cell.iconImageView.layer.masksToBounds = YES;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    
    //    NSLog(@"课程  %@", model.teach_course);
    cell.nameLabel.text = model.tname;
    cell.nameLabel.font = [UIFont systemWithIphone6P:16 Iphone6:14 Iphone5:12 Iphone4:10];
    cell.detailLabel.text = model.teach_course;
    cell.lookFamilyInfoButton.hidden = YES;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXEClassAddressTeacherInfoModel *model = _dataSourceArray[indexPath.row];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithObjects:model.tname, model.teacher_id, nil];
    self.returnArrayBlock(mArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)returnArrayBlock:(returnArrayBlock)block{
    self.returnArrayBlock = block;
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
