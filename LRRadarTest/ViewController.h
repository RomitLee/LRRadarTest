//
//  ViewController.h
//  LRRadarTest
//
//  Created by RomitLee on 15/7/10.
//  Copyright (c) 2015年 RomitLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRRadarView.h"
#import "LRRadarPointView.h"

@interface ViewController : UIViewController<LRRadarViewDataSource,LRRadarViewDelegate>

@property (nonatomic, strong) LRRadarView *radarView;
@end

