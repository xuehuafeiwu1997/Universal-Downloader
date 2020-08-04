//
//  UIViewController+Utils.h
//  万能下载器
//
//  Created by 许明洋 on 2020/8/4.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Utils)

+ (UIViewController *)topViewController;
+ (UIViewController *)topViewControllerForWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
