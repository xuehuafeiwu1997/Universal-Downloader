//
//  FirstViewController.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/11.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstChildOneViewController.h"
#import "FirstChildTwoViewController.h"
#import "FirstChildThreeViewController.h"
#import "HJTabView.h"
#import "Masonry.h"
#import "UIPageViewController+Scroll.h"

@interface FirstViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,HJTabChangedDelegate,UIPageViewControllerScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) FirstChildOneViewController *oneVC;
@property (nonatomic, strong) FirstChildTwoViewController *twoVC;
@property (nonatomic, strong) FirstChildThreeViewController *thirdVC;
@property (nonatomic, strong) NSArray <UIViewController *> *vcArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic) HJTabView *tabView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"界面一";
    self.view.backgroundColor = [UIColor yellowColor];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    self.pageViewController.scrollViewDelegate = self;
    [self addViewController];
    
    self.tabView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 41);
    [self.view addSubview:self.tabView];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tabView.mas_bottom);
    }];
    
    [self.pageViewController setViewControllers:@[self.oneVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)addViewController {
    self.vcArray = [NSArray arrayWithObjects:@"子tab1",@"子tab2",@"子tab3",nil];
}

#pragma mark - HJTabViewDelegate
- (void)tabView:(HJTabView *)tabView selectTabAtIndex:(NSInteger)index {
    if (self.currentIndex == index) {
        return;
    }
    if (index == 0) {
        [self.pageViewController setViewControllers:@[self.oneVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    if (index == 1) {
        [self.pageViewController setViewControllers:@[self.twoVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    if (index == 2) {
        [self.pageViewController setViewControllers:@[self.thirdVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    self.currentIndex = index;
}

#pragma mark - UIPageViewControllerDelegate/dataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == self.oneVC) {
        return nil;
    }
    if (viewController == self.twoVC) {
        return self.oneVC;
    }
    if (viewController == self.thirdVC) {
        return self.thirdVC;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == self.oneVC) {
        return self.twoVC;
    }
    if (viewController == self.twoVC) {
        return self.thirdVC;
    }
    if (viewController == self.thirdVC) {
        return nil;
    }
    return nil;
}

//当翻页动画结束时调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        UIViewController *viewController = pageViewController.viewControllers.firstObject;
        if (viewController == self.oneVC) {
            self.tabView.selectIndex = 0;
        }
        if (viewController == self.twoVC) {
            self.tabView.selectIndex = 1;
        }
        if (viewController == self.thirdVC) {
            self.tabView.selectIndex = 2;
        }
        self.currentIndex = self.tabView.selectIndex;
    }
}

#pragma mark - UIPageViewControllerScrollViewDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController scrollViewDidScroll:(CGFloat)offset {
    [self.tabView setUnderLineViewOffset:offset];
}

#pragma mark - lazy load
- (FirstChildOneViewController *)oneVC {
    if (_oneVC) {
        return _oneVC;
    }
    _oneVC = [[FirstChildOneViewController alloc] init];
    return _oneVC;
}

- (FirstChildTwoViewController *)twoVC {
    if (_twoVC) {
        return _twoVC;
    }
    _twoVC = [[FirstChildTwoViewController alloc] init];
    return _twoVC;
}

- (FirstChildThreeViewController *)thirdVC {
    if (_thirdVC) {
        return _thirdVC;
    }
    _thirdVC = [[FirstChildThreeViewController alloc] init];
    return _thirdVC;
}

- (HJTabView *)tabView {
    if (_tabView) {
        return _tabView;
    }
    _tabView = [[HJTabView alloc] init];
    _tabView.selectIndex = self.currentIndex;
    _tabView.titles = self.vcArray;
    _tabView.delegate = self;
    return _tabView;
}

@end
