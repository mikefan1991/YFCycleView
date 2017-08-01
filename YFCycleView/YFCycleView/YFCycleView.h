//
//  YFCycleView.h
//  YFCycleView
//
//  Created by Yingwei Fan on 7/19/17.
//  Copyright © 2017 YF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFCycleView;

typedef enum{
    YFCycleViewStyleDefault,
    YFCycleViewSytleExhibit
}YFCycleViewStyle;

typedef enum {
    YFCycleViewScrollDirectionLeft,
    YFCycleViewScrollDirectionRight
}YFCycleViewScrollDirection;

@protocol YFCycleViewDelegate <NSObject>
@optional
- (void)cycleView:(YFCycleView *)cycleView didSelectItem:(NSInteger)item;

@end

@interface YFCycleView : UIView

#pragma mark - public Variables

/** 是否可以自动滚动，默认为YES */
@property (nonatomic, assign) BOOL autoScroll;

/** 滚动方向，默认为向左滚动 */
@property (nonatomic, assign) BOOL scrollDirection;

/** 是否隐藏pageControl */
@property (nonatomic, assign) BOOL hidePageControl;

/** 滚动间隔时间 */
@property (nonatomic, assign) NSTimeInterval interval;

/** 代理 */
@property (nonatomic, weak) id<YFCycleViewDelegate> delegate;


#pragma mark - public methods
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items style:(YFCycleViewStyle)style;
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items scrollInterval:(CGFloat)interval;
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items scrollInterval:(CGFloat)interval style:(YFCycleViewStyle)style;

/** 可传入自定义pageControl，只需要设定好样式，不需要设置页数 */
- (void)setCustomPageControl:(UIPageControl *)pageControl;

- (void)setPageControlBackgroundColor:(UIColor *)color;

- (void)setPageControlTintColor:(UIColor *)color;

- (void)setPageControlCurrentTintColor:(UIColor *)color;

@end
