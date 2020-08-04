//
//  UIViewController+Utils.m
//  万能下载器
//
//  Created by 许明洋 on 2020/8/4.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

+ (UIViewController *)topViewController {
    return [self topViewControllerForWindow:nil];
}

+ (UIViewController *)topViewControllerForWindow:(UIWindow *)window {
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    if (!window) {
        return nil;
    }
    UIViewController *root = window.rootViewController;
    if (!root) {
        return nil;
    }
    UIViewController *vc = root;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

@end
