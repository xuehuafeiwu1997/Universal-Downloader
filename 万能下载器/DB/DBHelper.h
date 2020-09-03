//
//  DBHelper.h
//  万能下载器
//
//  Created by 许明洋 on 2020/8/13.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBHelper : NSObject

+ (void)batchUpdate:(void(^)(FMDatabase *db))block;

+ (NSArray *)getRows:(NSString *)sql,...;

@end

NS_ASSUME_NONNULL_END
