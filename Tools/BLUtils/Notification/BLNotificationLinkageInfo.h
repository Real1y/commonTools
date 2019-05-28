//
//  BLNotificationLinkageInfo.h
//  Supor
//
//  Created by 古北电子 on 2018/9/13.
//  Copyright © 2018年 古北电子. All rights reserved.
//
//模板实例化信息
#import <Foundation/Foundation.h>

@interface LinkAgeInfo : NSObject

- (void)parseWithDict:(NSDictionary *)dict;

//根据以下三个id判断一个设备是否已经实例化推送模板
@property (nonatomic, copy) NSString *did;

@property (nonatomic, copy) NSString *familyId;

//模板id
@property (nonatomic, copy) NSString *templateId;

//已实例化的ruleid
@property (nonatomic, copy) NSString *ruleid;

//是否是iOS实例化的模板
@property (nonatomic, assign) BOOL iOSFlag;

//模板实例化时间
@property (nonatomic, copy) NSString *createTime;

@end

@interface BLNotificationLinkageInfo : NSObject

- (void)parseWithDict:(NSDictionary *)dict isIOS:(BOOL)isIOS;

@property (nonatomic, strong) NSMutableArray<LinkAgeInfo *> *linkAgeInfoArray;

@end
