//
//  BLGlobalDefine.h
//  Supor
//
//  Created by 古北电子 on 2018/8/13.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#ifndef BLGlobalDefine_h
#define BLGlobalDefine_h

#define DNAKIT_CORVODA_JS_FILE                  @"cordova.js"                   //cordova默认ios的js文件
#define DNAKIT_CORVODA_PLUGIN_JS_FILE           @"cordova_plugins.js"           //cordova plugin默认js文件
#define DNAKIT_DEFAULTH5PAGE_NAME               @"app.html"
#define BL_H5_NAVI                              @"h5Navi"//navi from js
#define kCordovaInfoNotification                @"kCordovaInfo"
#define BL_WebView_Property                     @"h5Property"
#define BL_StateColorChanged                    @"h5StateColorChanged"

//Broadlink网络请求相关域名
#define BLHttpRequest_Domain                      @"appservice.ibroadlink.com"

#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]
#define WeakSelf(type)  __weak typeof(type) weak##type = type;

#define BL_APP_BUNDLEID                         [[NSBundle mainBundle] bundleIdentifier]
//发布用dis,调试用sandbox
#if DEBUG
#define kAppIDExpand                            @"sandbox"
#else
#define kAppIDExpand                            @"dis"
#endif

#define kPushHttpUrlPrifix(subUrl)              [NSString stringWithFormat:@"https://%@%@/ec4/v1/pusher/%@", SDK_LID, BLHttpRequest_Domain,  subUrl] //push url 前缀("lid"+pushproxy.ibroadlink.com)
#define BL_URL_APPMANAGE(subUrl)                [NSString stringWithFormat:@"https://%@%@/ec4/v1/system/%@", SDK_LID, BLHttpRequest_Domain,  subUrl]//bizappmanage

#define BL_GET_PRICATEGORY_LIST                 @"getpricategorylist"
#define BL_GET_CATEGORY_LIST                    @"language/category/list"    //@"/ec4/v1/system/getcategorylist"
#define BL_GET_PRODUCT_LIST                     @"resource/productlist"     //@"/ec4/v1/system/getproductlist"
#define BL_GET_PRODUCT_DETAIL                   @"resource/product/info"     //@"/ec4/v1/system/getproductdetail"
#define BL_GET_PRODUCT_NAME_LIST                @"language/product/names"    //获取产品名称列表，用于多语言

#define BL_URL_Notification(subUrl)             [NSString stringWithFormat:@"https://%@%@/appfront/v1/%@",SDK_LID, BLHttpRequest_Domain, subUrl]
#define BL_URL_Notification_V2(subUrl)             [NSString stringWithFormat:@"https://%@%@/appfront/v2/%@",SDK_LID, BLHttpRequest_Domain, subUrl]
#define kPushRegister                           @"registerforremotenotify"
#define kPushSetPushType                        @"favorpushtype/manage"
#define kPushGetPushType                        @"favorpushtype/query"
#define kPushGetFollowList                      @"followdev/query"
#define kPushSetFollowList                      @"followdev/manage"

#define kRefesh                                 @"refreshNotification"
#define kWifiChanged                            @"wifiChanged"
#define kNotificationSwitchChanged              @"notificationSwitchChanged"
#define kUpdateHeaderIcon                       @"updateHeaderIcon"
#define kChangeBackWifi                         @"changeBackWifi"
#define kClearLinkageTemp                       @"clearLinkageTemp"

#define DeviceInfoDict                           [[NSBundle mainBundle] infoDictionary]

#define BL_SQL_Index                            -1

//如果未注释，则开启推送
#define BL_Notification_Open

/***************判断系统版本号***************/
//系统版本判断
#define BL_CURRENT_SYSTEM_VERSION               [NSString stringWithFormat:@"ios%@", [[UIDevice currentDevice] systemVersion]]
#define BL_IOS_SYSTEM_VERSION     [[[UIDevice currentDevice] systemVersion] floatValue]
#define BL_IOS11_OR_LATER        ( BL_IOS_SYSTEM_VERSION >=11.0 )
#define BL_IOS10_OR_LATER        ( BL_IOS_SYSTEM_VERSION >=10.0 )
#define BL_IOS9_OR_LATER         ( BL_IOS_SYSTEM_VERSION >=9.0 )
#define BL_IOS8_OR_LATER         ( BL_IOS_SYSTEM_VERSION >=8.0 )

