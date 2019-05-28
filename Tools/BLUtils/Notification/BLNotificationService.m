//
//  BLNotificationService.m
//  Supor
//
//  Created by 古北电子 on 2018/8/22.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLNotificationService.h"
#import "BLHttpClient.h"
#import "BLUserCenter.h"
#import "JSONKit.h"
#import <GTMBase64.h>
#import "NSString+BLCategory.h"
#import "BLNotificationTempInfo.h"
#import "BLNotificationLinkageInfo.h"
#import "BLDeviceLinkageInfoManager.h"

@interface BLNotificationService ()

@property (nonatomic, assign) BOOL linkageSuccess;

@end

@implementation BLNotificationService

+ (BLNotificationService *)sharedInstance {
    static BLNotificationService *notificationService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!notificationService) {
            notificationService = [[BLNotificationService alloc] init];
        }
    });
    
    return notificationService;
}

//请求头
- (NSDictionary *)getNotificateHeader {
    NSDictionary *identityDict = @{
                                   @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                                   @"familyid" : @"",
                                   @"loginsession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                                   };
    NSString *identityString = [self getBase64DataString:identityDict];
    
    NSDictionary *headDic = @{
                              @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                              @"loginsession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                              @"identity" : BL_IsStrEmpty(identityString) ? @"" : identityString,
                              @"language" : [BLCommonUtils preferedLanguage],
                              @"system" : @"ios",
                              @"appid" : [NSString stringWithFormat:@"%@",BL_APP_BUNDLEID]
                              };
    return headDic;
}

- (NSString *)getBase64DataString:(NSDictionary *)dict {
    NSData *data = [dict JSONData];
    NSString *base64String = [GTMBase64 stringByEncodingData:data];

    return base64String;
}

#pragma mark - deviceToken 上传
/**
 上报token给云端，注册推送服务。
 userid 用户的id
 touser deviceToken
 tousertype 推送的类型，可选四种类型"app"、"短信"、"微信"、"邮件"。
 */
- (void)registerDeviceToken {
    NSDictionary *bodyDic = @{
                              @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                              @"touser" : _deviceToken ? _deviceToken:@"",
                              @"tousertype" : @"app"
                              };
    NSArray *manageInfoArray = [NSArray arrayWithObject:bodyDic];
    
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                   url:BL_URL_Notification(@"pusher/registerforremotenotify")
                                params:manageInfoArray
                                header:[self getNotificateHeader]
                               success:^(id responseObj) {
                                   if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:0]) {
                                       //判断推送软件本身在设置中的推送功能是否打开
                                       if ([BLCommonUtils isUserNotificationEnable]) {
                                           //用户设置推送方式
                                           [self setAllPushState:[[BLUserCenter sharedInstance].openNotification isEqualToString:@"1"] success:^(id responseObj) {

                                           } failure:^(NSString *errorMsg, NSString *errorCode) {

                                           }];
                                       }else {
                                           //用户设置推送方式
                                           [self setAllPushState:NO success:^(id responseObj) {
                                               
                                           } failure:^(NSString *errorMsg, NSString *errorCode) {
                                               
                                           }];
                                       }
                                   }
                               } failure:^(NSString *errorMsg, NSString *errorCode) {
                                   
                               }];
}

/**
 用户设置推送方式
 
 state 推送状态，BOOL型
 managetypeinfo 推送类型的一个列表，可以设置多个推送类型（最多四个）
 action 推送开关
 tokentype 字典类型用于保存deviceToken和推送类型的
 touser deviceToken
 tousertype 推送的类型，可选四种类型"app"、"短信"、"微信"、"邮件"。
 */
