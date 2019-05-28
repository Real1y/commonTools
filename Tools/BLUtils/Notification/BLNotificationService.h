//
//  BLNotificationService.h
//  Supor
//
//  Created by 古北电子 on 2018/8/22.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLNotificationTempInfo.h"
#import "BLNotificationLinkageInfo.h"

@interface BLNotificationService : NSObject

@property (nonatomic, copy) NSString *deviceToken;

+ (BLNotificationService *)sharedInstance;

//注册deviceToken到推送服务器
- (void)registerDeviceToken;

/**
 用户推送设置

 @param state 根据state设置是开启推送还是关闭推送
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setAllPushState:(BOOL)state
                success:(void (^)(id responseObj))success
                failure:(void (^)(NSString *errorMsg, NSString *errorCode))failure;;

//用户退出账号，需要调用此接口
- (void)userSignOutSuccess:(void (^)(id responseObj))success
                   failure:(void (^)(NSString *errorMsg, NSString *errorCode))failure;

//模板查询接口
- (void)queryModuleCategoryPid:(NSString *)pid
                       success:(void (^)(id responseObj))success
                       failure:(void (^)(NSString *errorCode, NSString *errorMsg))failure;

/**
 联动增加（模板实例化）

 @param cdeviceInfoArray 需要实例化模板的设备
 @param linkAgeInfoArray 通过模板实例化查询接口获得，用来过滤已经实例化过模板的设备
 @param success 成功回调
 @param failure 失败回调
 */
- (void)linkageAdd:(NSMutableArray<BLCustomDeviceInfo *> *)cdeviceInfoArray
  linkAgeInfoArray:(NSMutableArray<LinkAgeInfo *> *)linkAgeInfoArray
           success:(void (^)(id responseObj))success
           failure:(void (^)(NSString *errorCode, NSString *errorMsg))failure;

//模板实例化查询，成功返回BLNotificationLinkageInfo
- (void)linkageQueryIOS:(BOOL)isIOS
                success:(void (^)(id responseObj))success
                failure:(void (^)(NSString *errorCode, NSString *errorMsg))failure;

//推送历史记录查询
- (void)queryNotificationHistory:(BOOL)queryFlag
                         success:(void (^)(id responseObj))success
                         failure:(void (^)(NSString *errorCode, NSString *errorMsg))failure;

//根据ruleid删除已实例化的推送模板
- (void)deleteLinkage:(NSMutableArray<LinkAgeInfo *> *)linkAgeInfoArray
              success:(void (^)(id responseObj))success
              failure:(void (^)(NSString *errorCode, NSString *errorMsg))failure;

//清除重复的实例化模板
- (void)clearExcessLinkageInfo:(NSMutableArray<LinkAgeInfo *> *)linkAgeInfoArray;

/**
 推送角标重置，不关心请求是否成功
 
 @param badge 0则重置；负数则在原计数基础上-n，最低减到0；正数则报错
 @param success 成功回调
 @param failure 失败回调
 */
- (void)updateBadge:(NSInteger)badge
            success:(void (^)(id responseObj))success
            failure:(void (^)(NSString *errorCode, NSString *errorMsg))failure;

@end
