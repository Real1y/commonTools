//
//  BLHttpClient.m
//  Supor
//
//  Created by 古北电子 on 2018/8/15.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLHttpClient.h"

@implementation BLHttpClient

+ (void)bl_httpRequestMethod:(NSString *)method
                         url:(NSString *)url
                      params:(NSDictionary *)params
                     success:(void (^)(id))success
                     failure:(void (^)(NSString *, NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    [manager setSecurityPolicy:securityPolicy];
    
    //设置内容请求响应类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    
    if ([method isEqualToString:BLHttpRequest_GET]) {
        [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
            failure(error.localizedDescription, errorCode);
        }];
    } else if ([method isEqualToString:BLHttpRequest_POST]) {
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
            failure(error.localizedDescription, errorCode);
        }];
    }
}

+ (void)bl_httpRequestMethod:(NSString *)method
                         url:(NSString *)url
                      params:(id)params
                      header:(NSDictionary *)header
                     success:(void (^)(id))success
                     failure:(void (^)(NSString *, NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    [manager setSecurityPolicy:securityPolicy];
    
    //设置内容请求响应类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];

    NSMutableDictionary *resultHeader = [[NSMutableDictionary alloc] initWithDictionary:header];
    if ([header isKindOfClass:[NSDictionary class]]) {
        NSArray *keysArray = header.allKeys;
        for (NSString *key in keysArray) {
            [resultHeader setObject:BL_IsStrEmpty([header objectForKey:key]) ? @"" : [header objectForKey:key] forKey:key];
        }
        
        [self setHeaderWithAFHTTPSessionManager:manager header:resultHeader];
    }
    
    if ([method isEqualToString:BLHttpRequest_GET]) {
        [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
            failure(error.localizedDescription, errorCode);
        }];
    } else if ([method isEqualToString:BLHttpRequest_POST]) {
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
            failure(error.localizedDescription, errorCode);
        }];
    }
}

#pragma mark - 设置请求头
+ (void)setHeaderWithAFHTTPSessionManager:(AFHTTPSessionManager *)manager header:(NSDictionary *)header {
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

@end