/***************判断设备型号***************/
#define BL_isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define BL_isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define BL_isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define BL_isIPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define BL_isIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define BL_isIPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define BL_isIPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define BL_isFullScreen    (BL_isIPhoneX || BL_isIPhoneXR || BL_isIPhoneXSMax)

/***************控件等比缩放***************/

//以ipone6的高度为基准对控件高度进行缩放
#define BL_AutoDeviceHeightByiPhone6(kHeight)  (((BL_kDeviceWidth)/375.0)*kHeight)

//以ipone6的宽度为基准对控件宽度进行缩放
#define BL_AutoDeviceWidthByiPhone6(kWidth)  (((kWidth)/375.0)*BL_kDeviceWidth)

//以ipone5的宽度为基准对控件宽度进行缩放
#define BL_AutoDeviceWidthByiPhone5(kWidth)  (((kWidth)/320.0)*BL_kDeviceWidth)

//以ipone4的高度为基准对控件高度进行缩放
#define BL_AutoDeviceHeightByiPhone4(kHeight)  (((kHeight)/480.0)*BL_kDeviceHeight)

/************object或者字符串判空方法************/

//是否为空或是[NSNull null]
#define BL_NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]) && (![(_ref) isEqual:@"null"]) && (![(_ref) isEqual:@"(null)"]))
#define BL_IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqual:@"null"]) || ([(_ref) isEqual:@"(null)"]))
//字符串是否为空
#define BL_IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([@"" isEqualToString:(_ref)]))
//数组是否为空
#define BL_IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

/************颜色创建方法************/
//颜色创建
#undef  BL_RGBCOLOR
#define BL_RGBCOLOR(r,g,b)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  BL_RGBACOLOR
#define BL_RGBACOLOR(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define BL_HEX_RGB(V)              [UIColor bl_colorWithRGBHex:V]

#define BL_HEXSTRING_RGB(V)        [UIColor bl_colorWithHexString:V]

#define BL_SYSTEM_FONT(V)          [UIFont systemFontOfSize:V]

/***************屏幕宽高等定义***************/
#define BL_DeviceFrame                         [[UIScreen mainScreen] bounds]
#define BL_kDeviceWidth                        ([UIScreen mainScreen].bounds.size.width)
#define BL_kDeviceHeight                       ([UIScreen mainScreen].bounds.size.height)

//状态栏高度
#define BL_kStatusBarHeight                   (BL_kBottomSafeAreaHeight ? 44.0f : 20.0f)

//导航栏高度
#define BL_kUINavigationBarFrameHeight         44.0f

//tabbar高度
#define BL_kUITabBarHeight                     49.0f

//状态栏 + 导航栏 高度
#define BL_kNavAndStatusBarHight           (BL_kStatusBarHeight + BL_kUINavigationBarFrameHeight)

//页面除去状态栏的高度
#define BL_kViewHeightWithoutStatusBar      (BL_kDeviceHeight - BL_kStatusBarHeight)

//页面除去导航和状态栏的高度
#define BL_kViewHeightWithoutStatusAndNavi   (BL_kDeviceHeight - BL_kNavAndStatusBarHight)
//底部安全区高度
#define BL_kBottomSafeAreaHeight \
({\
CGFloat heigt = 0;\
UIWindow *window = [UIApplication sharedApplication].keyWindow;\
if (@available(iOS 11.0, *)) {\
heigt = window.safeAreaInsets.bottom;\
}\
(heigt);\
})\

/****************读取url前缀，用于拼接url********************/
#ifdef __cplusplus
extern "C"
{
#endif
    NSString *BLServerForHttps(NSString *lid, NSString *urlTailing);//https请求
    NSString *BLServerForHttp(NSString *lid, NSString *urlTailing);//http请求
    NSString *BLServerForUpdateFirmware(NSString *lid, NSString *deviceType);//固件升级
    NSString *BLServerForImage(NSString *lid, NSString *urlTailing);//图片地址
#ifdef __cplusplus
}
#endif

#endif /* BLGlobalDefine_h */
