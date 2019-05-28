//
//  BLCommonUtils.h
//  Supor
//
//  Created by 古北电子 on 2018/8/13.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+BLCategory.h"
#import "UIColor+BLCategory.h"
#import "UIAlertAction+BLCategory.h"
#import "BLUserCenter.h"
#import "BLFamilyInfoManager.h"

typedef NS_ENUM(NSInteger, BLServerEnv) {
    BLServerEnvProductList,
    BLServerEnvDetail,
};

@interface BLCommonUtils : NSObject

+ (instancetype)sharedInstance;
- (void)initLocation;

@property (nonatomic, assign) BLServerEnv serverEnv;

@property (nonatomic, copy) NSString *uuid;

@property (assign, nonatomic) float longitude;
@property (assign, nonatomic) float latitude;
@property (strong, nonatomic) NSString *cityEn;
@property (strong, nonatomic) NSString *countryEn;

//获取当前WiFi的SSID
+ (NSString *)getCurrentWiFiSSID;

+ (NSString *)iphoneType;

+ (NSString *)preferedLanguage;

// 判断用户是否允许接收通知
+ (BOOL)isUserNotificationEnable;

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
+ (void)goToAppSystemSetting;

//生成标准的uuid
+ (NSString *)createUUID;

//推送消息文件写入
+ (void)wirteToFile:(NSArray *)array;

//推送消息数组读取
+ (NSArray *)readFromFile;

//字符串转时间
+ (NSDate *)nsstringConversionNSDate:(NSString *)dateStr;

//时间转时间戳
+ (NSString *)dateConversionTimeStamp:(NSDate *)date;

//时间字符串转时间戳
+ (NSString *)nsstringConversionTimeStamp:(NSString *)dateStr;

//时间戳转字符串
+ (NSString *)timeStampConversionNSString:(NSString *)timeStamp;

@end
