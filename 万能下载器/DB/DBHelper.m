//
//  DBHelper.m
//  万能下载器
//
//  Created by 许明洋 on 2020/8/13.
//  Copyright © 2020 许明洋. All rights reserved.
//

#import "DBHelper.h"
#import "FCFileManager.h"

static FMDatabaseQueue *dbqueue;
static NSString * const dbName = @"app.db";

@implementation DBHelper

+ (NSString *)dbFilePath {
    return [FCFileManager pathForDocumentsDirectoryWithPath:dbName];
}

+ (void)initialize {
    dbqueue = [FMDatabaseQueue databaseQueueWithPath:[self dbFilePath]];
}

+ (void)batchUpdate:(void (^)(FMDatabase * _Nonnull))block {
    [dbqueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        if (block) {
            block(db);
        }
    }];
}

+ (NSArray *)getRows:(NSString *)sql, ... {
    __block va_list args;
    __block NSArray *ra = nil;
    va_list *bargs = &args;
    va_start(args, sql);
    [dbqueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:sql withVAList:*bargs];
        ra = [self allRecordsFromResult:result];
        [result close];
    }];
    va_end(args);
    return ra;
}

+ (NSArray *)allRecordsFromResult:(FMResultSet *)rs {
    NSMutableArray *allRecords = [[NSMutableArray alloc] init];
    if (rs) {
        while ([rs next]) {
            [allRecords addObject:rs.resultDictionary];
        }
    }
    return allRecords;
}

@end
