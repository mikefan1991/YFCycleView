//
//  ViewController.m
//  YFCycleView
//
//  Created by Yingwei Fan on 7/19/17.
//  Copyright © 2017 YF. All rights reserved.
//

#import "ViewController.h"
#import "YFCycleView.h"

@interface ViewController () <YFCycleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 基础style
    UIImage *image = [UIImage imageNamed:@"hiphop"];
    YFCycleView *cycleView = [[YFCycleView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200) items:@[@"http://static8.photo.sina.com.cn/orignal/494929ff8c1fc94db1aa7", @"http://images2015.cnblogs.com/blog/791499/201608/791499-20160824143404355-59469562.png", image, @"http://loudwire.com/files/2013/02/Linkin-Park.jpg", @"http://www.chartattack.com/wp-content/uploads/2017/05/LP.jpg"] style:YFCycleViewStyleDefault];
    cycleView.delegate = self;
    [cycleView setPageControlBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8]];
    //cycleView.autoScroll = NO;
    [self.view addSubview:cycleView];
    
    // 展示style
    YFCycleView *cycleView1 = [[YFCycleView alloc] initWithFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width, 200) items:@[@"http://static8.photo.sina.com.cn/orignal/494929ff8c1fc94db1aa7", @"http://images2015.cnblogs.com/blog/791499/201608/791499-20160824143404355-59469562.png", image, @"http://loudwire.com/files/2013/02/Linkin-Park.jpg", @"http://www.chartattack.com/wp-content/uploads/2017/05/LP.jpg"] style:YFCycleViewSytleExhibit];
    cycleView1.hidePageControl = NO;
    // 设定滚动的间隔时间
    cycleView1.interval = 3.0;
    cycleView1.scrollDirection = YFCycleViewScrollDirectionRight;
    cycleView1.delegate = self;
    //cycleView.autoScroll = NO;
    [self.view addSubview:cycleView1];

}

- (void)cycleView:(YFCycleView *)cycleView didSelectItem:(NSInteger)item {
    NSLog(@"点击了第%ld个item", item);
}


@end
