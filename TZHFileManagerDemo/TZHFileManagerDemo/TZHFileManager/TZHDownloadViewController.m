//
//  TZHDownloadViewController.m
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//

#import "TZHDownloadViewController.h"
#import "TZHFilesDownloadModel.h"
#import "TZHDownloadCell.h"
#import "TZHDownloadManager.h"
#import "TZHLoadDownloadFileVC.h"

@interface TZHDownloadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *tableView;

@end
static NSString *cellID = @"cellId";

@implementation TZHDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.title = @"附件列表";
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"FileDownloadCell" bundle:nil] forCellReuseIdentifier:cellID];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 250;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.filesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TZHDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    TZHFilesDownloadModel *model = self.filesArray[indexPath.row];
    cell.model = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TZHFilesDownloadModel *model = self.filesArray[indexPath.row];
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)model.FileURL,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));

    NSURL *url = [NSURL URLWithString:encodedString];
    
    NSLog(@"打印打印  %@",model.FileURL);

    if([[TZHDownloadManager shared] isDownloadingAudioWithURL:url] ){
        
    }else{
        //下载代码
        NSString *format = model.FileName;
        NSRange range = [format rangeOfString:@"."];
        format = [format substringFromIndex:range.location];
        
        [[TZHDownloadManager shared] downloadAudioWithURL:url andFormat:format progress:^(float progress) {
            TZHDownloadCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.DownloadProgress.hidden = NO;

            model.progress = progress;
            cell.model = model;
            if(progress == 1){
                cell.DownloadProgress.hidden = YES;

            }
            
        } complete:^(NSString *fileSavePath, NSError *error) {
            
            NSLog(@"打印存储地址%@",fileSavePath);
            TZHLoadDownloadFileVC *webVC = [[TZHLoadDownloadFileVC alloc]init];
            
            [webVC loadLocalFileWebView:[TZHDownloadManager shared].fileName];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }];
    }
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
