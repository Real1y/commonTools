//
//  BLSqliteManager.h
//  Supor
//
//  Created by 古北电子 on 2018/8/15.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface BLSqliteManager : NSObject

+ (BLSqliteManager *)sharedInstance;

- (void)initAllDatas;

//自定义表项
- (void)customTableInit;

@property (nonatomic, strong) FMDatabase *db;

- (BOOL)openDb;
- (BOOL)closeDb;

@end
