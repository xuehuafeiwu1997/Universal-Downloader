//
//  AppDelegate.m
//  万能下载器
//
//  Created by 许明洋 on 2020/7/17.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "AppDelegate.h"
#import "DownloadViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:downloadVC];
    self.window.rootViewController = nav;
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    NSLog(@"当前后台下载的identifier为%@",identifier);
    completionHandler();
}

@end
