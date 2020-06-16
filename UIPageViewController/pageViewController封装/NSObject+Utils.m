//
//  NSObject+Utils.m
//  UIPageViewController
//
//  Created by 许明洋 on 2020/6/16.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>

@implementation NSObject (Utils)

+ (BOOL)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector {
    Method origMethod = class_getInstanceMethod(self, origSelector);
       Method newMethod = class_getInstanceMethod(self, newSelector);
       
       if (origMethod && newMethod) {
           if (class_addMethod(self, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
               class_replaceMethod(self, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
           } else {
               method_exchangeImplementations(origMethod, newMethod);
           }
           return YES;
       }
       return NO;
}

@end
