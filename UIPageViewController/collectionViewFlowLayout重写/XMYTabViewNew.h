//
//  XMYTabViewNew.h
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/15.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMYTabViewNew : UIView

@property (nonatomic, strong) NSArray *titles;
- (void)selectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