- (void)setAllPushState:(BOOL)state
                success:(void (^)(id responseObj))success
                failure:(void (^)(NSString *errorMsg, NSString *errorCode))failure; {
    
    NSDictionary *tokentypeDic = @{
                                   @"touser" : _deviceToken ? _deviceToken:@"",
                                   @"tousertype" : @"app"
                                   };
    NSDictionary *infoDic = @{
                              @"action" : state ? @"favor":@"quitfavor",//"favor":设备开启推送标识，"quitfavor":设备关闭推送标识
                              @"tokentype" : tokentypeDic
                              };
    NSArray *manageInfoArray = [NSArray arrayWithObject:infoDic];
    NSDictionary *bodyDic = @{
                              @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                              @"managetypeinfo" : manageInfoArray,
                              @"language" : [BLCommonUtils preferedLanguage]
                              };
    
    NSDictionary *header = @{
                             @"ReqUserId" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                             @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                             @"ReqUserSession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                             @"language" : [BLCommonUtils preferedLanguage]
                             };
    
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                   url:kPushHttpUrlPrifix(kPushSetPushType)
                                params:bodyDic
                                header:header
                               success:^(id responseObj) {
                                   if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:0]) {
                                       success(nil);
                                   }else if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:-25010]) {
                                       success(nil);
                                   }else {
                                       failure([responseObj objectForKey:@"msg"], nil);
                                   }
                               } failure:^(NSString *errorMsg, NSString *errorCode) {
                                   failure(errorMsg, errorCode);
                               }];
}

#pragma mark - 模板查询
- (void)queryModuleCategoryPid:(NSString *)pid success:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
//    BLProfileStringResult *result = [[BLLet sharedLet].controller queryProfileByPid:pid];
//    NSDictionary *moduleProfileDict;
//    if (!result.succeed) {
//        failure(result.msg,nil);
//    } else {
//        moduleProfileDict = [[result getProfile] objectFromJSONString];
//    }
//    NSArray *srvs = [moduleProfileDict valueForKey:@"srvs"];
//    NSArray *categoryArray;
//    if (srvs) {
//        NSArray *tempArray = [[srvs firstObject] componentsSeparatedByString:@"."];
//        categoryArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@.%@", [tempArray firstObject], [tempArray lastObject]], nil];
//    }
    NSDictionary *bodyDic = @{
//                              @"category" : BL_IsArrEmpty(categoryArray) ? @[] : categoryArray,
                              @"category" : @[],
                              @"companyid" : SDK_LID,
                              @"pagestart": [NSNumber numberWithInteger:1],
                              @"templatetype": @"",
                              @"pagesize": [NSNumber numberWithInteger:100]
                              };
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                   url:BL_URL_Notification(@"tempalte/query")
                                params:bodyDic
                                header:[self getNotificateHeader]
                               success:^(id responseObj) {
//                                   NSLog(@"response is %@",responseObj);
                                   if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:0]) {
                                       //解析模板信息，用于后面的模板实例化
                                       BLNotificationTempInfo *tempInfo = [BLNotificationTempInfo sharedTempInfo];
                                       [tempInfo parseTempInfoDict:responseObj];
                                       success(nil);
                                   }
                               } failure:^(NSString *errorMsg, NSString *errorCode) {
                                   failure(errorMsg,errorCode);
                               }];
}

