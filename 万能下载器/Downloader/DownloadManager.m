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
#import "DownloadSegment.h"

NSString * const WNDownloadM3u8TsSuccessNotification = @"WNDownloadM3u8TsSuccessNotification";

@interface DownloadManager()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *segmentInfos;
@property (nonatomic, strong) NSMutableDictionary *downloadTasks;
@property (nonatomic, strong) NSOperationQueue *queue;//设置一个队列，将其他的任务放进队列，异步执行，实现多线程的下载
@property (nonatomic, assign) NSInteger maxDownloadCount;

@end

void runAsynOnDownloadOperationQueue(void (^block) (void)) {
    NSOperationQueue *q = [DownloadManager sharedInstance].queue;
    NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock:block];
    [q addOperation:bo];
};

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

- (instancetype)init {
    self = [super init];
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 5;//设置线程的最大并发数量
    [self addObserve];
    return self;
}

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTs:) name:WNDownloadM3u8TsSuccessNotification object:nil];
}

- (void)downloadTs:(NSNotification *)notification {
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    //单线程下载ts文件
    [self downloadVideoTsByM3u8FileUsingSignleThread];
    //多线程下载ts文件
    runAsynOnDownloadOperationQueue(^{
        [self downloadVideoTsByM3u8File];
        NSLog(@"当前的线程是:%@",[NSThread currentThread]);
    });
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
        NSLog(@"当前线程%@,当前进度%f",[NSThread currentThread],(float)totalBytesWritten / totalBytesExpectedToWrite);
    }
}

//此方法只有下载成功才会被调用，文件放在location位置
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSString *type = [self.url absoluteString];
    if ([type containsString:@"m3u8"]) {
        AppLog(@"当前需要下载的文件类型为m3u8");
//        NSData *m3u8Data = [NSData dataWithContentsOfURL:location];
//        uint8_t *bytes = malloc(sizeof(uint8_t));
//        [m3u8Data getBytes:bytes range:NSMakeRange(0, 1)];
//        BOOL m3u8 = NO;
//        if (bytes[0] == '#') {
//            m3u8 = YES;
//        }
//        free(bytes);
//        if (m3u8) {
//            [self FileIsM3U8DownloadTask:downloadTask didFinishDownloadingToURL:location];
//        } else {
//            AppLog(@"判断文件类型错误");
//            return;
//        }
        [self FileIsM3U8DownloadTask:downloadTask didFinishDownloadingToURL:location];
    } else if ([type containsString:@"mp4"]) {
        AppLog(@"当前需要下载的文件类型为视频mp4");
        [self FileIsMp4DownloadTask:downloadTask didFinishDownloadingToURL:location];
    } else if ([type containsString:@"jpg"] || [type containsString:@"png"] || [type containsString:@"JPEG"]) {
        AppLog(@"当前需要下载的文件类型为图片");
        [self FileIsPhotoDownloadTask:downloadTask didFinishDownloadingToURL:location];
    }
}

//下载的文件是图片的话，图片下载后续的处理
- (void)FileIsPhotoDownloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *path = [[DownloadManager saveFilePath] stringByAppendingPathComponent:@"Photo"];
    if (![FCFileManager existsItemAtPath:path]) {
        NSError *error = nil;
        [FCFileManager createDirectoriesForPath:path error:&error];
        if (error) {
            NSLog(@"创建photo文件夹失败，失败的原因是%@",error);
        }
    }
    NSString *fileName = [NSString stringWithFormat:@"焰灵姬.%@",[self judgePhotoTypeByLocationUrl:location]];
    NSLog(@"当前需要下载的图片的type为:%@",fileName);
    //将临时存储的文件地址移动到我们自定义的地址中
    NSString *destinationPath = [path stringByAppendingPathComponent:fileName];
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:destinationPath] error:&error];
    if (error) {
        AppLog(@"移动图片失败，相应的失效的原因为%@",error);
    }
}

- (NSString *)judgePhotoTypeByLocationUrl:(NSURL *)location {
    //判断下载完成的图片的类型，参考SDWebImage的判断实现
    NSData *imageData = [NSData dataWithContentsOfURL:location];
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
            break;
        case 0x89:
            return @"png";
            break;
        case 0x49:
        case 0x4D:
            return @"tiff";
            break;
        case 0x52:
            if (imageData.length > 12) {
                //RIFF...WEBP
                   NSString *testString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                             if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                                 return @"webp";
                }
            }
            break;
        default:
            break;
    }
    return nil;
}

//下载的文件是mp4的话，m3u8下载完成的后续处理
- (void)FileIsMp4DownloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *path = [[DownloadManager saveFilePath] stringByAppendingPathComponent:@"mp4"];
    if (![FCFileManager existsItemAtPath:path]) {
        NSError *error = nil;
        [FCFileManager createDirectoriesForPath:path error:&error];
        if (error) {
            AppLog(@"创建mp4文件夹失败，错误为%@",error);
        }
    }
    //将临时存储文件的地址挪到我们自定义的地方
    NSString *destinationPath = [path stringByAppendingPathComponent:@"test.mp4"];
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:destinationPath] error:&error];
    if (error) {
        AppLog(@"在移动mp4的文件时出错，错误为%@",error);
    }
    AppLog(@"下载文件完成，存储的路径为%@",destinationPath);
}

