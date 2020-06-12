//
//  MainViewController.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/11.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "MainViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "Masonry.h"
#import "HJTabView.h"

@interface MainViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,HJTabChangedDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) FirstViewController *firstVC;
@property (nonatomic, strong) SecondViewController *secondVC;
@property (nonatomic, strong) ThirdViewController *thirdVC;
@property (nonatomic ,strong) NSArray <UIViewController *> *vcArray;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) HJTabView *tabView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self addViewContrller];
    
    self.tabView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 41);
    [self.view addSubview:self.tabView];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tabView.mas_bottom).offset(0);
    }];
    
    [self.pageViewController setViewControllers:@[self.firstVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)addViewContrller {
    self.vcArray = [NSArray arrayWithObjects:@"第一个tab",@"第二个tab",@"第三个tab",nil];
    self.currentIndex = 0;
}

- (FirstViewController *)firstVC {
    if (_firstVC) {
        return _firstVC;
    }
    _firstVC = [[FirstViewController alloc] init];
    return _firstVC;
}

- (SecondViewController *)secondVC {
    if (_secondVC) {
        return _secondVC;
    }
    _secondVC = [[SecondViewController alloc] init];
    return _secondVC;
}

- (ThirdViewController *)thirdVC {
    if (_thirdVC) {
        return _thirdVC;
    }
    _thirdVC = [[ThirdViewController alloc] init];
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

#pragma mark - UIPageViewControllerDelegate/datesource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == self.firstVC) {
        return nil;
    }
    if (viewController == self.secondVC) {
        return self.firstVC;
    }
    if (viewController == self.thirdVC) {
        return self.secondVC;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == self.firstVC) {
        return self.secondVC;
    }
    if (viewController == self.secondVC) {
        return self.thirdVC;
    }
    if (viewController == self.thirdVC) {
        return nil;
    }
    return nil;
}

//当翻页动画刚开始时调用,使用这个方法在切换界面时，上面的滑块滑动的比较顺畅,但是会出现一个问题，当滑动的幅度不够大时，会恢复原先的界面，但是代码已经执行了,目前没有办法解决
//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
//    //pendingViewController包含的就是将要展示的数组
//    UIViewController *viewController = pendingViewControllers.firstObject;
//    if (viewController == self.firstVC) {
//        self.tabView.selectIndex = 0;
//    }
//    if (viewController == self.secondVC) {
//        self.tabView.selectIndex = 1;
//    }
//    if (viewController == self.thirdVC) {
//        self.tabView.selectIndex = 2;
//    }
//}

//当翻页动画结束时调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        UIViewController *viewController = pageViewController.viewControllers.firstObject;
        if (viewController == self.firstVC) {
            self.tabView.selectIndex = 0;
        }
        if (viewController == self.secondVC) {
            self.tabView.selectIndex = 1;
        }
        if (viewController == self.thirdVC) {
            self.tabView.selectIndex = 2;
        }
        self.currentIndex = self.tabView.selectIndex;
    }
}

#pragma mark - HJTabViewDelegate
- (void)tabView:(HJTabView *)tabView selectTabAtIndex:(NSInteger)index {
    if (self.currentIndex == index) {
        return;
    }
    if (index == 0) {
        [self.pageViewController setViewControllers:@[self.firstVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    if (index == 1) {
        [self.pageViewController setViewControllers:@[self.secondVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    if (index == 2) {
        [self.pageViewController setViewControllers:@[self.thirdVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    self.currentIndex = index;
}

@end
