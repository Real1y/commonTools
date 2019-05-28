//
//  BLNotificationLinkageInfo.m
//  Supor
//
//  Created by 古北电子 on 2018/9/13.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLNotificationLinkageInfo.h"
#import "JSONKit.h"
#import <GTMBase64.h>

@implementation LinkAgeInfo

- (void)parseWithDict:(NSDictionary *)dict {
    NSString *characteristicinfo = [dict objectForKey:@"characteristicinfo"];
    NSDictionary *characteristicDict = [characteristicinfo objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSArray *events = [characteristicDict objectForKey:@"events"];
    for (NSDictionary *deviceDict in events) {
        NSString *did = [deviceDict objectForKey:@"idev_did"];
        if (!BL_IsStrEmpty(did)) {
            self.did = did;
            break;
        }
    }
    NSString *source = [dict objectForKey:@"source"];
    NSArray *sourceArray = [source componentsSeparatedByString:@"_"];
    self.templateId = sourceArray.lastObject;
    self.familyId = [dict objectForKey:@"familyid"];
    self.ruleid = [dict objectForKey:@"ruleid"];
    self.createTime = [BLCommonUtils nsstringConversionTimeStamp:[dict objectForKey:@"createtime"]];
    
    NSDictionary *linkagedevices = [dict objectForKey:@"linkagedevices"];
    NSString *externString = [linkagedevices objectForKey:@"extern"];
    NSString *decoded = [[NSString alloc] initWithData:[GTMBase64 decodeString:externString] encoding:NSUTF8StringEncoding];
    NSDictionary *externDict = (NSDictionary *)[decoded objectFromJSONString];
    NSArray *actionArray = [externDict objectForKey:@"action"];
    if (!BL_IsNilOrNull(actionArray)) {
        NSDictionary *actionDict = actionArray.firstObject;
        NSDictionary *iosDict = [actionDict objectForKey:@"ios"];
        if (!BL_IsNilOrNull(iosDict)) {
            NSString *iosDid = [iosDict objectForKey:@"did"];
            self.iOSFlag = !BL_IsStrEmpty(iosDid);
        }
    }
}

@end

@implementation BLNotificationLinkageInfo

- (void)parseWithDict:(NSDictionary *)dict isIOS:(BOOL)isIOS {
    NSArray *linkAges = [dict objectForKey:@"linkages"];
    if (BL_IsNilOrNull(linkAges)) {
        return;
    }
    for (NSDictionary *linkAgeDict in linkAges) {
        LinkAgeInfo *info = [[LinkAgeInfo alloc] init];
        [info parseWithDict:linkAgeDict];
        if (isIOS) {
            //如果有一个为空或者不是iOS实例化的模板，则不添加到数组中
            if (BL_IsStrEmpty(info.did) || BL_IsStrEmpty(info.familyId) || BL_IsStrEmpty(info.templateId) || !info.iOSFlag) {
                continue;
            }
            
        }else {
            //如果不是传的iOS，则获取所有实例化模板
            if (BL_IsStrEmpty(info.did) || BL_IsStrEmpty(info.familyId) || BL_IsStrEmpty(info.templateId)) {
                continue;
            }
        }

        [self.linkAgeInfoArray addObject:info];
    }
}

- (NSMutableArray<LinkAgeInfo *> *)linkAgeInfoArray {
    if (_linkAgeInfoArray == nil) {
        _linkAgeInfoArray = [[NSMutableArray alloc] init];
    }
    
    return _linkAgeInfoArray;
}

@end
