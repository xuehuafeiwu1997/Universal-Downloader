//
//  DownloadSegment.h
//  万能下载器
//
//  Created by 许明洋 on 2020/7/23.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadSegment : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableDictionary *info;

@end

NS_ASSUME_NONNULL_END
