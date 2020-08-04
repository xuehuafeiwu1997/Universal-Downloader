//
//  DownloadManager.h
//  万能下载器
//
//  Created by 许明洋 on 2020/7/17.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const WNDownloadM3u8TsSuccessNotification;

@interface DownloadManager : NSObject



+ (instancetype)sharedInstance;
+ (NSString *)saveFilePath;

- (void)downloadVideoByURl:(NSURL *)url;

//将TS文件合并
- (void)combineTsToVideo;

@end

