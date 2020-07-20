//
//  DownloadManager.m
//  万能下载器
//
//  Created by 许明洋 on 2020/7/17.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@end

@implementation DownloadManager

+ (instancetype)sharedInstance {
    static DownloadManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)downloadVideoByURl:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //开启下载任务
    [[[self session] downloadTaskWithRequest:request] resume];
}

#pragma mark - URLSession
- (NSURLSession *)session {
    static NSURLSession *session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.xumingyang.background.download"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}

#pragma mark - NSURLSessionDelegate && NSURLSessionDownloadDelegate
/*
 下载进度的回调，使用这个方法获取下载进度,如果在下载过程中程序进入后台，则此时的代理方法将不再被回调，但是下载任务依然在后台继续，如果在后台下载过程中，下载任务完成了，则系统将直接回调AppDelegate中的方法
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"进度无法获取");
    } else {
        NSLog(@"当前进度%f",(float)totalBytesWritten / totalBytesExpectedToWrite);
    }
}

//此方法只有下载成功才会被调用，文件放在location位置
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"文件下载成功存放的位置为%@",location);
}

//此方法无论成功或者失败都会调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"完成：error %@",error);
}

@end
