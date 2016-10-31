//
//  LewBarChartData.h
//  NetEaseLocalActivities
//
//  Created by pljhonglu on 16/2/1.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LewBarChartDataSet;
@interface LewBarChartData : NSObject
@property (nonatomic, strong)NSArray<NSString *> *xLabels;
@property (nonatomic, strong)NSArray<NSString *> *yLabels;
@property (nonatomic, strong)NSArray<LewBarChartDataSet *> *dataSets;
@property (nonatomic)CGFloat yMaxNum;//y 轴最大值

@property (nonatomic, assign)CGFloat groupSpace;// 大的分组的间距
@property (nonatomic, assign)CGFloat itemSpace;// 单个组内的每个 item 间距
@property (nonatomic, assign, readonly)BOOL isGrouped;

@property (nonatomic, strong)UIColor *xLabelTextColor;
@property (nonatomic, strong)UIColor *yLabelTextColor;
@property (nonatomic, assign)CGFloat xLabelFontSize;
@property (nonatomic, assign)CGFloat yLabelFontSize;

- (instancetype)initWithDataSets:(NSArray<LewBarChartDataSet *> *)dataSets;

@end


@interface LewBarChartDataSet : NSObject
@property (nonatomic, strong)NSArray<NSNumber *> *yValues;
@property (nonatomic, strong)NSString *label;// legend label

@property (nonatomic, strong)UIColor *barColor;
@property (nonatomic, strong)UIColor *BarbackGroudColor;

- (instancetype)initWithYValues:(NSArray<NSNumber *> *)yValues label:(NSString *)label;

@end
NS_ASSUME_NONNULL_END// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com