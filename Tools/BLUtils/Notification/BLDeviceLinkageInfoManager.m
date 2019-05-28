//
//  BLDeviceLinkageInfoManager.m
//  Supor
//
//  Created by 邰光源 on 2018/12/12.
//  Copyright © 2018 古北电子. All rights reserved.
//

#import "BLDeviceLinkageInfoManager.h"
#import "BLNotificationTempInfo.h"

static BLDeviceLinkageInfoManager *sharedInstance = nil;
static dispatch_once_t onceToken;

@implementation BLDeviceLinkageInfoManager

+ (BLDeviceLinkageInfoManager *)sharedInstance {
    dispatch_once(&onceToken, ^{
        sharedInstance = [BLDeviceLinkageInfoManager new];
    });
    
    return sharedInstance;
}

- (void)clear {
    sharedInstance = nil;
    onceToken = 0;
}

- (NSMutableArray<BLDeviceLinkageInfo *> *)deviceLinkArray {
    if (_deviceLinkArray == nil) {
        _deviceLinkArray = [[NSMutableArray alloc] init];
    }
    
    return _deviceLinkArray;
}

- (void)addDeviceInfo:(NSMutableArray<BLCustomDeviceInfo *> *)cDeviceInfoArray {
    for (BLCustomDeviceInfo *cDeviceInfo in cDeviceInfoArray) {
        [self addDid:cDeviceInfo.deviceInfo.did];
    }
}

- (void)addDid:(NSString *)did {
    @synchronized (self.deviceLinkArray) {
        for (BLDeviceLinkageInfo *info in self.deviceLinkArray) {
            if ([did isEqualToString:info.did]) {
                return;
            }
        }
        
        for (BLTempInfo *tempInfo in [BLNotificationTempInfo sharedTempInfo].tempInfoArray) {
            BLDeviceLinkageInfo *info = [[BLDeviceLinkageInfo alloc] init];
            info.did = did;
            info.tempId = tempInfo.templateid;
            info.linking = NO;
            [self.deviceLinkArray addObject:info];
        }
    }
}

- (void)setDeviceInfo:(NSString *)did tempId:(NSString *)tempId linking:(BOOL)linking {
    @synchronized (self.deviceLinkArray) {
        for (BLDeviceLinkageInfo *info in self.deviceLinkArray) {
            if ([did isEqualToString:info.did] && [tempId isEqualToString:info.tempId]) {
                info.linking = linking;
                return;
            }
        }
    }
}

- (BOOL)deviceNeedLinkage:(NSString *)did tempId:(nonnull NSString *)tempId {
    @synchronized (self.deviceLinkArray) {
        for (BLDeviceLinkageInfo *info in self.deviceLinkArray) {
            if ([did isEqualToString:info.did] && [tempId isEqualToString:info.tempId]) {
                return info.linking;
            }
        }
    }
    
    return YES;
}

@end
