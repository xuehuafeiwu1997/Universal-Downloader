//
//  WNTabBarController.m
//  万能下载器
//
//  Created by 许明洋 on 2020/7/21.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "WNTabBarController.h"
#import "DownloadViewController.h"//下载器
#import "WNUserViewController.h"//个人中心

@interface WNTabBarController ()

@end

@implementation WNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVC];
}

- (void)setupChildVC {
    [self setupChildVC:[DownloadViewController class] title:@"首页" image:@"tab_recommend_off" selectImage:@"tab_recommend_on"];
    [self setupChildVC:[WNUserViewController class] title:@"我的" image:@"tab_myInfo_off" selectImage:@"tab_myInfo_on"];
}

- (void)setupChildVC:(Class)child title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    UIViewController *childVC = [[child alloc] init];
    childVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    nav.title = title;
    [self addChildViewController:nav];
}

@end
