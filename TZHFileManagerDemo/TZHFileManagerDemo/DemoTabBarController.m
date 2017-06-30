//
//  DemoTabBarController.m
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//

#import "DemoTabBarController.h"
#import "DemoViewController.h"

@interface DemoTabBarController ()

@end

@implementation DemoTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];

}

-(void)creatUI{
    
    DemoViewController *tzhCheckFileVC = [[DemoViewController alloc]init];
    
    tzhCheckFileVC.title = @"查看";
    UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:tzhCheckFileVC];
    
    self.viewControllers = @[navigationVC];
}


@end
