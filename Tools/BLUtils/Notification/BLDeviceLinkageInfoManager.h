//
//  BLDeviceLinkageInfoManager.h
//  Supor
//
//  Created by 邰光源 on 2018/12/12.
//  Copyright © 2018 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLDeviceLinkageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLDeviceLinkageInfoManager : NSObject

+ (BLDeviceLinkageInfoManager *)sharedInstance;

- (void)clear;

@property (nonatomic, strong) NSMutableArray<BLDeviceLinkageInfo *> *deviceLinkArray;

- (void)addDeviceInfo:(NSMutableArray<BLCustomDeviceInfo *> *)cDeviceInfoArray;

- (void)setDeviceInfo:(NSString *)did tempId:(NSString *)tempId linking:(BOOL)linking;

//如果返回yes，则说明正在实例化，如果返回NO，说明需要实例化
- (BOOL)deviceNeedLinkage:(NSString *)did tempId:(NSString *)tempId;

@end

NS_ASSUME_NONNULL_END
