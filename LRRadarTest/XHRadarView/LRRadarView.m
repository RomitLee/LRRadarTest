//
//  XHRadarView.m
//  XHRadarView
//
//  Created by 邱星豪 on 14/10/24.
//  Copyright (c) 2014年 邱星豪. All rights reserved.
//

#import "LRRadarView.h"

#import "LRRadarIndicatorView.h"

#import <QuartzCore/QuartzCore.h>
#define RADAR_DEFAULT_SECTIONS_NUM 3
#define RADAR_DEFAULT_RADIUS 150.f  //默认的半径大小  150
#define RADAR_DEFAULT_IMGRADIUS 20.f  //默认的头像半径大小  150
#define RADAR_ROTATE_SPEED 140.0f
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

@implementation LRRadarView

#pragma mark - life cycle

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    if (!self.indicatorView) {
        LRRadarIndicatorView *indicatorView = [[LRRadarIndicatorView alloc] init];
        [self addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    
    if (!self.textLabel) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.center.y + self.radius, self.bounds.size.width, 30)];
        [self addSubview:textLabel];
        _textLabel = textLabel;
    }
    
    if (!self.pointsView) {
        UIView *pointsView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:pointsView];
        _pointsView = pointsView;
    }
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // Drawing code
    
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*背景图片*/
    if (self.backgroundImage) {
        UIImage *image = self.backgroundImage;
        [image drawInRect:self.bounds];//在坐标中画出图片
    }
    
    //默认的圈数
    NSUInteger sectionsNum = RADAR_DEFAULT_SECTIONS_NUM;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInRadarView:)]) {
        sectionsNum = [self.dataSource numberOfSectionsInRadarView:self];
    }
    
    
    CGFloat radius = RADAR_DEFAULT_RADIUS;
    if (self.radius) {
        radius = self.radius;
    }
    
    CGFloat imgradius = RADAR_DEFAULT_IMGRADIUS;
    if (self.imgradius) {
        imgradius = self.imgradius;
    }
    
    //画很多的圆圈
    CGFloat sectionRadius = (radius-imgradius)/sectionsNum+imgradius;
    for (int i=0; i<sectionsNum ; i++) {
        /*画圆*/
        //边框圆
        CGContextSetRGBStrokeColor(context, 1, 1, 1, (1-(float)i/(sectionsNum + 1))*0.5);//画笔线的颜色(透明度渐变)
        CGContextSetLineWidth(context, 1.0);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, self.center.x, self.center.y, sectionRadius, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
        
        sectionRadius += (radius-imgradius)/sectionsNum;
    }
    
    //那个线条 和 后面的扇形弧度，，其实frame是整个屏幕，所以旋转是绕着用户头像
    if (self.indicatorView) {
        self.indicatorView.frame = self.bounds;
        self.indicatorView.backgroundColor = [UIColor clearColor];
        self.indicatorView.radius = self.radius;
    }
    
    if (self.textLabel) {
        self.textLabel.frame = CGRectMake(0, self.center.y + ([UIScreen mainScreen].bounds.size.height)/3.3, rect.size.width, 30);
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        if (self.labelText) {
            self.textLabel.text = self.labelText;
        }
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self bringSubviewToFront:self.textLabel];
    }
    
    if(self.PersonImage&&self.imgradius)
    {
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-self.imgradius, self.center.y-self.imgradius, self.imgradius*2, self.imgradius*2)];
        avatarView.layer.cornerRadius = self.imgradius;
        avatarView.layer.masksToBounds = YES;
        
        [avatarView setImage:self.PersonImage];
        [self addSubview:avatarView];
        [self bringSubviewToFront:avatarView];
    }
    
}

- (void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    if (self.textLabel) {
        self.textLabel.text = labelText;
    }
}

//转动
#pragma mark - Actions
- (void)scan {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 360.f/RADAR_ROTATE_SPEED;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [_indicatorView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop {
    [_indicatorView.layer removeAnimationForKey:@"rotationAnimation"];
}


//搜索到用户
- (void)show {
    for (UIView *subview in self.pointsView.subviews) {
        [subview removeFromSuperview];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfPointsInRadarView:)]) {
        NSUInteger pointsNum = [self.dataSource numberOfPointsInRadarView:self];
        
        //添加每一个点数
        for (int index=0; index<pointsNum; index++) {
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(radarView:viewForIndex:)]) {
                
                    //CGPoint point = [self.dataSource radarView:self positionForIndex:index];
                    
                    
                    LRRadarPointView *pointView = [self.dataSource radarView:self viewForIndex:index];
                    int posDirection = pointView.PointAngle.intValue;     //方向(角度)
                    int posDistance = pointView.PointRadius.intValue;    //距离(半径)
                    
                    
                    pointView.tag = index;
                    
                    pointView.layer.cornerRadius=pointView.frame.size.width/2;
                    pointView.layer.masksToBounds=YES;
                    
                    //蛋疼的求坐标点
                    pointView.center = CGPointMake(self.center.x+posDistance*cos(posDirection*M_PI/180), self.center.y+posDistance*sin(posDirection*M_PI/180));
                    pointView.delegate = self;
                    
                    //动画
                    pointView.alpha = 0.0;
                    CGAffineTransform fromTransform =
                    CGAffineTransformScale(pointView.transform, 0.1, 0.1);
                    [pointView setTransform:fromTransform];
                    
                    CGAffineTransform toTransform = CGAffineTransformConcat(pointView.transform,  CGAffineTransformInvert(pointView.transform));
                
                    //int jiange=arc4random()%30;
                
                    double delayInSeconds = 2*index;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [UIView beginAnimations:nil context:NULL];
                        [UIView setAnimationDuration:1.5];
                        pointView.alpha = 1.0;
                        [pointView setTransform:toTransform];
                        [UIView commitAnimations];
                    });
                    
                    [self.pointsView addSubview:pointView];
                                        
                
            }
        }
    }
    
}

- (void)hide {
    
}

#pragma mark - XHRadarPointViewDelegate
- (void)didSelectItemRadarPointView:(LRRadarPointView *)radarPointView {
    NSLog(@"select point %d", radarPointView.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(radarView:didSelectItemAtIndex:)]) {
        [self.delegate radarView:self didSelectItemAtIndex:radarPointView.tag];
    }
}


@end
