//
//  BLRoutesManager.m
//  Supor
//
//  Created by 古北电子 on 2018/8/30.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLRoutesManager.h"
#import "NSString+BLCategory.h"
#import "BLCommonWebViewController.h"
#import "BLWebControlViewController.h"
#import "BLDeviceService.h"

#define Jump_Url        @"jumpUrl"
#define Did             @"did"
#define Nav             @"nav"

@interface BLRoutesManager ()

@end

@implementation BLRoutesManager

+ (BLRoutesManager *)sharedRoutes {
    static BLRoutesManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BLRoutesManager new];
    });
    
    return instance;
}

- (NSMutableDictionary *)routesDict {
    if (_routesDict == nil) {
        _routesDict = [[NSMutableDictionary alloc] init];
    }
    
    return _routesDict;
}

+ (void)addRoute:(NSString *)routePattern className:(NSString *)className handler:(BOOL (^)(NSDictionary<NSString *,id> *))handlerBlock {
    NSMutableDictionary *routesDict = [BLRoutesManager sharedRoutes].routesDict;
    [routesDict setObject:className forKey:routePattern];
    
    [[JLRoutes routesForScheme:BL_Routes] addRoute:routePattern handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        Class class = NSClassFromString([routesDict objectForKey:routePattern]);
        UIViewController *cVC = [[class alloc] init];
        UIViewController *lastVC = [BLRoutesManager sharedRoutes].navi.viewControllers.lastObject;
        //判断如果已是当前视图，则无需再进行跳转
        if ([lastVC isKindOfClass:class]) {
            NSLog(@"当前已处于该视图");
            handlerBlock(@{kCurrentVC : [NSNumber numberWithBool:YES]});
        }else {
            UINavigationController *nav = parameters[Nav];
            if ([routePattern isEqualToString:kWebViewRoute]) {
                BLCommonWebViewController *vc = [[BLCommonWebViewController alloc] init];
                vc.requestUrl = parameters[Jump_Url];
                [BLRoutesManager sharedRoutes].currentVC = vc;
                [nav pushViewController:vc animated:YES];
            }else if ([routePattern isEqualToString:kWebControlRoute]) {
                NSString *did = parameters[Did];
                for (BLCustomDeviceInfo *cDeviceInfo in [BLFamilyInfoManager sharedInstance].allCDeviceArray) {
                    if ([cDeviceInfo.deviceInfo.did isEqualToString:did]) {
                        BLDNADevice *selectDevice = [[BLFamilyInfoManager sharedInstance] blModuleInfoToBLDNADevice:cDeviceInfo.moduleInfo];
                        selectDevice.state = [[BLLet sharedLet].controller queryDeviceState:selectDevice.did];
                        [BLDeviceService sharedDeviceService].selectDevice = selectDevice;
                        [BLDeviceService sharedDeviceService].cDeviceInfo = cDeviceInfo;
                        
                        BLWebControlViewController *vc = [BLWebControlViewController webCtrlVC:cDeviceInfo hiddenNavi:YES];
                        [BLRoutesManager sharedRoutes].currentVC = vc;
                        [nav pushViewController:vc animated:YES];
                        break;
                    }
                }
                
            }else {
                [BLRoutesManager sharedRoutes].currentVC = cVC;
                [nav pushViewController:cVC animated:YES];
            }
            handlerBlock(parameters);
        }
        return YES;
    }];
}

+ (BOOL)openUrl:(NSString *)url {
    NSArray *array = [url componentsSeparatedByString:@"://"];
    NSArray *parameterArray = [array.lastObject componentsSeparatedByString:@"/:"];
    
    NSArray *routesKeys = [BLRoutesManager sharedRoutes].routesDict.allKeys;
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                           Nav:[BLRoutesManager sharedRoutes].navi
                                                                                           }];
    if ([routesKeys containsObject:array.lastObject]) {
        [[JLRoutes routesForScheme:BL_Routes] routeURL:[NSURL URLWithString:url] withParameters:parameterDict];
        return YES;
    }else if (parameterArray.count > 1) {//说明有参数，对应参数为设备did
        [parameterDict setObject:parameterArray.lastObject forKey:Did];
        NSArray *tempArray = [url componentsSeparatedByString:@"/:"];
        [[JLRoutes routesForScheme:BL_Routes] routeURL:[NSURL URLWithString:tempArray.firstObject] withParameters:parameterDict];
        return YES;
    }else if([NSString isUrlAddress:url]) {
        [parameterDict setObject:url forKey:Jump_Url];
        [[JLRoutes routesForScheme:BL_Routes] routeURL:[NSURL URLWithString:BL_RouteUrl(kWebViewRoute)] withParameters:parameterDict];
        return YES;
    }
    
    return NO;
}

@end
