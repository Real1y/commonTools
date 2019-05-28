//
//  BLNotificationTempInfo.h
//  Supor
//
//  Created by 古北电子 on 2018/9/6.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLTempInfo : NSObject

//解析获得的模板信息
- (void)parseTempInfoDict:(NSDictionary *)dict;

@property (nonatomic, strong) NSDictionary *characteristicinfo;

//条件信息
@property (nonatomic, strong) NSDictionary *conditionsinfo;

//模板信息
@property (nonatomic, strong) NSMutableDictionary *externDict;

//events中的内容是根据获取到的模板，再在原有默认值的基础上按需修改增加对应的值（如ref_value）即可
@property (nonatomic, strong) NSMutableArray *eventsArray;

@property (nonatomic, copy) NSString *templateid;

@property (nonatomic, copy) NSString *templatename;

@end

@interface BLNotificationTempInfo : NSObject

+ (BLNotificationTempInfo *)sharedTempInfo;

- (void)clearNotificationTempInfo;

//解析获得的模板信息
- (void)parseTempInfoDict:(NSDictionary *)dict;

@property (nonatomic, strong) NSMutableArray<BLTempInfo *> *tempInfoArray;

- (NSDictionary *)setCharacteristicinfoIdev_did:(NSString *)did eventsArray:(NSMutableArray *)eventsArray conditionsinfo:(NSDictionary *)conditionsinfo;

- (NSDictionary *)setExternDictDeviceInfo:(BLCustomDeviceInfo *)cDeviceInfo externDict:(NSMutableDictionary *)externDict;

@end
