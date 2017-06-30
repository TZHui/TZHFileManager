//
//  TZHFilesDownloadModel.h
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZHFilesDownloadModel : NSObject

@property(nonatomic,strong)NSString *FileName;
@property(nonatomic,strong)NSString *FileURL;
@property(nonatomic,assign)float progress;


@end