#pragma mark - 联动增加（模板实例化）
- (void)linkageAdd:(NSMutableArray<BLCustomDeviceInfo *> *)cdeviceInfoArray linkAgeInfoArray:(NSMutableArray<LinkAgeInfo *> *)linkAgeInfoArray success:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
    
    if (self.linkageSuccess) {//如果该标识为YES，则不得继续实例化，得等待实例化线程全部完成后再执行新的实例化操作
        return;
    }
    
    BLNotificationTempInfo *notiTempInfo = [BLNotificationTempInfo sharedTempInfo];
    BLFamilyInfo *currentFamilyInfo = [BLFamilyInfoManager sharedInstance].familyInfo;
    BLTempInfo *tempInfo = notiTempInfo.tempInfoArray.firstObject;
    //用模板id来判断是否有模板信息，如果没有，则无需继续实例化
    if (BL_IsStrEmpty(tempInfo.templateid)) {
//        NSLog(@"未获取到模板信息");
        return;
    }
    
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    self.linkageSuccess = YES;
//    dispatch_group_async(group, queue, ^{
        for (BLTempInfo *newTempInfo in notiTempInfo.tempInfoArray) {
            for (BLCustomDeviceInfo *cDeviceInfo in cdeviceInfoArray) {
                //如果不是自己家庭的设备，则不需要实例化模板
                if ([currentFamilyInfo.familyName isEqualToString:cDeviceInfo.familyInfo.familyName]) {
                    //判断是否已经实例化模板信息，如果已经实例化，则不去实例化
                    BOOL hasAdd = NO;
                    //遍历自有家庭查询到的模板实例化信息来判断自己当前拥有的设备是否需要去实例化n，并且已经实例化了iOS的模板，安卓的会把iOS的一起实例化，但是并没有放入设备信息
                    for (LinkAgeInfo *linkAgeInfo in linkAgeInfoArray) {
                        if ([linkAgeInfo.did isEqualToString:cDeviceInfo.deviceInfo.did] &&
                            [linkAgeInfo.templateId isEqualToString:newTempInfo.templateid] && linkAgeInfo.iOSFlag) {
                            hasAdd = YES;
                            break;
                        }
                    }
                    if (!hasAdd) {//如果没有实例化过并且是自己拥有的设备，不是分享过来的，则需要进行实例化
                        if ([[BLDeviceLinkageInfoManager sharedInstance] deviceNeedLinkage:cDeviceInfo.deviceInfo.did tempId:newTempInfo.templateid]) {
                            continue;
                        }else {
                            [[BLDeviceLinkageInfoManager sharedInstance] setDeviceInfo:cDeviceInfo.deviceInfo.did tempId:newTempInfo.templateid linking:YES];
                        }
                        
                        NSDictionary *identityDict = @{
                                                       @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                                                       @"familyid" : cDeviceInfo.familyInfo.familyId,
                                                       @"loginsession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                                                       };
                        NSString *identityString = [self getBase64DataString:identityDict];
                        
                        NSDictionary *headerDict = @{
                                                     @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                                                     @"loginsession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                                                     @"identity" : identityString,
                                                     @"messageId" : [BLCommonUtils createUUID],//设备生成的uuid，软件生命周期内只生成唯一一个
                                                     @"licenseid" : SDK_LID,
                                                     };
                        NSMutableArray *devcontentArray = [[NSMutableArray alloc] init];
                        
                        //往externDict中添加did字段及conten内容
                        NSDictionary *externDict = [notiTempInfo setExternDictDeviceInfo:cDeviceInfo externDict:newTempInfo.externDict];
                        //往characteristicinfo中添加did字段
                        NSDictionary *characteristicinfoDict = [notiTempInfo setCharacteristicinfoIdev_did:cDeviceInfo.deviceInfo.did eventsArray:newTempInfo.eventsArray conditionsinfo:newTempInfo.conditionsinfo];
                        
                        NSDictionary *bodyDict = @{
                                                   @"familyid" : cDeviceInfo.familyInfo.familyId,
                                                   @"ruletype" : @1,// 固定为1
                                                   @"ruleid" : @"",//填空即可
                                                   @"rulename" : @"",
                                                   @"enable" : @1, //1使能
                                                   @"characteristicinfo" : [characteristicinfoDict JSONString], //联动信息，json格式，app透传
                                                   @"locationinfo": @"",//地址信息,暂时填空
                                                   @"moduleid" : BL_IsStrEmpty(cDeviceInfo.moduleInfo.moduleId) ? @"" : @[cDeviceInfo.moduleInfo.moduleId], //场景id，如无场景联动，则填空列表
                                                   @"modulecontent" : @"", //json格式场景内容
                                                   @"devcontent": devcontentArray,
                                                   @"linkagedevices" : @{
                                                           @"name" : @"",//场景名称
                                                           @"extern" : [self getBase64DataString:externDict],
                                                           @"linkagetype" : @"notify"
                                                           },
                                                   @"source" : [NSString stringWithFormat:@"notify_%@",newTempInfo.templateid] //格式为"notify_<templateid>",可通过该字段确定模板是否已实例化
                                                   };
                        dispatch_group_async(group, queue, ^{
                            //发送请求，将模板实例化信息发送到云端
                            [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                                           url:BL_URL_Notification_V2(@"linkage/add")
                                                        params:bodyDict
                                                        header:headerDict
                                                       success:^(id responseObj) {
                                                           [[BLDeviceLinkageInfoManager sharedInstance] setDeviceInfo:cDeviceInfo.deviceInfo.did tempId:newTempInfo.templateid linking:NO];
                                                           //                                                   NSLog(@"response is %@",responseObj);
                                                       } failure:^(NSString *errorMsg, NSString *errorCode) {
                                                           [[BLDeviceLinkageInfoManager sharedInstance] setDeviceInfo:cDeviceInfo.deviceInfo.did tempId:newTempInfo.templateid linking:NO];
                                                           failure(nil, nil);
                                                       }];
                        });
                    }
                }
            }
        }
    dispatch_group_leave(group);
//    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        self.linkageSuccess = NO;
        success([NSNumber numberWithBool:YES]);
        NSLog(@"---全部结束。。。");
    });
}

