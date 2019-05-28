//
//  BLRoutesManager.h
//  Supor
//
//  Created by 古北电子 on 2018/8/30.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLRoutesManager : NSObject

+ (BLRoutesManager *)sharedRoutes;

@property (nonatomic, strong) UINavigationController *navi;

@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) NSMutableDictionary *routesDict;

//添加路由

+ (void)addRoute:(NSString *)routePattern className:(NSString *)className handler:(BOOL (^__nullable)(NSDictionary<NSString *, id> *parameters))handlerBlock;

//路由跳转
+ (BOOL)openUrl:(NSString *)url;

@end
