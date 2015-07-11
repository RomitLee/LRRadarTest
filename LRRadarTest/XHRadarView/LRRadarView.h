//
//  XHRadarView.h
//  XHRadarView
//
//  Created by 邱星豪 on 14/10/24.
//  Copyright (c) 2014年 邱星豪. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LRRadarPointView.h"

@class LRRadarIndicatorView;
@class LRRadarPointView;

@protocol LRRadarViewDataSource;
@protocol LRRadarViewDelegate;

@interface LRRadarView : UIView <LRRadarPointViewDelegate> {
    
}

@property (nonatomic, assign) CGFloat radius;//半径
@property (nonatomic, assign) CGFloat imgradius;//中间个人头像的半径

@property (nonatomic, strong) UIImage *backgroundImage; //背景图片
@property (nonatomic, strong) UIImage *PersonImage; //背景图片

@property (nonatomic, strong) UILabel *textLabel;      //提示标签
@property (nonatomic, strong) NSString *labelText;      //提示文字
@property (nonatomic, strong) UIView *pointsView;       //目标点视图
@property (nonatomic, strong) LRRadarIndicatorView *indicatorView;      //指针

@property (nonatomic, assign) id <LRRadarViewDataSource> dataSource;    //数据源
@property (nonatomic, assign) id <LRRadarViewDelegate> delegate;        //委托

-(void)scan;    //扫描
-(void)stop;    //停止
-(void)show;    //显示目标
-(void)hide;    //隐藏目标

@end


@protocol LRRadarViewDataSource <NSObject>              //数据源

@optional

- (NSInteger)numberOfSectionsInRadarView:(LRRadarView *)radarView;
- (NSInteger)numberOfPointsInRadarView:(LRRadarView *)radarView;
- (LRRadarPointView *)radarView:(LRRadarView *)radarView viewForIndex:(NSUInteger)index;       //自定义目标点视图
- (CGPoint)radarView:(LRRadarView *)radarView positionForIndex:(NSUInteger)index;    //目标点所在位置

@end

@protocol LRRadarViewDelegate <NSObject>

@optional

- (void)radarView:(LRRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index; //点击事件

@end
