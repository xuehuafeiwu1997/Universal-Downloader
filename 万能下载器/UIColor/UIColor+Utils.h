//
//  UIColor+Utils.h
//  万能下载器
//
//  Created by 许明洋 on 2020/8/7.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Utils)

+ (UIColor *)colorWithRGB:(NSInteger)rgb;

+ (UIColor *)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
