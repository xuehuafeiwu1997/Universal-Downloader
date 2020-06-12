//
//  UIColor+Utils.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/11.
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

@end
