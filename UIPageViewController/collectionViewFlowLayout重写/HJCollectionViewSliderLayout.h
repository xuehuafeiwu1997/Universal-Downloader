//
//  HJCollectionViewSliderLayout.h
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/15.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HJCollectionViewSliderLayoutDelegete <UICollectionViewDelegateFlowLayout>

- (void)targetIndexPathForProposed:(NSIndexPath *)targetIndexPath;
- (CGSize)sizeForFirstCell;

@end

@interface HJCollectionViewSliderLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<HJCollectionViewSliderLayoutDelegete> delegate;

@end

NS_ASSUME_NONNULL_END
