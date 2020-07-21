//
//  WNUserViewController.m
//  万能下载器
//
//  Created by 许明洋 on 2020/7/21.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "WNUserViewController.h"
#import "TestViewController.h"

@interface WNUserViewController ()

@end

@implementation WNUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TestViewController *testVC = [[TestViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}

@end
