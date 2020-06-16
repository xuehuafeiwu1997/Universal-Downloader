//
//  AppDelegate.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/11.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Main2ViewController.h"
#import "Main3ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
 MainViewController:关于UIPageViewController的封装实现
 Main2ViewController:使用scrollViewDelegate的滚动协议实现相应的collectionView的滑动功能，效果并不是太好，一次滑动一个cell可以很好的实现，滑动多个不行
 Main3ViewController:使用自定义flowLayout实现滑动多个cell的效果，可以很好的实现，而且也有无限轮播的功能
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    MainViewController *vc = [[MainViewController alloc] init];
//    Main2ViewController *vc = [[Main2ViewController alloc] init];
//    Main3ViewController *vc = [[Main3ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    return YES;
}


@end
