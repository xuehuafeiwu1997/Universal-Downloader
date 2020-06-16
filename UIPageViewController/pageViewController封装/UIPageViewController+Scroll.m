//
//  UIPageViewController+Scroll.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/16.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "UIPageViewController+Scroll.h"
#import <objc/runtime.h>
#import "NSObject+Utils.h"

@implementation UIPageViewController (Scroll)

@dynamic scrollViewDelegate;
@dynamic hj_contentScrollView;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIPageViewController swizzleInstanceMethod:@selector(viewDidLoad) withMethod:@selector(scroll_viewDidLoad)];
//        Method originalMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
//        Method newMethod = class_getInstanceMethod([self class], @selector(scroll_viewDidLoad));
//        if (class_addMethod(self, originalMethod, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
//            class_replaceMethod(self, newMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, newMethod);
//        }
////        method_exchangeImplementations(originalMethod, newMethod);
    });
}

- (void)scroll_viewDidLoad {
    [self scroll_viewDidLoad];
    [self addObserverForScrollViewContentOffset];
}

- (void)addObserverForScrollViewContentOffset {
    if (self.transitionStyle != UIPageViewControllerTransitionStyleScroll) {
        return;
    }
    if (!self.hj_contentScrollView) {
        return;
    }
    [self.hj_contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverForScrollViewContentOffset {
    if (self.transitionStyle != UIPageViewControllerTransitionStyleScroll) {
        return;
    }
    if (!self.hj_contentScrollView) {
        return;
    }
    [self.hj_contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        [self onScrollViewContentOffsetDidChange:offset];
    }
}

- (void)onScrollViewContentOffsetDidChange:(CGPoint)contentOffset {
    CGFloat x = contentOffset.x - CGRectGetWidth(self.hj_contentScrollView.bounds);
    NSLog(@"contentOffset的偏移量为%f",x);
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(pageViewController:scrollViewDidScroll:)]) {
        [self.scrollViewDelegate pageViewController:self scrollViewDidScroll:x];
    }
}

- (void)enableScroll:(BOOL)enable {
    UIScrollView *scrollView = [self findScrollView];
    scrollView.scrollEnabled = enable;
}

- (UIScrollView *)findScrollView {
    UIScrollView *scrollView = nil;
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)subView;
            break;
        }
    }
    return scrollView;
}

- (id<UIPageViewControllerScrollViewDelegate>)scrollViewDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setScrollViewDelegate:(id<UIPageViewControllerScrollViewDelegate>)scrollViewDelegate {
    objc_setAssociatedObject(self, @selector(scrollViewDelegate), scrollViewDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (UIScrollView *)hj_contentScrollView {
    UIScrollView *scrollView = objc_getAssociatedObject(self, _cmd);
    if (scrollView) {
        return scrollView;
    }
    scrollView = [self findScrollView];
    objc_setAssociatedObject(self, _cmd, scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return scrollView;
}

@end
