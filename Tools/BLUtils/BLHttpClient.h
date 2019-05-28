//
//  BLHttpClient.h
//  Supor
//
//  Created by 古北电子 on 2018/8/15.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#define BLHttpRequest_GET  @"get"
#define BLHttpRequest_POST @"post"

@interface BLHttpClient : NSObject


/**
 网络请求接口，自定义参数

 @param method 请求方法
 @param url 请求链接
 @param params 请求参数，如果需要设置请求头，则在params中包一个header字典用于放置请求头
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)bl_httpRequestMethod:(NSString *)method
                         url:(NSString *)url
                      params:(NSDictionary *)params
                     success:(void (^)(id responseObj))success
                     failure:(void (^)(NSString *errorMsg, NSString *errorCode))failure;

/**
 网络请求接口，可单独设置请求头

 @param method 请求方法
 @param url 请求链接
 @param params 请求参数体
 @param header 请求头
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)bl_httpRequestMethod:(NSString *)method
                         url:(NSString *)url
                      params:(id)params
                      header:(NSDictionary *)header
                     success:(void (^)(id responseObj))success
                     failure:(void (^)(NSString *errorMsg, NSString *errorCode))failure;

@end