- (NSDictionary *)linkageHeaderDict {
    NSDictionary *identityDict = @{
                                   @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                                   @"familyid" : BL_IsStrEmpty([BLFamilyInfoManager sharedInstance].familyInfo.familyId) ? @"" : [BLFamilyInfoManager sharedInstance].familyInfo.familyId,
                                   @"loginsession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                                   };
    NSString *identityString = [self getBase64DataString:identityDict];

    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                        @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                                                                                        @"loginsession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                                                                                        @"identity" : identityString,
                                                                                        @"messageId" : [BLCommonUtils createUUID],
                                                                                        @"licenseid" : SDK_LID,
                                                                                        }];

    return headerDict;
}

#pragma mark - 获取已经实例化的模板信息
- (void)linkageQueryIOS:(BOOL)isIOS success:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
    if (BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) || BL_IsStrEmpty([BLUserCenter sharedInstance].userId)) {
        return;
    }
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                   url:BL_URL_Notification_V2(@"linkage/query")
                                params:nil
                                header:[self linkageHeaderDict]
                               success:^(id responseObj) {
//                                   NSLog(@"response is %@",responseObj);
                                   if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:0]) {
                                       //解析当前家庭已经实例化的设备的推送模板，用于添加实例化模板时判断
                                       BLNotificationLinkageInfo *notiLinkAgeInfo = [[BLNotificationLinkageInfo alloc] init];
                                       [notiLinkAgeInfo parseWithDict:responseObj isIOS:isIOS];
                                       success(notiLinkAgeInfo);
                                   }else {
                                       failure(nil, nil);
                                   }
                               } failure:^(NSString *errorMsg, NSString *errorCode) {
                                   failure(nil, nil);
                               }];
}

#pragma mark - 用户退出登录时调用
- (void)userSignOutSuccess:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
    if (BL_IsStrEmpty(_deviceToken)) {
        success(nil);
        return;
    }
    NSDictionary *body = @{
                           @"touser" : _deviceToken,
                           @"accountlabel" : @1
                           };
    
    NSDictionary *header = @{
                             @"ReqUserId" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                             @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                             @"loginsession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                             @"ReqUserSession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                             @"language" : [BLCommonUtils preferedLanguage]
                             };
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                   url:kPushHttpUrlPrifix(@"signoutaccount")
                                params:body
                                header:header
                               success:^(id responseObj) {
                                   if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:0]) {
                                       success(nil);
                                   }else if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:-25010]) {
                                       success(nil);
                                   }else {
                                       failure(NSLocalizedString(@"退出登录失败", nil), nil);
                                   }
                               } failure:^(NSString *errorMsg, NSString *errorCode) {
                                   failure(errorMsg, errorCode);
                               }];
}