//下载的文件是m3u8的话，m3u8下载完成的后续处理
- (void)FileIsM3U8DownloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *path = [[DownloadManager saveFilePath] stringByAppendingPathComponent:@"m3u8"];
    if (![FCFileManager existsItemAtPath:path]) {
        NSError *error = nil;
        [FCFileManager createDirectoriesForPath:path error:&error];
        if (error) {
            AppLog(@"创建m3u8文件夹失败，错误为%@",error);
        }
    }
    if (self.downloadTasks[downloadTask]) {
        DownloadSegment *segment = self.downloadTasks[downloadTask];
        //转存文件
        //必须要在这个线程中完成
        NSString *fileName = segment.info[@"fileName"];
        if (!fileName || [fileName length] == 0) {
            fileName = [self fileNameForSegmentNo:segment.index fileType:@"ts"];
        }
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSError *err = nil;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:&err];
        NSLog(@"下载的ts文件是否出错%@",err);
        [[NSNotificationCenter defaultCenter] postNotificationName:WNDownloadM3u8TsSuccessNotification object:nil userInfo:@{@"index":@(segment.index)}];
        return;
    }
    NSLog(@"文件下载成功存放的位置为%@",location);
    NSData *m3u8Data = [[NSData alloc] initWithContentsOfURL:location];
    NSString *m3u8 = [[NSString alloc] initWithData:m3u8Data encoding:NSUTF8StringEncoding];
    [self parseM3U8File:m3u8 m3u8Url:self.url];
    [self createLocalM3u8:path];
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
    //单线程下载m3u8文件
//    [self downloadVideoTsByM3u8FileUsingSignleThread];
    //多线程下载m3u8文件
    runAsynOnDownloadOperationQueue(^{
       [self downloadVideoTsByM3u8File];
    });
}

- (void)createLocalM3u8:(NSString *)path {
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
}

//下载m3u8文件
- (void)downloadVideoTsByM3u8File {
    if ([self.downloadTasks count] >= [self maxDownloadCount]) {
        return;
    }
    static int i = 0;
    if (i >= self.segmentInfos.count) {
        return;
    }
    AppLog(@"开始下载第%d个片段ts",i);
    NSMutableDictionary *segToDownload = nil;
    segToDownload = self.segmentInfos[i];
    if (!segToDownload[@"url"]) {
        return;
    }
    DownloadSegment *segment = [[DownloadSegment alloc] init];
    segment.index = i;
    segment.info = self.segmentInfos[i];
    NSURL *url = [NSURL URLWithString:segToDownload[@"url"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLSessionDownloadTask *task = [[self session] downloadTaskWithRequest:request];
    self.downloadTasks[task] = segment;
    NSLog(@"task的identifier为%lu",(unsigned long)task.taskIdentifier);
    [task resume];
    i++;
    //    （多线程下载m3u8，但是存在问题，经常有ts没有被下载，而跳过）
//    runAsynOnDownloadOperationQueue(^{
//        [self downloadVideoTsByM3u8File];
//        NSLog(@"当前的线程为%@",[NSThread currentThread]);
//    });
}

//单线程下载m3u8,当第一个ts下载完毕之后开始下载第二个ts,
- (void)downloadVideoTsByM3u8FileUsingSignleThread {
    static int i = 0;
    if (i >= self.segmentInfos.count) {
        return;
    }
    AppLog(@"开始下载第%d个片段ts",i);
    NSMutableDictionary *segToDownload = nil;
    segToDownload = self.segmentInfos[i];
    if (!segToDownload[@"url"]) {
        return;
    }
    DownloadSegment *segment = [[DownloadSegment alloc] init];
    segment.index = i;
    segment.info = self.segmentInfos[i];
    NSURL *url = [NSURL URLWithString:segToDownload[@"url"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLSessionDownloadTask *task = [[self session] downloadTaskWithRequest:request];
       self.downloadTasks[task] = segment;
    NSLog(@"task的identifier为%lu",(unsigned long)task.taskIdentifier);
    [task resume];
    i++;
}

- (NSString *)fileNameForSegmentNo:(NSInteger)segmentNo fileType:(NSString *)ext {
    if (!ext) {
        ext = @"mp4";
    }
    return [NSString stringWithFormat:@"%@.%@",@(segmentNo),ext];
}

- (NSMutableDictionary *)downloadTasks {
    if (_downloadTasks) {
        return _downloadTasks;
    }
    _downloadTasks = [NSMutableDictionary dictionary];
    return _downloadTasks;
}

- (void)combineTsToVideo {
    NSString *path = [[DownloadManager saveFilePath] stringByAppendingPathComponent:@"m3u8"];
    NSString *fileName = @"许明洋.ts";
    NSString *filePath = [[DownloadManager saveFilePath] stringByAppendingPathComponent:fileName];
    if ([FCFileManager existsItemAtPath:filePath]) {
        NSLog(@"已经合并过该文件");
        return;
    }
    
    NSArray *contentArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSMutableData *dataArr = [[NSMutableData alloc] init];
    int videoCount = 0;
    for (NSString *str in contentArr) {
        //按顺序拼接ts文件
        if ([str containsString:@"ts"]) {
            NSString *videoName = [NSString stringWithFormat:@"%d.ts",videoCount];
            NSString *videoPath = [path stringByAppendingPathComponent:videoName];
            //读出数据
            NSData *data = [[NSData alloc] initWithContentsOfFile:videoPath];
            //合并数据
            [dataArr appendData:data];
            videoCount++;
        }
    }
    
    [dataArr writeToFile:filePath atomically:YES];
    AppLog(@"合并TS文件成功");
}

- (NSInteger)maxDownloadCount {
    if (_maxDownloadCount <= 0) {
        return 5;
    }
    return _maxDownloadCount;
}

//将合并后的ts文件转换成mp4格式 （需要使用ffmpeg 目前还是先不做了，留个接口在这）
- (void)coverFullTsToMP4:(NSString *)filePath {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WNDownloadM3u8TsSuccessNotification object:nil];
}

@end
