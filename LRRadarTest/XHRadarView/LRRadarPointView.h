//
//  XHRadarPointView.h
//  XHRadarView
//
//  Created by 邱星豪 on 14/10/27.
//  Copyright (c) 2014年 邱星豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LRRadarPointViewDelegate;

@interface LRRadarPointView : UIView


@property (nonatomic,strong) NSString *PointAngle;//角度
@property (nonatomic,strong) NSString *PointRadius;//距离终点的距离


@property (nonatomic, assign) id <LRRadarPointViewDelegate> delegate;        //委托

@end

@protocol LRRadarPointViewDelegate <NSObject>
@optional

- (void)didSelectItemRadarPointView:(LRRadarPointView *)radarPointView; //点击事件

@end


