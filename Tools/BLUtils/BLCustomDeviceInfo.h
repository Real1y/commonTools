//
//  BLCustomDeviceInfo.h
//  Supor
//
//  Created by 古北电子 on 2018/8/20.
//  Copyright © 2018年 古北电子. All rights reserved.
//
//自定义类，用于存放家庭设备的各种信息

#import <Foundation/Foundation.h>

@interface BLCustomDeviceInfo : NSObject

@property (nonatomic, strong) BLFamilyDeviceInfo *deviceInfo;

@property (nonatomic, strong) BLModuleInfo *moduleInfo;

@property (nonatomic, strong) BLFamilyInfo *familyInfo;

@end
