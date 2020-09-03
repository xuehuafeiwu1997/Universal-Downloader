//
//  DownloadResource.h
//  万能下载器
//
//  Created by 许明洋 on 2020/8/13.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,WNResourceType) {
    WNResourceTypeUnknown = 0,//下载资源的类型未知
    WNResourceTypeMP4,//MP4格式
    WNResourceTypeMP3,//MP3格式
    WNResourceTypeM3U8,//m3u8格式
    WNResourceTypePhoto,//图片格式
    WNResourceTypeTxt,//txt文本格式
    WNResourceTypeHtml,//html网页格式
    
};

NS_ASSUME_NONNULL_BEGIN

@interface DownloadResource : NSObject

@property (nonatomic, strong) NSURL *url;//下载资源的url
@property (nonatomic, assign) WNResourceType type;//下载资源的类型
@property (nonatomic, copy) NSString *savePath;//存储的路径
@property (nonatomic, copy) NSString *fileName;//文件的名称
@property (nonatomic, assign) BOOL isSuccess;//是否下载完成
@property (nonatomic, assign) BOOL isDelete;//是否删除

@end

NS_ASSUME_NONNULL_END
