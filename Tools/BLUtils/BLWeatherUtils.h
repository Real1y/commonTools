//
//  BLWeatherUtils.h
//  Supor
//
//  Created by 古北电子 on 2018/9/7.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLWeatherDTO.h"

@interface BLMessageCenterWeatherInfo : NSObject

@property (nonatomic, strong) BLWeatherDTO *weatherDTO;

@property (nonatomic, copy) NSString *did;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, assign) BOOL isNew;

@property (nonatomic, assign) long index;

@property (nonatomic, copy) NSString *dateString;

@end

@interface BLWeatherUtils : NSObject

+ (BLWeatherUtils *)sharedUtils;

//消息中心所用天气数据数组
@property (nonatomic, strong) NSMutableArray<BLMessageCenterWeatherInfo *> *weatherInfoArray;

- (void)setPhone:(NSString *)phone
          userid:(NSString *)userid
        password:(NSString *)password
         license:(NSString *)license
         success:(void (^)(id responseObj))success
         failure:(void (^)(NSString *errorMsg, NSString *errorCode))failure;

//天气用户登录接口
- (void)weatherUserLoginSuccess:(void (^)(id responseObj))success
                        failure:(void (^)(NSString *errorMsg, NSString *errorCode))failure;

/**
 天气查询接口

 @param location 城市名、拼音、经纬度（南京、nanjing、120.207277,30.19317）
 @param success 成功回调,返回解析后的实体类及天气对应的json
 @param failure 失败回调
 */
- (void)queryWeatherWithLocation:(NSString *)location
                         success:(void (^)(BLWeatherDTO *weatherInfo, NSString *weatherJson))success
                         failure:(void (^)(NSString *errorMsg, NSString *errorCode))failure;

@end
