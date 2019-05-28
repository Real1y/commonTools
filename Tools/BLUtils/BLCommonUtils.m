//
//  BLCommonUtils.m
//  Supor
//
//  Created by 古北电子 on 2018/8/13.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLCommonUtils.h"
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>

static NSString *BL_ServerForHttps = BLHttpRequest_Domain;
static NSString *BL_ServerForUpdateFirmware = @"/getfwversion?devicetype=";
static NSString *BL_ServerForImage = @"/ec4/v1/system/configfile";

@interface BLCommonUtils ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locManager;

@end

@implementation BLCommonUtils

+ (instancetype)sharedInstance {
    static BLCommonUtils *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[BLCommonUtils alloc] init];
    });
    
    return instance;
}

- (void)initLocation {
    // 初始化定位管理器
    self.locManager = [[CLLocationManager alloc] init];
    // 设置代理
    self.locManager.delegate = self;
    // 设置定位精确度到米
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    self.locManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [self.locManager requestWhenInUseAuthorization];
    [self.locManager startUpdatingLocation];
    [self.locManager startMonitoringSignificantLocationChanges];
}

#pragma mark -
#pragma mark Location manager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D loc = [newLocation coordinate];
    self.latitude =loc.latitude;//get latitude
    self.longitude =loc.longitude;//get longitude
    NSLog(@"获取地理位置……");
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en",nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            self.cityEn = placemark.addressDictionary[@"City"];
            self.countryEn = placemark.addressDictionary[@"CountryCode"];
        } else if (error == nil && [array count] == 0) {
        } else if (error != nil) {
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locManager stopUpdatingLocation];
    self.locManager = nil;
}

- (void)setServerEnv:(BLServerEnv)serverEnv {
    _serverEnv = serverEnv;
    
    switch (serverEnv) {
        case BLServerEnvProductList:
            BL_ServerForHttps = BLHttpRequest_Domain;
            break;
        case BLServerEnvDetail:
            BL_ServerForHttps = BLHttpRequest_Domain;
            break;
            
        default:
            break;
    }
}

NSString *BLServerForHttps(NSString *lid, NSString *urlTailing) {
    NSString *url = [NSString stringWithFormat:@"https://%@%@%@", lid, BLHttpRequest_Domain, urlTailing];
    
    return url;
}

NSString *BLServerForHttp(NSString *lid, NSString *urlTailing) {
    NSString *url = [NSString stringWithFormat:@"http://%@%@%@", lid, BLHttpRequest_Domain, urlTailing];
    
    return url;
}

NSString *BLServerForUpdateFirmware(NSString *lid, NSString *deviceType) {
    NSString *url = [NSString stringWithFormat:@"https://%@%@%@%@", lid, BLHttpRequest_Domain, BL_ServerForUpdateFirmware, deviceType];
    return url;
}

NSString *BLServerForImage(NSString *lid, NSString *urlTailing) {
    NSString *url = [NSString stringWithFormat:@"https://%@%@%@%@", lid, BLHttpRequest_Domain, BL_ServerForImage, urlTailing];
    return url;
}

//获取当前WiFi的SSID
+ (NSString *)getCurrentWiFiSSID {
    NSArray* ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    NSString *ssid = nil;
    for (NSString* ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info
            && [info count])
        {
            ssid = info[@"SSID"];
            break;
        }
    }
    return ssid;
}

+ (NSString *)iphoneType {//手机型号
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString *)preferedLanguage {
    static NSString *preferredLang = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        preferredLang = [currentLanguage lowercaseString];
        if ([preferredLang containsString:@"hans"]) {
            preferredLang = @"zh-cn";
        } else if ([preferredLang containsString:@"hant"]) {
            preferredLang = @"zh-tw";
        } else if ([preferredLang hasPrefix:@"ja"]) {
            preferredLang = @"jp";
        }
    });
    return preferredLang;
}

+ (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    
    return isEnable;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}

+ (NSString *)createUUID {
    if (!BL_IsStrEmpty([BLCommonUtils sharedInstance].uuid)) {
        return [BLCommonUtils sharedInstance].uuid;
    }
    NSString *uuid = [NSUUID UUID].UUIDString;
    [BLCommonUtils sharedInstance].uuid = uuid;
    
    return uuid;
}

+ (void)wirteToFile:(NSArray *)array {
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_notify.plist",[BLUserCenter sharedInstance].userId]];
    
    NSArray *fileArray = [self readFromFile];
    NSMutableArray *mFileArray = [[NSMutableArray alloc] initWithArray:fileArray];
    [mFileArray insertObject:array.firstObject atIndex:0];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (mFileArray.count > 20) {
        for (int i = 0; i < 20; i++) {
            [resultArray addObject:[mFileArray objectAtIndex:i]];
        }
        
        [resultArray writeToFile:path atomically:YES];
    }else {
        [mFileArray writeToFile:path atomically:YES];
    }
}

+ (NSArray *)readFromFile {
    //路径
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *arrayPath =[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_notify.plist",[BLUserCenter sharedInstance].userId]];
    //读取
    NSArray *array = [NSArray arrayWithContentsOfFile:arrayPath];
    NSLog(@"array--%@",array);
    return array;
}

//字符串转时间
+ (NSDate *)nsstringConversionNSDate:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

//时间转时间戳
+ (NSString *)dateConversionTimeStamp:(NSDate *)date {
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    return timeSp;
}

+ (NSString *)nsstringConversionTimeStamp:(NSString *)dateStr {
    if (BL_IsStrEmpty(dateStr)) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datestr timeIntervalSince1970]*1000];
    
    return timeSp;
}

//时间戳转字符串
+ (NSString *)timeStampConversionNSString:(NSString *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

@end
