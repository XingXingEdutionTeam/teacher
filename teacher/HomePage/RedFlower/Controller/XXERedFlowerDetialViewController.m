




//
//  XXERedFlowerDetialViewController.m
//  teacher
//
//  Created by Mac on 16/8/12.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXERedFlowerDetialViewController.h"
#import "XXERedFlowerDetialTableViewCell.h"


@interface XXERedFlowerDetialViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
    //头像
    NSMutableArray *picArray;
    //标题
    NSMutableArray *titleArray;
    //内容
    NSMutableArray *contentArray;
   //照片墙 的图片 可以排列几行
    NSInteger picRow;
    //照片墙 照片 宽
    CGFloat picWidth;
    //照片墙 照片 高
    CGFloat picHeight;
    
}

@end

@implementation XXERedFlowerDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    picArray =[[NSMutableArray alloc]initWithObjects:@"home_redflower_nameIcon", @"home_redflower_timeIcon", @"home_redflower_schoolIcon", @"home_redflower_classIcon", @"home_redflower_courseIcon", @"home_redflower_contentIcon",  @"home_redflower_picIcon",nil];
    titleArray =[[NSMutableArray alloc]initWithObjects:@"姓名:",@"赠送时间:",@"学校:", @"班级:", @"课程:", @"赠言:", @"照片墙:", nil];
    contentArray = [[NSMutableArray alloc] initWithObjects:_name, _time, _schoolName, _className, _course, _content, @"", nil];
    
    [self createTableView];
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
    
    return 7;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXERedFlowerDetialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXERedFlowerDetialTableViewCell" owner:self options:nil]lastObject];
    }

    cell.iconImageView.image = [UIImage imageNamed:picArray[indexPath.row]];
    cell.titleLabel.text = titleArray[indexPath.row];
    
    cell.contentLabel.text = contentArray[indexPath.row];
    if (indexPath.row == 6) {
        
        //result= num1>num2?num1:num2;
        
        if (_picWallArray.count % 3 == 0) {
            picRow = _picWallArray.count / 3;
        }else{
            
            picRow = _picWallArray.count / 3 + 1;
        }
        //创建 十二宫格  三行、四列
        int margin = 10;
        picWidth = (KScreenWidth - 4 * margin) / 3;
        picHeight = picWidth;
        
        for (int i = 0; i < _picWallArray.count; i++) {
            
            //行
            int buttonRow = i / 3;
            
            //列
            int buttonLine = i % 3;
            
            CGFloat buttonX = (picWidth + margin) * buttonLine;
            CGFloat buttonY = 40 + (picHeight + margin) * buttonRow;
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonX, buttonY, picWidth, picHeight)];
            
            [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _picWallArray[i]]]];
            pictureImageView.tag = 20 + i;
            pictureImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:pictureImageView];
        }
        
    }
    
    return cell;
}

- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    NSLog(@"--- 点击了第%ld张图片", tap.view.tag - 20);
    
//    RedFlowerViewController *redFlowerVC =[[RedFlowerViewController alloc]init];
//    NSMutableArray *imageArr = picMArr;
//    redFlowerVC.index = tap.view.tag - 20;
//    redFlowerVC.imageArr = imageArr;
//    //举报 来源 7:作业图片
//    redFlowerVC.origin_pageStr = @"7";
//    redFlowerVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:redFlowerVC animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==6) {
        return 44 + picRow * picHeight;
    }
    else{
        return 44;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 130 * kScreenRatioHeight)];
    headerView.backgroundColor = XXEColorFromRGB(0, 170, 42);
    
    CGFloat iconWidth = 87 * kScreenRatioWidth;
    CGFloat iconHeight = iconWidth;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - iconWidth) / 2, (headerView.frame.size.height - iconHeight) / 2, iconWidth, iconHeight)];

//    icon.image = [UIImage imageNamed:@"headplaceholder"];
    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kXXEPicURL, _iconUrl]] placeholderImage:[UIImage imageNamed:@"headplaceholder"]];
    icon.layer.cornerRadius = icon.frame.size.width / 2;
    icon.layer.masksToBounds = YES;
    
    [headerView addSubview:icon];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 130 * kScreenRatioHeight;
}


@end
