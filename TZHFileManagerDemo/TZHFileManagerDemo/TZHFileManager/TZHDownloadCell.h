//
//  TZHDownloadCell.h
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TZHFilesDownloadModel.h"

@interface TZHDownloadCell : UITableViewCell

@property(nonatomic,strong)TZHFilesDownloadModel *model;
@property (weak, nonatomic) IBOutlet UIProgressView *DownloadProgress;

@end
