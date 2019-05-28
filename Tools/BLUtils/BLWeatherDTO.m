//
//  BLWeatherDTO.m
//  Supor
//
//  Created by 古北电子 on 2018/9/8.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLWeatherDTO.h"
#import <objc/runtime.h>

@implementation BLWeatherDTO

- (void)parseWithDict:(NSDictionary *)dict {
    [self setValuesForKeysWithDictionary:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
