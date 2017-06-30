//
//  TZHLoadDownloadFileVC.m
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//

#import "TZHLoadDownloadFileVC.h"

#define SWIDTH self.view.frame.size.width      //屏幕宽度
#define SHEIGHT self.view.frame.size.height      //屏幕高度


@interface TZHLoadDownloadFileVC ()<UIWebViewDelegate>

@property(strong, nonatomic)UIWebView *loadWebView;

@end

@implementation TZHLoadDownloadFileVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"文件详情";
    UIButton *back=[UIButton buttonWithType:UIButtonTypeSystem];
    back.contentEdgeInsets = UIEdgeInsetsMake(0,-3*10, 0, 0);
    
    UIImage *backImage = [UIImage imageNamed:[@"TZHFileManager.bundle" stringByAppendingPathComponent:@"返回"]];
    [back setImage:backImage forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:17];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    back.frame=CGRectMake(10,10,65,50);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=item;

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.loadWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SWIDTH, SHEIGHT - 64)];
    _loadWebView.backgroundColor = [UIColor whiteColor];
    _loadWebView.delegate = self;
    _loadWebView.scalesPageToFit = YES;
}

- (void)loadLocalFileWebView:(NSString *)fileName{

    [self.view addSubview:_loadWebView];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *TZHCachePath = [cachePath stringByAppendingPathComponent:@"TZHDownloadFile"];
    
    NSString *filePath = [TZHCachePath stringByAppendingPathComponent:fileName];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_loadWebView loadRequest:request];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
