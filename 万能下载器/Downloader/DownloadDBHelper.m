//
//  DownloadDBHelper.m
//  万能下载器
//
//  Created by 许明洋 on 2020/8/13.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "DownloadDBHelper.h"
#import "DBHelper.h"

static NSString * const kTableName = @"Resource";
static NSString * const kColumnUrl = @"url";
static NSString * const kColumnFileName = @"name";
static NSString * const kColumnType = @"type";
static NSString * const kColumnSavePath = @"path";
static NSString * const kColumnIsSuccess = @"success";
//不能使用delete，delete是sql语句中的关键词，所以需要将其修改掉
static NSString * const kColumnIsDelete = @"Isdelete";

@implementation DownloadDBHelper

+ (void)initialize {
    [self createTable];
}

+ (void)createTable {
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ("
                           "%@ TEXT,"
                           "%@ TEXT,"
                           "%@ INTEGER,"
                           "%@ TEXT,"
                           "%@ INTEGER,"
                           "%@ INTEGER)",
                           kTableName,
                           kColumnUrl,
                           kColumnFileName,
                           kColumnType,
                           kColumnSavePath,
                           kColumnIsSuccess,
                           kColumnIsDelete
                           ];
    [DBHelper batchUpdate:^(FMDatabase * _Nonnull db) {
        BOOL success = [db executeUpdate:createSql,nil];
        if (success) {
            AppLog(@"创建%@表成功",kTableName);
        } else {
            AppLog(@"创建%@表失败",kTableName);
        }
    }];
}

//插入单条数据
+ (void)insertResourceObject:(DownloadResource *)resource {
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@,%@,%@,%@) VALUES(?,?,?,?,?,?)",kTableName,kColumnUrl,kColumnFileName,kColumnType,kColumnSavePath,kColumnIsSuccess,kColumnIsDelete];
    [DBHelper batchUpdate:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:insertSql,resource.url,resource.fileName,@(resource.type),resource.savePath,@(resource.isSuccess),@(resource.isDelete)];
    }];
}

//插入多条数据
+ (void)batchResourceObjects:(NSArray *)array {
    if ([array count] == 0) {
        return;
    }
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@,%@,%@,%@) VALUES(?,?,?,?,?,?)",kTableName,kColumnUrl,kColumnFileName,kColumnType,kColumnSavePath,kColumnIsSuccess,kColumnIsDelete];
    [DBHelper batchUpdate:^(FMDatabase * _Nonnull db) {
        for (DownloadResource *resource in array) {
            [db executeUpdate:insertSql,resource.url,resource.fileName,@(resource.type),resource.savePath,@(resource.isSuccess),@(resource.isDelete)];
        }
    }];
}

//删除某条数据(根据resource的url删除相应的数据)
+ (void)removeResourceObject:(DownloadResource *)resource {
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",kTableName,kColumnUrl];
//    NSArray *result = [DBHelper getRows:sql,resource.url];
//    NSLog(@"当前的result的结果为:%@",result);
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kTableName,kColumnUrl];
    [DBHelper batchUpdate:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:deleteSql,resource.url];
    }];
}

+ (void)removeResourceObjects:(NSArray *)array {
    if ([array count] == 0) {
        return;
    }
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kTableName,kColumnUrl];
    [DBHelper batchUpdate:^(FMDatabase * _Nonnull db) {
        for (DownloadResource *resource in array) {
            [db executeUpdate:deleteSql,resource.url];
        }
    }];
}

@end
