//
//  DownloadDBHelper.h
//  万能下载器
//
//  Created by 许明洋 on 2020/8/13.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadResource.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadDBHelper : NSObject

+ (void)insertResourceObject:(DownloadResource *)resource;
+ (void)batchResourceObjects:(NSArray *)array;
+ (void)updateResourceObject:(DownloadResource *)resource;
+ (void)removeResourceObject:(DownloadResource *)resource;
+ (void)removeResourceObjects:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
