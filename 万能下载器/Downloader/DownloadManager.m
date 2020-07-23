//
//  DownloadManager.m
//  万能下载器
//
//  Created by 许明洋 on 2020/7/17.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "DownloadManager.h"
#import "FCFileManager.h"
#import "NSString+Ruby.h"

@interface DownloadManager()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *segmentInfos;

@end

@implementation DownloadManager

+ (instancetype)sharedInstance {
    static DownloadManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //如果存在这个路径，则直接返回，否则创建这个路径
        [DownloadManager createDirectionaries];
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)createDirectionaries {
    NSString *path = [self saveFilePath];
    if ([FCFileManager existsItemAtPath:path]) {
        return;
    }
    NSError *error = nil;
    if (![FCFileManager createDirectoriesForPath:path error:&error]) {
        AppLog(@"Error create directories %@ , %@",path, error);
    }
}

- (void)downloadVideoByURl:(NSURL *)url {
    self.url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //开启下载任务
//    [[[self session] downloadTaskWithRequest:request] resume];
    [[self downloadTaskForRequest:request] resume];
}

- (NSURLSessionDownloadTask *)downloadTaskForRequest:(NSURLRequest *)request {
    return [[self session] downloadTaskWithRequest:request];
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
    NSData *m3u8Data = [[NSData alloc] initWithContentsOfURL:location];
    NSString *m3u8 = [[NSString alloc] initWithData:m3u8Data encoding:NSUTF8StringEncoding];
    [self parseM3U8File:m3u8 m3u8Url:self.url];
    
    NSString *newPath = [self createLocalM3u8];
    NSLog(@"执行了这里");
    
    NSString *path = [DownloadManager saveFilePath];
    NSString *destinationPath = [path stringByAppendingPathComponent:@"mubaishou.m3u8"];
//    if (![FCFileManager existsItemAtPath:destinationPath]) {
//        
//        [FCFileManager createFileAtPath:destinationPath];
//    }
//    [FCFileManager moveItemAtPath:location.path toPath:destinationPath overwrite:YES];
//    [FCFileManager copyItemAtPath:location.path toPath:destinationPath overwrite:YES];
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:destinationPath] error:&error];
    NSLog(@"error为%@",error);
    
    NSLog(@"执行了挪动文件的方法");
    
}

//此方法无论成功或者失败都会调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"完成：error %@",error);
}

+ (NSString *)rootPath {
    return [FCFileManager pathForLibraryDirectoryWithPath:@"st"];
}

+ (NSString *)saveFilePath {
    return [[DownloadManager rootPath] stringByAppendingPathComponent:@"download"];
}

//解析m3u8
- (void)parseM3U8File:(NSString *)m3u8 m3u8Url:(NSURL *)url {
    NSInteger segCount = 0;
    NSMutableString *headers = [[NSMutableString alloc] init];
    NSMutableArray *segments = [NSMutableArray array];
    NSMutableArray *otherFilesToDownload = [NSMutableArray array];//ts文件加密密钥
    BOOL headerFinished = NO;
    NSScanner *scanner = [NSScanner scannerWithString:m3u8];
    NSMutableCharacterSet *cs = [[NSMutableCharacterSet alloc] init];
    [cs addCharactersInString:@"\r\n"];
    NSString *morem3u8 = nil;
    NSUInteger rangeStart = 0;
    while (![scanner isAtEnd]) {
        NSString *line = nil;
        [scanner scanUpToCharactersFromSet:cs intoString:&line];
        if ([line startsWith:@"#EXTINF",nil]) {
            headerFinished = YES;
            NSString *nextLine = nil;
            NSString *range = nil;
            while (1) {
                //scanner扫描器似乎会自动切换到下一行
                [scanner scanUpToCharactersFromSet:cs intoString:&nextLine];
                //当nextLine是最后一行的时候
                if (![nextLine startsWith:@"#EXT",nil]) {
                    break;
                }
                //目前用不到
//                if ([nextLine startsWith:@"#EXT-X-BYTERANGE:",nil]) {
//                    NSString *rangeStr =
//                }
                line = [line stringByAppendingString:@"\n"];
                line = [line stringByAppendingString:nextLine];
            }
            NSString *segmentUrl = nextLine;
            if (![segmentUrl startsWith:@"http://",@"https://",nil]) {
                NSURL *trueUrl = [NSURL URLWithString:segmentUrl relativeToURL:url];
                segmentUrl = trueUrl.absoluteString;
            }
            NSMutableDictionary *segment = [NSMutableDictionary dictionary];
            segment[@"tag"] = line;
            segment[@"url"] = segmentUrl;
            if (range && [range length] > 0) {
                segment[@"range"] = range;
            }
            [segments addObject:segment];
            segCount++;
        } else if ([line startsWith:@"#EXT-X-ENDLIST"]) {
            //表示这是m3u8的最后一行
        }
    }
    self.segmentInfos = segments;
    NSLog(@"当前的 segmentInfo为:%@",self.segmentInfos);
}

- (NSString *)createLocalM3u8 {
    NSMutableString *m3u8 = [[NSMutableString alloc] init];
    NSInteger passedCount = 0;
    for (NSDictionary *seg in self.segmentInfos) {
        if (seg[@"url"] && seg[@"tag"]) {
            if ([seg[@"pass"] boolValue]) {
                passedCount++;
            }
            //下载其他文件
//            if (seg[@"file"]) {
//                [m3u8 appendString:seg[@"tag"]];
//
//            }
            [m3u8 appendString:seg[@"tag"]];
            [m3u8 appendString:@"\n"];
            [m3u8 appendString:seg[@"url"]];
            [m3u8 appendString:@"\n"];
        } else {
            if (seg[@"tag"]) {
                [m3u8 appendString:seg[@"tag"]];
                [m3u8 appendString:@"\n"];
            }
        }
    }
    NSString *path = [DownloadManager saveFilePath];
    NSString *destinationPath = [path stringByAppendingPathComponent:@"play.m3u8"];
    if (![FCFileManager existsItemAtPath:destinationPath]) {
        [FCFileManager createFileAtPath:destinationPath error:nil];
    }
    NSError *error = nil;
    BOOL success = [m3u8 writeToFile:destinationPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (success) {
        NSLog(@"文件写入成功");
    } else {
        NSLog(@"写入文件发生的错误为:%@",error);
    }
    return destinationPath;
}

//下载m3u8文件
- (void)downloadVideoTsByM3u8File {
    AppLog(@"开始下载ts");
    NSMutableDictionary *segToDownload = nil;
    segToDownload = self.segmentInfos[0];
    if (!segToDownload[@"url"]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:segToDownload[@"url"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//    [[[self session] downloadTaskWithRequest:request] resume];
    [[self downloadTaskForRequest:request] resume];
    NSURLSessionDownloadTask *task = [[self session] downloadTaskWithRequest:request];
    NSLog(@"task的identifier为%lu",(unsigned long)task.taskIdentifier);
    [task resume];
}

@end
