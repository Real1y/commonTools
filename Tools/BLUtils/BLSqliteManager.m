//
//  BLSqliteManager.m
//  Supor
//
//  Created by 古北电子 on 2018/8/15.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLSqliteManager.h"
#import <pthread.h>

pthread_mutex_t db_mutex = PTHREAD_MUTEX_INITIALIZER;

#define DB_NAME @"BLDataManager.sqlite"

@implementation BLSqliteManager

+ (BLSqliteManager *)sharedInstance
{
    static BLSqliteManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[BLSqliteManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if(self){
        NSString *dbPath = [[self getDocumentDirectory] stringByAppendingPathComponent:DB_NAME];
        self.db = [[FMDatabase alloc] initWithPath:dbPath];
        
        [self createTables];
    }
    return self;
}

- (NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex: 0];
}

- (void)initAllDatas {
    
}

//@TODO db_mutex考虑用更好的方法维护
- (BOOL)openDb {
    pthread_mutex_lock(&db_mutex);
    return [self.db open];
}

- (BOOL)closeDb {
    BOOL result = [self.db close];
    pthread_mutex_unlock(&db_mutex);
    return result;
}

#pragma mark 创建表
- (void)createTables {
    [self customTableInit];
}

- (void)customTableInit
{
}

@end
