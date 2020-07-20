//
//  DownloadManager.h
//  万能下载器
//
//  Created by 许明洋 on 2020/7/17.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

+ (instancetype)sharedInstance;

- (void)downloadVideoByURl:(NSURL *)url;

@end

