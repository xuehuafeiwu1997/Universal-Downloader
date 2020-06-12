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

@interface MainViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

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
    return _tabView;
}

#pragma mark - UIPageViewControllerDelegate/datesource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == self.firstVC) {
        return self.thirdVC;
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
        return self.firstVC;
    }
    return nil;
}

@end
