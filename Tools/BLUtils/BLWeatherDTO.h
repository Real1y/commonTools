//
//  BLWeatherDTO.h
//  Supor
//
//  Created by 古北电子 on 2018/9/8.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLWeatherDTO : NSObject

- (void)parseWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *aqidesc;//空气质量
@property (nonatomic, copy) NSString *aqiidx;//空气质量指数
@property (nonatomic, copy) NSString *aqilevel;//空气质量等级
@property (nonatomic, copy) NSString *aqipubtime;//空气质量上报时间
@property (nonatomic, copy) NSString *cityid;//城市ID
@property (nonatomic, copy) NSString *cityname;//城市名
@property (nonatomic, copy) NSString *co;//一氧化碳指数
@property (nonatomic, copy) NSString *feelslike;//体感温度
@property (nonatomic, copy) NSString *humidity;//相对空气湿度
@property (nonatomic, copy) NSString *no2;//二氧化氮指数
@property (nonatomic, copy) NSString *o3;//臭氧指数
@property (nonatomic, copy) NSString *pm10;//PM10指数
@property (nonatomic, copy) NSString *pm25;//PM2.5指数
@property (nonatomic, copy) NSString *pressure;//压力
@property (nonatomic, copy) NSString *so2;//二氧化硫指数
@property (nonatomic, copy) NSString *temp;//气温
@property (nonatomic, copy) NSString *uvraysdesc;//紫外线描述
@property (nonatomic, copy) NSString *uvraysidx;//紫外线指数
@property (nonatomic, copy) NSString *uvrayslevel;//紫外线强度
@property (nonatomic, copy) NSString *visibility;//能见度
@property (nonatomic, copy) NSString *weapubtime;//上报时间
@property (nonatomic, copy) NSString *weather;//天气
@property (nonatomic, copy) NSString *windabstract;//风向简写
@property (nonatomic, copy) NSString *windangle;//风向角
@property (nonatomic, copy) NSString *winddesc;//风力描述
@property (nonatomic, copy) NSString *winddir;//风向
@property (nonatomic, copy) NSString *windlevel;//风力等级
@property (nonatomic, copy) NSString *windspeed;//风速

@end