- (void)queryNotificationHistory:(BOOL)queryFlag success:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
    NSDictionary *body = @{
                           @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                           @"count" : @20,
                           @"queryedflagenable" : [NSNumber numberWithBool:queryFlag]
                           };
    
    NSString *url = BL_URL_Notification(@"notifypush/query");;
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                   url:url
                                params:body
                                header:[self getNotificateHeader]
                               success:^(id responseObj) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:0]) {
                                           success(responseObj);
                                       }else {
                                           failure([[responseObj objectForKey:@"status"] stringValue], [responseObj objectForKey:@"msg"]);
                                       }
                                   });
                               } failure:^(NSString *errorMsg, NSString *errorCode) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       failure(nil, nil);
                                   });
                               }];
}

- (void)deleteLinkage:(NSMutableArray<LinkAgeInfo *> *)linkAgeInfoArray success:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
    for (LinkAgeInfo *linkInfo in linkAgeInfoArray) {
        NSDictionary *body = @{
                               @"ruleid" : BL_IsStrEmpty(linkInfo.ruleid) ? @"" : linkInfo.ruleid
                                   };
        NSString *url = BL_URL_Notification_V2(@"linkage/delete");
        
        [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                       url:url
                                    params:body
                                    header:[self linkageHeaderDict]
                                   success:^(id responseObj) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if ([responseObj objectForKey:@"status"] == [NSNumber numberWithInteger:0]) {
                                               success(responseObj);
                                           }else {
                                               failure([[responseObj objectForKey:@"status"] stringValue], [responseObj objectForKey:@"msg"]);
                                           }
                                       });
                                   } failure:^(NSString *errorMsg, NSString *errorCode) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           failure(nil, nil);
                                       });
                                   }];
    }
}

- (void)clearExcessLinkageInfo:(NSMutableArray<LinkAgeInfo *> *)linkAgeInfoArray {
    if (BL_IsArrEmpty(linkAgeInfoArray)) {
        return;
    }
    
    NSMutableArray<LinkAgeInfo *> *needClearArray = [[NSMutableArray alloc] init];
    //遍历出所有模板中重复的且时间较早的模板进行清除,如果不进行转换，数组元素个数为0时，数组count减1会得到一个随机的整数
    int arrayCount = (int)linkAgeInfoArray.count;
    for (int i = 0; i < arrayCount-1; i++) {
        for (int j = i+1; j < arrayCount; j++) {
            LinkAgeInfo *infoI;
            LinkAgeInfo *infoJ;
            if (linkAgeInfoArray.count > i) {
                infoI = [linkAgeInfoArray objectAtIndex:i];
            }
            if (linkAgeInfoArray.count > j) {
                infoJ = [linkAgeInfoArray objectAtIndex:j];
            }
            if ([infoI.templateId isEqualToString:infoJ.templateId] && [infoI.did isEqualToString:infoJ.did]) {
                if ([infoJ.createTime longLongValue] > [infoI.createTime longLongValue]) {
                    //删除较早创建的模板实例化
                    [needClearArray addObject:infoI];
                }else {
                    [needClearArray addObject:infoJ];
                }
            }
        }
    }
    
    if (BL_IsArrEmpty(needClearArray)) {
        return;
    }
    [[BLNotificationService sharedInstance] deleteLinkage:needClearArray success:^(id responseObj) {
        
    } failure:^(NSString *errorCode, NSString *errorMsg) {
        
    }];
}

- (void)updateBadge:(NSInteger)badge success:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
    NSDictionary *header = @{
                             @"ReqUserId" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                             @"userid" : BL_IsStrEmpty([BLUserCenter sharedInstance].userId) ? @"" : [BLUserCenter sharedInstance].userId,
                             @"loginsession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                             @"ReqUserSession" : BL_IsStrEmpty([BLUserCenter sharedInstance].loginSession) ? @"" : [BLUserCenter sharedInstance].loginSession,
                             @"language" : [BLCommonUtils preferedLanguage]
                             };
    NSDictionary *body = @{
                           @"touser" : _deviceToken ? _deviceToken:@"",
                           @"badge" : [NSNumber numberWithInteger:badge]
                           };
    NSString *url = kPushHttpUrlPrifix(@"badge/update");
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST
                                   url:url
                                params:body
                                header:header
                               success:^(id responseObj) {
                                   
                               } failure:^(NSString *errorMsg, NSString *errorCode) {
                                   
                               }];
}

@end
