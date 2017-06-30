//
//  TZHDownloadCell.m
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//

#import "TZHDownloadCell.h"
@interface TZHDownloadCell()

@property (weak, nonatomic) IBOutlet UILabel *FileNameLabel;

@end

@implementation TZHDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(TZHFilesDownloadModel *)model{
    
    _model = model;
    self.FileNameLabel.text = model.FileName;
    self.DownloadProgress.progress = model.progress;
}

@end
