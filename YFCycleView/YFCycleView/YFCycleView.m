//
//  YFCycleView.m
//  YFCycleView
//
//  Created by Yingwei Fan on 7/19/17.
//  Copyright © 2017 YF. All rights reserved.
//

#import "YFCycleView.h"
#import "YFCycleViewCell.h"

#define MaxNumberOfSections 20
#define PageControlHeight 37
#define ItemPadding 15
#define MaxHeightDifference (2 * ItemPadding)

@interface YFCycleView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGFloat historyX;
}

@property (nonatomic, assign) YFCycleViewStyle style;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YFCycleView

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        switch (self.style) {
            case YFCycleViewStyleDefault:
                self.layout.minimumLineSpacing = 0;
                self.layout.minimumInteritemSpacing = 0;
                self.layout.itemSize = self.bounds.size;
                break;
                
            case YFCycleViewSytleExhibit:
                self.layout.minimumLineSpacing = ItemPadding;
                self.layout.minimumInteritemSpacing = ItemPadding;
                self.layout.sectionInset = UIEdgeInsetsMake(0, ItemPadding, 0, 0);
                CGSize size = CGSizeMake(self.bounds.size.width - 4*ItemPadding, self.bounds.size.height);
                self.layout.itemSize = size;
                break;
                
            default:
                break;
        }
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.decelerationRate = 0;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[YFCycleViewCell class] forCellWithReuseIdentifier:[YFCycleViewCell cellIdentifier]];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        CGFloat y = self.bounds.size.height - PageControlHeight;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, PageControlHeight)];
//        CGPoint center = _pageControl.center;
//        center.x = self.center.x;
//        _pageControl.center = center;
        _pageControl.numberOfPages = self.items.count;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.collectionView];
        
        // 设置自动滚动默认为YES
        _autoScroll = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        // 设置自动滚动默认为YES
        _autoScroll = YES;
        
        // 设置pageControl默认显示
        _hidePageControl = NO;
        
        // 设置Timer的默认interval为2秒
        _interval = 2.0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    if (self = [self initWithFrame:frame]) {
        _items = items;
        // 将collectionView滚动到中间的位置
        if (self.items.count > 1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxNumberOfSections / 2] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        
        [self addSubview:self.pageControl];
        if (self.style == YFCycleViewSytleExhibit) {
            [self.pageControl setHidden:YES];
        }
        
        [self startTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items style:(YFCycleViewStyle)style {
    _style = style;
    if (self = [self initWithFrame:frame items:items]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items scrollInterval:(NSTimeInterval)interval {
    _interval = interval;
    if (self = [self initWithFrame:frame items:items]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items scrollInterval:(CGFloat)interval style:(YFCycleViewStyle)style {
    _interval = interval;
    _style = style;
    if (self = [self initWithFrame:frame items:items scrollInterval:interval]) {
        
    }
    return self;
}

#pragma mark - setter
- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (autoScroll == NO) {
        [self stopTimer];
    }
}

- (void)setScrollDirection:(BOOL)scrollDirection {
    _scrollDirection = scrollDirection;
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    if (self.timer) {
        [self stopTimer];
        [self startTimer];
    }
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    _hidePageControl = hidePageControl;
    if (hidePageControl == YES) {
        self.pageControl.hidden = YES;
    }
    else {
        self.pageControl.hidden = NO;
    }
}

- (void)setCustomPageControl:(UIPageControl *)pageControl {
    pageControl.numberOfPages = self.pageControl.numberOfPages;
    pageControl.currentPage = self.pageControl.currentPage;
    self.pageControl = pageControl;
}

- (void)setPageControlBackgroundColor:(UIColor *)color {
    [self.pageControl setBackgroundColor:color];
}

- (void)setPageControlTintColor:(UIColor *)color {
    [self.pageControl setPageIndicatorTintColor:color];
}

- (void)setPageControlCurrentTintColor:(UIColor *)color {
    [self.pageControl setCurrentPageIndicatorTintColor:color];
}

#pragma mark - timer methods
- (void)startTimer {
    if (self.autoScroll && !self.timer && self.items.count > 2) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - private methods
- (NSIndexPath *)resetIndexPath {
    NSArray *sortedArray = [self.collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSIndexPath *index1 = (NSIndexPath *)obj1;
        NSIndexPath *index2 = (NSIndexPath *)obj2;
        if (index1.section < index2.section) {
            return NSOrderedDescending;
        }
        else if (index1.section > index2.section) {
            return NSOrderedAscending;
        }
        else if (index1.item < index2.item) {
            return NSOrderedDescending;
        }
        else if (index1.item > index2.item) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    NSIndexPath *currIndexPath = nil;
    if (sortedArray.count == 1) {
        currIndexPath = [sortedArray firstObject];
    }
    else {
        currIndexPath = [sortedArray objectAtIndex:1];
    }
    currIndexPath = [NSIndexPath indexPathForItem:currIndexPath.item inSection:MaxNumberOfSections / 2];
    // 将collectionView滚动到最中间
    [self.collectionView scrollToItemAtIndexPath:currIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    return currIndexPath;
}

- (void)nextPage {
    NSIndexPath *resetIndexPath = [self resetIndexPath];
    
    // 计算下一个页面的位置
    NSIndexPath *nextIndexPath = nil;
    if (self.scrollDirection == YFCycleViewScrollDirectionLeft) {
        nextIndexPath = [self getRightIndexPath:resetIndexPath];
    }
    else if (self.scrollDirection == YFCycleViewScrollDirectionRight) {
        nextIndexPath = [self getLeftIndexPath:resetIndexPath];
    }
    
    // 滚动到下一个页面
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (NSIndexPath *)getLeftIndexPath:(NSIndexPath *)currIndexPath {
    NSInteger nextItem = currIndexPath.item - 1;
    NSInteger nextSection = currIndexPath.section;
    if (nextItem == -1) {
        nextItem = self.items.count - 1;
        nextSection --;
    }
    return [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
}

- (NSIndexPath *)getRightIndexPath:(NSIndexPath *)currIndexPath {
    NSInteger nextItem = currIndexPath.item + 1;
    NSInteger nextSection = currIndexPath.section;
    if (nextItem == self.items.count) {
        nextItem = 0;
        nextSection ++;
    }
    return [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
}

#pragma mark - collectionView data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.items.count == 1) {
        return 1;
    }
    return MaxNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFCycleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YFCycleViewCell cellIdentifier] forIndexPath:indexPath];
    if (self.style == YFCycleViewSytleExhibit) {
        cell.imageView.layer.cornerRadius = 5;
        CGRect frame = cell.imageView.frame;
        if (cell.center.x > collectionView.contentOffset.x && cell.center.x < collectionView.contentOffset.x + collectionView.bounds.size.width) {
            frame.origin.y = 0;
            frame.size.height = collectionView.bounds.size.height;
            cell.imageView.frame = frame;
        }
        else {
            frame.origin.y = ItemPadding;
            frame.size.height = collectionView.bounds.size.height - MaxHeightDifference;
            cell.imageView.frame = frame;
        }
    }
    
    NSInteger index = indexPath.item;
    // 传入的是图像下载地址
    if ([self.items[index] isKindOfClass:[NSString class]]) {
        cell.imageURL = self.items[index];
    }
    // 传入的是图像本身
    else if ([self.items[index] isKindOfClass:[UIImage class]]) {
        cell.image = self.items[index];
    }

    return cell;
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleView:didSelectItem:)]) {
        [self.delegate cycleView:self didSelectItem:indexPath.item];
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
    historyX = scrollView.contentOffset.x;
    if (self.style == YFCycleViewSytleExhibit) {
        historyX += ItemPadding;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat cellW = self.layout.itemSize.width;
    if (self.style == YFCycleViewSytleExhibit) {
        cellW += ItemPadding;
    }
    
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    if (self.style == YFCycleViewSytleExhibit) {
        targetX += ItemPadding;
    }
    // 如果用户划动速度过快，会导致一次划过两张，此处判断避免这种情况
    if (fabs(historyX - targetX) > cellW) {
        if (targetX > historyX) {
            targetX = historyX + cellW;
        }
        else if (targetX < historyX) {
            targetX = historyX - cellW;
        }
    }
    
    NSInteger targetIndex = 0;
    // 向右带有速度划动
    if (velocity.x > 0) {
        targetIndex = ceil(targetX / cellW);
    }
    // 向左带有速度划动
    else if (velocity.x < 0) {
        targetIndex = floor(targetX / cellW);
    }
    // 无速度拖拽
    else {
        targetIndex = (NSInteger)round(targetX / cellW);
    }
    
    targetContentOffset->x = targetIndex * cellW;
    if (self.style == YFCycleViewSytleExhibit) {
        targetContentOffset->x -= ItemPadding;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.style == YFCycleViewSytleExhibit) {
        CGFloat currOffsetX = scrollView.contentOffset.x;
        CGFloat currCenterX = currOffsetX + 2 * ItemPadding + self.layout.itemSize.width * 0.5;
        NSArray *visibleCells = self.collectionView.visibleCells;
        for (YFCycleViewCell *cell in visibleCells) {
            CGFloat diff = fabs(cell.center.x - currCenterX);
            CGFloat scale = diff / (self.layout.itemSize.width + ItemPadding);
            if (scale > 1) {
                scale = 1;
            }
            
            CGRect frame = cell.imageView.frame;
            frame.size.height = self.layout.itemSize.height - MaxHeightDifference * scale;
            frame.origin.y = MaxHeightDifference * 0.5 * scale;
            cell.imageView.frame = frame;
        }
    }
    
    // 判断pageControl是否隐藏
    if (self.pageControl.hidden == YES) {
        return;
    }
    // 滚动后设置pageControl的当前页面
    CGFloat currOffsetX = scrollView.contentOffset.x;
    CGFloat cellW = self.layout.itemSize.width;
    if (self.style == YFCycleViewSytleExhibit) {
        currOffsetX += ItemPadding;
        cellW += ItemPadding;
    }
    NSInteger item = (NSInteger)round(currOffsetX / cellW) % self.items.count;
    [self.pageControl setCurrentPage:item];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetIndexPath];
    historyX = scrollView.contentOffset.x;
    
    [self startTimer];
}


@end
