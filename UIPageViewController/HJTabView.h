//
//  HJTabView.h
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/11.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HJTabView;
@protocol HJTabChangedDelegate <NSObject>

- (void)tabView:(HJTabView *)tabView selectTabAtIndex:(NSInteger)index;

@end

@interface HJTabView : UIView

@property(nonatomic) NSInteger selectIndex;
@property(nonatomic) NSArray *titles;
@property(nonatomic, weak) id<HJTabChangedDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
