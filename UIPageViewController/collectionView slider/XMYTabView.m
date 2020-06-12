//
//  XMYTabView.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/12.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "XMYTabView.h"
#import "HJTabCollectionViewCell.h"

@interface XMYTabView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation XMYTabView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.frame;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.collectionView reloadData];
}

- (void)selectIndex:(NSInteger)index {
    self.currentIndex = index;
    if (self.currentIndex == NSNotFound) {
        self.currentIndex = 0;
    }
    if (self.currentIndex + 1 > self.titles.count) {
        self.currentIndex = self.titles.count - 1;
    }
    //默认初始选中第一组第一个元素
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"触发了滑动方法");
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    //使用这种方法滚动及其不精准，如果移动的距离较小，根本就不会有滚动
//    CGFloat offsetX = scrollView.contentOffset.x;
//    float width = 100;
//    NSInteger index = ceil(offsetX / width);
////    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //这样的实现是一个一个的实现,如果滑动幅度过大就会出现问题
    if (velocity.x > 0) {
        if (self.currentIndex == self.titles.count - 1) {
            return;
        }
        self.currentIndex ++;
    } else if (velocity.x < 0) {
        if (self.currentIndex == 0) {
            return;
        }
        self.currentIndex --;
    }
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//    //这样写有问题,如果滑动距离过长的话会达不到效果，原因是cellForItemAtIndexPath获取到的cell为空,所以出现问题，因为这个方法只能获取到刷新后展示在屏幕上的大小
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
//    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    CGPoint offset = CGPointMake(cell.center.x - 50, 0);
//    [self.collectionView setContentOffset:offset animated:NO];
    //targetContentOffset 用于修改最后停留的位置，这样写的话一次移动一个，可以实现相应的功能，但是滑动不顺畅，可能这种写法比较实用于划一次换一页的那种
    *targetContentOffset = [self contentOffsetForCellAtIndex:self.currentIndex];
}

- (CGPoint)contentOffsetForCellAtIndex:(NSInteger)index {
    CGPoint p = self.collectionView.contentOffset;
    return CGPointMake(index * 110 - 50, p.y);
}
#pragma mark - UICollectionViewDelegate/dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.titles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HJTabCollectionViewCell" forIndexPath:indexPath];
    cell.title = [self.titles objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 41);
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[HJTabCollectionViewCell class] forCellWithReuseIdentifier:@"HJTabCollectionViewCell"];
    return _collectionView;
}

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

@end
