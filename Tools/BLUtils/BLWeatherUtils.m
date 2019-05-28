//
//  BLWeatherUtils.m
//  Supor
//
//  Created by 古北电子 on 2018/9/7.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLWeatherUtils.h"
#import "BLHttpClient.h"
#import "JSONKit.h"

#define Weather_URL   @"https://nanjing.ibroadlink.com/weather/"

@interface BLWeatherUtils ()

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *license;

//从登录接口获得的参数
@property (nonatomic, copy) NSString *sessionid;

@end

@implementation BLMessageCenterWeatherInfo



@end

@implementation BLWeatherUtils

+ (BLWeatherUtils *)sharedUtils {
    static BLWeatherUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BLWeatherUtils alloc] init];
    });
    
    return sharedInstance;
}

- (void)setPhone:(NSString *)phone userid:(NSString *)userid password:(NSString *)password license:(NSString *)license success:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
    _phone = phone;
    _userid = userid;
    _password = password;
    _license = license;
    
    //登录
    [self weatherUserLoginSuccess:^(id responseObj) {
        success(nil);
    } failure:^(NSString *errorMsg, NSString *errorCode) {
        
    }];
}

- (void)weatherUserLoginSuccess:(void (^)(id))success failure:(void (^)(NSString *, NSString *))failure {
    NSDictionary *body = @{
                           @"phone" : BL_IsStrEmpty(self.phone) ? @"" : self.phone,
                           @"userid" : BL_IsStrEmpty(self.userid) ? @"" : self.userid,
                           @"password" : BL_IsStrEmpty(self.password) ? @"" : self.password,
                           @"license" : BL_IsStrEmpty(self.license) ? @"" : self.license,
                           @"lang" : @"chn",
                           @"zone" : @"+8:00",
                           };
    NSString *url = [NSString stringWithFormat:@"%@%@",Weather_URL, @"login"];
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST url:url params:body success:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            if ([[responseObj objectForKey:@"msg"] isEqualToString:@"ok"]) {
                self.sessionid = [responseObj objectForKey:@"sessionid"];
                success(nil);
            }
        }
    } failure:^(NSString *errorMsg, NSString *errorCode) {
        
    }];
}

- (void)queryWeatherWithLocation:(NSString *)location success:(void (^)(BLWeatherDTO *, NSString *))success failure:(void (^)(NSString *, NSString *))failure {
    NSDictionary *body = @{
                           @"location" : BL_IsStrEmpty(location) ? @"" : location,
                           };
    NSDictionary *header = @{
                             @"sessionid" : BL_IsStrEmpty(self.sessionid) ? @"" : self.sessionid
                             };
    NSString *url = [NSString stringWithFormat:@"%@%@",Weather_URL, @"v1/query/now"];
    [BLHttpClient bl_httpRequestMethod:BLHttpRequest_POST url:url params:body header:header success:^(id responseObj) {
        if ([[responseObj objectForKey:@"msg"] isEqualToString:@"ok"]) {
            NSArray *rowsNowArray = [responseObj objectForKey:@"rowsNow"];
            NSDictionary *weatherDict = rowsNowArray.firstObject;
            BLWeatherDTO *dto = [[BLWeatherDTO alloc] init];
            [dto parseWithDict:weatherDict];
            success(dto, [weatherDict JSONString]);
        }else {
            success(nil, nil);
        }
    } failure:^(NSString *errorMsg, NSString *errorCode) {
        NSLog(@"请求天气数据失败");
    }];
}

@end
