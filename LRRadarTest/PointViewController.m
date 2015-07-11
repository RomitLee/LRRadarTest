//
//  PointViewController.m
//  LRRadarTest
//
//  Created by RomitLee on 15/7/10.
//  Copyright (c) 2015年 RomitLee. All rights reserved.
//

#import "PointViewController.h"

@interface PointViewController ()

@end

@implementation PointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blueColor];
    UIView *heng=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, 1)];
    
    heng.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:heng];
    
    UIView *shu=[[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, 1, [UIScreen mainScreen].bounds.size.height)];
    
    shu.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:shu];
    
    
    UIView *point=[[UIView alloc]init];
    point.backgroundColor=[UIColor yellowColor];
    
    point.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    
    
    
    
    
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
