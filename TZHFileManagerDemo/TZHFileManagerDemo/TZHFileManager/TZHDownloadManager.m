//
//  TZHDownloadManager.m
//   陶增辉文件下载预览
//
//  Created by taozenghui on 2017/6/28.
//  Copyright © 2017年 taozenghui. All rights reserved.
//

#import "TZHDownloadManager.h"
#import "NSString+Hash.h"

@interface TZHDownloadManager ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property(nonatomic,strong)NSString *fileForm;

@end
@implementation TZHDownloadManager{
    //保存下载任务对应的进度block 和 完成的block
    NSMutableDictionary *_progressBlocks;
    NSMutableDictionary *_completeBlocks;
    NSMutableDictionary *_downloadTasks;
}

static id _instance;

+(instancetype)shared{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (instancetype)init {
    self = [super init];
    
    if (self) {
        _progressBlocks = [NSMutableDictionary dictionary];
        _completeBlocks = [NSMutableDictionary dictionary];
        _downloadTasks = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (BOOL)isDownloadingAudioWithURL:(NSURL *)url {
    
    if (_completeBlocks[url]) {
        return YES;
    }
    return NO;
}

- (void)cancelDownloadingAudioWithURL:(NSURL *)url andFormat:(NSString *)format complete:(void (^)())completeBlock {
    
    NSURLSessionDownloadTask *currentTask = _downloadTasks[url];
    
    // 2.cancel
    if (currentTask) {
        
        [currentTask cancelByProducingResumeData:^(NSData *_Nullable resumeData) {
            
            [resumeData writeToFile:[self getResumeDataPathWithURL:url andFormat:format] atomically:YES];
            
            //把取消成功的结果返回
            if (completeBlock) {
                completeBlock();
            }
            
            _progressBlocks[url] = nil;
            _completeBlocks[url] = nil;
            _downloadTasks[url] = nil;
            
        }];
    }
}

//入口
- (void)downloadAudioWithURL:(NSURL *)url andFormat:(NSString *)format progress:(void (^)(float progress))progressBlock complete:(void (^)(NSString *fileSavePath, NSError *error))completeBlock {
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSLog(@"下载工具中打印格式%@",format);
    _fileForm = format;
    NSString *fileSavePath = [self getFileSavePathWithURL:url andFormat:format];
    if ([fileMan fileExistsAtPath:fileSavePath]) {
        NSLog(@"文件已经存在");
        if (completeBlock) {
            completeBlock(fileSavePath, nil);
        }
        return;
    }
    
    
    if ([self isDownloadingAudioWithURL:url]) {
        NSLog(@"正在下载");
        return;
    }
    
    
    
    [_progressBlocks setObject:progressBlock forKey:url];
    [_completeBlocks setObject:completeBlock forKey:url];
    
    
    NSString *resumeDataPath = [self getResumeDataPathWithURL:url andFormat:format];
    
    NSURLSessionDownloadTask *downloadTask;
    if ([fileMan fileExistsAtPath:resumeDataPath]) {
        
        NSData *resumeData = [NSData dataWithContentsOfFile:resumeDataPath];
        downloadTask = [self.session downloadTaskWithResumeData:resumeData];
    } else {
        downloadTask = [self.session downloadTaskWithURL:url];
    }
    
    [_downloadTasks setObject:downloadTask forKey:url];
    //开启
    [downloadTask resume];
}


- (NSString *)getResumeDataPathWithURL:(NSURL *)url andFormat:(NSString *)format{
    NSString *tmpPath = NSTemporaryDirectory();
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@",[url.absoluteString md5String],format];
    return [tmpPath stringByAppendingPathComponent:fileName];
}


- (NSString *)getFileSavePathWithURL:(NSURL *)url andFormat:(NSString *)format{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *TZHCachePath = [cachePath stringByAppendingPathComponent:@"TZHDownloadFile"];
    [fileManager createDirectoryAtPath:TZHCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@",[url.absoluteString md5String],format];
    _fileName = fileName;
    return [TZHCachePath stringByAppendingPathComponent:fileName];
}

#pragma mark sessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSURL *currentURL = downloadTask.currentRequest.URL;
    [fileMan copyItemAtPath:location.path toPath:[self getFileSavePathWithURL:currentURL andFormat:_fileForm] error:NULL];
    
    
    if (_completeBlocks[currentURL]) {
        void (^tmpCompBlock)(NSString *filePath, NSError *error) = _completeBlocks[currentURL];
        tmpCompBlock([self getFileSavePathWithURL:currentURL andFormat:_fileForm], nil);
    }
    
    
    _progressBlocks[currentURL] = nil;
    _completeBlocks[currentURL] = nil;
    _downloadTasks[currentURL] = nil;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    float progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    
    
    NSURL *url = downloadTask.currentRequest.URL;
    if (_progressBlocks[url]) {
        
        void (^tmpProBlock)(float) = _progressBlocks[url];
        tmpProBlock(progress);
    }
}

+ (NSString *)getFileCacheSize{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *TZHCachePath = [cachePath stringByAppendingPathComponent:@"TZHDownloadFile"];
    
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:TZHCachePath];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        filePath =[TZHCachePath stringByAppendingPathComponent:subPath];
        
        BOOL isDirectory = NO;
        
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            
            continue;
        }
        
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        
        totleSize += size;
    }
    
    
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    
    return totleStr;

}

+(void)deleteFileFromCache{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *TZHCachePath = [cachePath stringByAppendingPathComponent:@"TZHDownloadFile"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:TZHCachePath error:nil];
    
    for(NSString *fileName in array){
        
        [fileManager removeItemAtPath:[TZHCachePath stringByAppendingPathComponent:fileName] error:nil];
    }
    
   
}
@end




























