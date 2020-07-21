//
//  TestViewController.m
//  万能下载器
//
//  Created by 许明洋 on 2020/7/21.
//  Copyright © 2020 许明洋. All rights reserved.
//
/*
 测试结果记录：如果一个viewController没有一个UINavigationController的话，无法使用push动画，只能使用present动画，而且self.title 不起作用
 */

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"测试控制器";
}


@end
