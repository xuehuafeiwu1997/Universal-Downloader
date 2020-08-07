//
//  UIColor+Utils.m
//  万能下载器
//
//  Created by 许明洋 on 2020/8/7.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor *)colorWithRGB:(NSInteger)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgb & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgb & 0xFF)) / 255.0
                           alpha:1.0];
}

+ (UIColor *)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha  {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgb & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgb & 0xFF)) / 255.0
                           alpha:alpha];
}

@end
