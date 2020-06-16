//
//  HJCollectionViewSliderLayout.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/15.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "HJCollectionViewSliderLayout.h"

@implementation HJCollectionViewSliderLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;//确定滚动方向，水平滚动
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/*
 这个方法返回的都是数组，并且，数组中存放的都是UICollectionViewLayoutAttributes对象
 UICollectionViewLayoutAttributes对象决定了cell的排布方式
 获取所有的布局信息
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    //不使用深复制的话运行后会出现警告，加上下面这句话就没有警告
    NSArray *array = [[NSArray alloc] initWithArray:original copyItems:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    CGRect first = CGRectMake(self.collectionView.contentOffset.x + self.sectionInset.left, self.collectionView.contentOffset.y, itemSize.width, itemSize.height);
    CGSize firstCellSize = [self.delegate sizeForFirstCell];
    CGFloat totalOffsetX = 0;
    CGFloat maxOffsetX = 0;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGRect originFrame = attributes.frame;
        //判断两个矩形框是否相交
        if (CGRectIntersectsRect(first, attributes.frame)) {
            //如果相交，获取两个矩形相交的区域
            CGRect insertRect = CGRectIntersection(first, attributes.frame);
            attributes.size = CGSizeMake(itemSize.width + (insertRect.size.width / itemSize.width) * (firstCellSize.width - itemSize.width), itemSize.height + (insertRect.size.width / itemSize.width) * (firstCellSize.height - itemSize.height));
            CGFloat currentOffsetX = attributes.size.width - itemSize.width;
            attributes.center = CGPointMake(attributes.center.x + totalOffsetX + currentOffsetX / 2, attributes.center.y);
            totalOffsetX += currentOffsetX;
            maxOffsetX = MAX(maxOffsetX, attributes.center.x + attributes.size.width / 2);
        } else {
            if (CGRectGetMinX(originFrame) >= CGRectGetMaxX(first)) {
                attributes.center = CGPointMake(attributes.center.x + totalOffsetX, attributes.center.y);
            }
        }
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    CGFloat adjustOffsetX = CGFLOAT_MAX;
    CGFloat finalPointX = 0;
    //这个循环没看太懂
    do {
        adjustOffsetX = finalPointX - proposedContentOffset.x;
        finalPointX += itemSize.width + self.minimumLineSpacing;
    } while (ABS(adjustOffsetX) > ABS(finalPointX - proposedContentOffset.x));
    
    CGPoint finalPoint = CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
    NSInteger index = ceil((finalPoint.x - self.sectionInset.left) / (itemSize.width + self.minimumInteritemSpacing));
    if (self.delegate && [self.delegate respondsToSelector:@selector(targetIndexPathForProposed:)]) {
        [self.delegate targetIndexPathForProposed:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    return finalPoint;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    CGFloat adjustOffsetX = CGFLOAT_MAX;
    CGFloat finalPointX = 0;
    do {
        adjustOffsetX = finalPointX - proposedContentOffset.x;
        finalPointX += itemSize.width + self.minimumLineSpacing;
    } while (ABS(adjustOffsetX) > ABS(finalPointX - proposedContentOffset.x));

    CGPoint finalPoint = CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
    NSInteger index = ceil((finalPoint.x - self.sectionInset.left) / (itemSize.width + self.minimumLineSpacing));
    if (self.delegate && [self.delegate respondsToSelector:@selector(targetIndexPathForProposed:)]) {
        [self.delegate targetIndexPathForProposed:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    return finalPoint;
}

@end
