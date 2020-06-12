//
//  HJTabView.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/11.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "HJTabView.h"
#import "HJTabCollectionViewCell.h"
#import "Masonry.h"

@interface HJTabView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HJTabView

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
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.frame;
}

#pragma mark - set
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.collectionView reloadData];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if (self.selectIndex == NSNotFound) {
        _selectIndex = 0;
    }
    if (_selectIndex >= [self.titles count]) {
        _selectIndex = 0;
    }
    [self.collectionView reloadData];
}

#pragma mark - delegate/datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.titles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HJTabCollectionViewCell" forIndexPath:indexPath];
    cell.title = self.titles[indexPath.row];
    cell.selected = indexPath.row == self.selectIndex ? YES : NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectIndex == indexPath.row) {
        return;
    }
    self.selectIndex = indexPath.row;
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
//     [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:selectTabAtIndex:)]) {
        [self.delegate tabView:self selectTabAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = CGRectGetWidth(self.collectionView.bounds);
    float height = CGRectGetHeight(self.collectionView.bounds);
    return CGSizeMake(floor(width / self.titles.count), height);
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //加了这句话才可以触发滑动的方法
    _collectionView.alwaysBounceHorizontal = YES;
    [_collectionView registerClass:[HJTabCollectionViewCell class] forCellWithReuseIdentifier:@"HJTabCollectionViewCell"];
    return _collectionView;
}

@end
