//
//  UIPageViewController+Scroll.h
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/16.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIPageViewControllerScrollViewDelegate <NSObject>

- (void)pageViewController:(UIPageViewController *)pageViewController scrollViewDidScroll:(CGFloat)offset;

@end
@interface UIPageViewController (Scroll)

@property (nonatomic, weak) id<UIPageViewControllerScrollViewDelegate> scrollViewDelegate;
@property (nonatomic, strong, readonly) UIScrollView *hj_contentScrollView;

- (void)enableScroll:(BOOL)enable;
- (UIScrollView *)findScrollView;

@end

NS_ASSUME_NONNULL_END
