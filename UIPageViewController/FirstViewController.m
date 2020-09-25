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

@interface FirstViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) FirstChildOneViewController *oneVC;
@property (nonatomic, strong) FirstChildTwoViewController *twoVC;
@property (nonatomic, strong) FirstChildThreeViewController *thirdVC;
@property (nonatomic, strong) NSArray <UIViewController *> *vcArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"界面一";
    self.view.backgroundColor = [UIColor yellowColor];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addViewController];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController setViewControllers:@[self.oneVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)addViewController {
    self.vcArray = [NSArray arrayWithObjects:@"子tab1",@"子tab2",@"子tab3",nil];
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

@end
