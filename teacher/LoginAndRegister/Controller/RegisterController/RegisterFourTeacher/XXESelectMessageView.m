//
//  XXESelectMessageView.m
//  TWCitySelectView
//
//  Created by codeDing on 16/8/18.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import "XXESelectMessageView.h"

#define TWW self.frame.size.width
#define TWH self.frame.size.height

#define TWRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define BtnW 60
#define toolH 40
#define BJH 260

@interface XXESelectMessageView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    UIView *_BJView;                //一个view，工具栏和pickview都是添加到上面，便于管理
    NSArray *_messageArray;
    UIPickerView *_pickView;        //最主要的选择器
    NSInteger _districtIndex;       //用于记录选中哪个区的索引
}

@property (copy, nonatomic) void (^sele)(NSString *proviceStr);

@end

@implementation XXESelectMessageView

-(instancetype)initWithTWFrame:(CGRect)rect TWselectCityTitle:(NSString *)title MessageArray:(NSMutableArray *)messageArray{
    if (self = [super initWithFrame:rect]) {
        
        _messageArray = [NSMutableArray array];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        
        _messageArray = messageArray;

        //显示pickview和按钮最底下的view
        _BJView = [[UIView alloc] initWithFrame:CGRectMake(0, TWH, TWW, BJH)];
        [self addSubview:_BJView];
        
        UIView *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 40, TWW, toolH)];
        tool.backgroundColor = TWRGB(237, 236, 234);
        [_BJView addSubview:tool];
        
        /**
         按钮+中间可以显示标题的UILabel
         */
        UIButton *left = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        left.frame = CGRectMake(0, 0, BtnW, toolH);
        [left setTitle:@"取消" forState:UIControlStateNormal];
        [left setTintColor:XXEGreenColor];
        [left addTarget:self action:@selector(leftBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:left];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width, 0, TWW-(left.frame.size.width*2), toolH)];
        titleLB.text = title;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [tool addSubview:titleLB];
        
        UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        right.frame = CGRectMake(TWW-BtnW ,0,BtnW, toolH);
        [right setTitle:@"确定" forState:UIControlStateNormal];
        [right setTintColor:XXEGreenColor];
        [right addTarget:self action:@selector(rightBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:right];
        
        
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,toolH+40, TWW, _BJView.frame.size.height-toolH)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = TWRGB(237, 237, 237);
        [_BJView addSubview:_pickView];
        
        
    }
    return self;
    
}

//自定义每个pickview的label
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

/**
 *  下面几个委托方法
 *
 */

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _districtIndex = row;
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [_messageArray objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _messageArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

/**
 *  左边的取消按钮
 */
-(void)leftBTN{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = TWH;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
    
}

/**
 *  右边的确认按钮
 */
-(void)rightBTN{
    __weak typeof(UIView*)blockview = _BJView;
    __weak typeof(self)blockself = self;
    __block int blockH = TWH;
    if (self.sele) {
        self.sele(_messageArray[_districtIndex]);
    }
    NSLog(@"%@",self.sele);
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH;
        blockview.frame = bjf;
        blockself.alpha = 0.1;
    } completion:^(BOOL finished) {
        [blockself removeFromSuperview];
    }];
}


-(void)showCityView:(void (^)(NSString *))selectStr{
    
    self.sele = selectStr;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    __weak typeof(UIView*)blockview = _BJView;
    __block int blockH = TWH;
    __block int bjH = BJH;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH-bjH;
        blockview.frame = bjf;
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_BJView.frame, point)) {
        [self leftBTN];
    }
    
}




@end
