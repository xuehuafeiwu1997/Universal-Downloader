//
//  XMYTabViewNew.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/15.
//  Copyright © 2020 许明洋. All rights reserved.
//重写flowLayout实现滑动到具体的某个cell上，而且可以改变处于第一个cell的大小,滑动比较流畅,依旧是向右只能滑动到第七个cell，但是可以使用[collectionView setContentOffset]来改变初始的collectionView的初始偏移量，而且停留的位置仍然是第一个cell，这个还没有试，可能会存在问题。

#import "XMYTabViewNew.h"
#import "HJTabCollectionViewCell.h"
#import "UIColor+Utils.h"
#import "HJCollectionViewSliderLayout.h"

@interface XMYTabViewNew()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HJCollectionViewSliderLayoutDelegete>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation XMYTabViewNew

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
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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
}

#pragma mark - UICollectionViewDelegate/dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.titles count] * 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HJTabCollectionViewCell" forIndexPath:indexPath];
    cell.title = [self.titles objectAtIndex:indexPath.row % self.titles.count];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 36);
}

#pragma mark - delegate

- (CGSize)sizeForFirstCell {
    return CGSizeMake(100, 41);
}

- (void)targetIndexPathForProposed:(NSIndexPath *)targetIndexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:targetIndexPath];
    NSLog(@"第%ld个tab被选中",targetIndexPath.row + 1);
    [self.collectionView selectItemAtIndexPath:targetIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    HJCollectionViewSliderLayout *layout = [[HJCollectionViewSliderLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.delegate = self;
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
