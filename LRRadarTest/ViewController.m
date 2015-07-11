//
//  ViewController.m
//  LRRadarTest
//
//  Created by RomitLee on 15/7/10.
//  Copyright (c) 2015年 RomitLee. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () {
}

@property (nonatomic, strong) NSArray *pointsArray;
@property (nonatomic, strong) LRRadarPointView *pointsView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"雷达";
    
    LRRadarView *radarView = [[LRRadarView alloc] initWithFrame:self.view.bounds];
    radarView.frame = self.view.frame;
    radarView.dataSource = self;
    radarView.delegate = self;
    radarView.radius = 180;
    radarView.imgradius=38;
    //radarView.backgroundColor = [UIColor colorWithRed:0.251 green:0.329 blue:0.490 alpha:1];
    radarView.backgroundImage = [UIImage imageNamed:@"140"];
    radarView.PersonImage=[UIImage imageNamed:@"qq7"];
    
    radarView.labelText = @"正在搜索附近的目标";
    [self.view addSubview:radarView];
    _radarView = radarView;

    
    //目标点位置
    _pointsArray = @[
                     @[@-90, @60]
//                     @[@-140, @108],
//                     @[@-83, @98],
//                     @[@-25, @142],
//                     @[@60, @111],
//                     @[@-111, @96],
//                     @[@150, @145],
//                     @[@25, @144],
//                     @[@-55, @110],
//                     @[@95, @109],
//                     @[@120, @130],
//                     @[@125, @112],
//                     @[@-150, @125],
//                     @[@-7, @110],
                     ];
    
    [self.radarView scan];
    //[self startUpdatingRadar];
    [self.radarView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//模拟搜索到用户

#pragma mark - Custom Methods
- (void)startUpdatingRadar {
    typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.radarView.labelText = [NSString stringWithFormat:@"搜索已完成，共找到%lu个目标", (unsigned long)weakSelf.pointsArray.count];
        [weakSelf.radarView show];
    });
}

#pragma mark - XHRadarViewDataSource
- (NSInteger)numberOfSectionsInRadarView:(LRRadarView *)radarView {
    return 4;
}
- (NSInteger)numberOfPointsInRadarView:(LRRadarView *)radarView {
    return 8;
}
- (LRRadarPointView *)radarView:(LRRadarView *)radarView viewForIndex:(NSUInteger)index {
    LRRadarPointView *pointView=[[LRRadarPointView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    NSString *images=[NSString stringWithFormat:@"%u",arc4random()%9];
    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"qq%@",images]]];
    imageView.contentMode=UIViewContentModeScaleToFill;
    [pointView addSubview:imageView];
    
    NSString *jiaodu=[NSString stringWithFormat:@"%d",arc4random()%360];
    int radarradius=self.radarView.radius-self.radarView.imgradius-40;//雷达半径-头像半径-poing半径，表示在雷达中，头像外；
    int iamgeRadius=self.radarView.imgradius+20;
    int banban=(arc4random()%radarradius)+iamgeRadius;
    NSString *banjing=[NSString stringWithFormat:@"%d",banban];
    
    pointView.PointAngle=jiaodu;
    pointView.PointRadius=banjing;
    
    return pointView;
}


#pragma mark - XHRadarViewDelegate

- (void)radarView:(LRRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"didSelectItemAtIndex:%lu", (unsigned long)index);
    
}


@end
