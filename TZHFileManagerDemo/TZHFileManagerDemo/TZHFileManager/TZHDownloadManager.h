//
//  TZHDownloadManager.h
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZHDownloadManager : NSObject

@property(nonatomic,strong)NSString *fileName;

+(instancetype)shared;

//异步下载的方法 进度的block
-(void)downloadAudioWithURL:(NSURL *)url andFormat:(NSString *)format progress:(void(^)(float progress))progressBlock complete:(void(^)(NSString *fileSavePath,NSError *error))completeBlock;

//判断是否正在下载
-(BOOL)isDownloadingAudioWithURL:(NSURL *)url;


//取消下载
- (void)cancelDownloadingAudioWithURL:(NSURL *)url andFormat:(NSString *)format complete:(void (^)())completeBlock;


//显示文件占内存大小
+ (NSString *)getFileCacheSize;
//删除文件

+(void)deleteFileFromCache;

@end
