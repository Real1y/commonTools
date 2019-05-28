//
//  BLNotificationTempInfo.m
//  Supor
//
//  Created by 古北电子 on 2018/9/6.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLNotificationTempInfo.h"
#import "JSONKit.h"
#import <GTMBase64.h>

static BLNotificationTempInfo *sharedInstance;

static dispatch_once_t onceToken;

@implementation BLTempInfo

- (void)parseTempInfoDict:(NSDictionary *)dict {
    NSArray *action = [dict objectForKey:@"action"];
    NSMutableArray *iosActionArray = [[NSMutableArray alloc] init];
    for (NSDictionary *actionDict in action) {
        NSDictionary *iosAction = @{
                                    @"ios" : [actionDict objectForKey:@"ios"],
                                    @"name" : [actionDict objectForKey:@"name"],
                                    @"language" : [actionDict objectForKey:@"language"],
                                    @"status" : [actionDict objectForKey:@"status"],
                                    };
        [iosActionArray addObject:iosAction];
    }
    [self.externDict setObject:iosActionArray forKey:@"action"];
    self.conditionsinfo = [dict objectForKey:@"conditionsinfo"];
    self.eventsArray = [dict objectForKey:@"events"];
    self.characteristicinfo = @{
                                @"conditionsinfo" : self.conditionsinfo,
                                @"events" : self.eventsArray
                                };
    self.templateid = [dict objectForKey:@"templateid"];
    NSArray *templatenameArr = [dict objectForKey:@"templatename"];
    self.templatename = [templatenameArr.firstObject objectForKey:@"name"];
}

- (NSMutableDictionary *)externDict {
    if (_externDict == nil) {
        _externDict = [[NSMutableDictionary alloc] init];
    }
    
    return _externDict;
}

@end

@implementation BLNotificationTempInfo

+ (BLNotificationTempInfo *)sharedTempInfo {
    dispatch_once(&onceToken, ^{
        sharedInstance = [BLNotificationTempInfo new];
    });
    
    return sharedInstance;
}

- (void)clearNotificationTempInfo {
    sharedInstance = nil;
    onceToken = 0;
}

- (void)parseTempInfoDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSArray *templatesArray = [dict objectForKey:@"templates"];
        self.tempInfoArray = nil;
        for (NSDictionary *template in templatesArray) {
            BLTempInfo *tempInfo = [[BLTempInfo alloc] init];
            [tempInfo parseTempInfoDict:template];
            [self.tempInfoArray addObject:tempInfo];
        }
    }
}

- (NSMutableArray<BLTempInfo *> *)tempInfoArray {
    if (_tempInfoArray == nil) {
        _tempInfoArray = [[NSMutableArray alloc] init];
    }
    
    return _tempInfoArray;
}

- (NSDictionary *)setCharacteristicinfoIdev_did:(NSString *)did eventsArray:(NSMutableArray *)eventsArray conditionsinfo:(NSDictionary *)conditionsinfo {
    NSMutableDictionary *characteristicinfoDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *events = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in eventsArray) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [tempDict setObject:did forKey:@"idev_did"];
        [events addObject:tempDict];
    }
    NSMutableArray *property = [[NSMutableArray alloc] init];
    NSArray *propertyArray = [conditionsinfo objectForKey:@"property"];
    if (!BL_IsArrEmpty(propertyArray)) {
        for (NSDictionary *dict in propertyArray) {
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [tempDict setObject:did forKey:@"idev_did"];
            [property addObject:tempDict];
        }
    }
    NSMutableDictionary *mConditionInfo = [[NSMutableDictionary alloc] initWithDictionary:conditionsinfo];
    [mConditionInfo setObject:BL_IsArrEmpty(property) ? @[] : property forKey:@"property"];
    
    [characteristicinfoDict setObject:events forKey:@"events"];
    [characteristicinfoDict setObject:BL_IsNilOrNull(mConditionInfo) ? @"" : mConditionInfo forKey:@"conditionsinfo"];
    return characteristicinfoDict;
}

- (NSDictionary *)setExternDictDeviceInfo:(BLCustomDeviceInfo *)cDeviceInfo externDict:(NSMutableDictionary *)externDict {
    NSMutableDictionary *extDict= [[NSMutableDictionary alloc] init];
    NSMutableArray *tempActionArray = [[NSMutableArray alloc] init];
    NSMutableArray *iosActionArray = [externDict objectForKey:@"action"];
    for (NSDictionary *iosDict in iosActionArray) {
        NSMutableDictionary *tempIosDict = [[NSMutableDictionary alloc] initWithDictionary:[iosDict objectForKey:@"ios"]];
        NSDictionary *contentDict = @{
                                      @"devname" : cDeviceInfo.moduleInfo.name?:@"",
                                      };
        NSString *content = [self getBase64DataString:contentDict];
        [tempIosDict setObject:cDeviceInfo.deviceInfo.did forKey:@"did"];
        [tempIosDict setObject:content forKey:@"content"];

        NSDictionary *tempDict = @{
                                   @"ios" : tempIosDict,
                                   @"name" : [iosDict objectForKey:@"name"],
                                   @"language" : [iosDict objectForKey:@"language"],
                                   @"status" : [iosDict objectForKey:@"status"],
                                   };
        [tempActionArray addObject:tempDict];
    }
    [extDict setObject:tempActionArray forKey:@"action"];
    
    return extDict;
}

- (NSString *)getBase64DataString:(NSDictionary *)dict {
    NSData *data = [dict JSONData];
    NSString *base64String = [GTMBase64 stringByEncodingData:data];
    
    return base64String;
}

@end
