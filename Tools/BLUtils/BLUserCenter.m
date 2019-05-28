//
//  BLUserCenter.m
//  Supor
//
//  Created by 古北电子 on 2018/8/14.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLUserCenter.h"
#import "NSString+BLCategory.h"

#define NICKNAME @"nickName"
#define USERID @"userId"
#define PHONE @"phone"
#define ICONPATH @"iconPath"
#define LOGINSESSION @"loginSession"
#define FAMILYNAME @"familyName"
#define FAMILYID @"familyId"
#define ACCOUNT @"account"
#define PASSWORD @"password"
#define REMEMBER_PWD @"rememberPwd"
#define OPENNOTIFICATION @"openNotification"

static BLUserCenter *sharedInstance = nil;
static dispatch_once_t onceToken;

@implementation BLUserCenter

+ (BLUserCenter *)sharedInstance {
    dispatch_once(&onceToken, ^{
        sharedInstance = [BLUserCenter new];
        [sharedInstance getUserInfo];
    });
    
    return sharedInstance;
}

- (void)clearUserCenter {
    sharedInstance = nil;
    onceToken = 0;
}

- (void)setLoginResultInfo:(BLLoginResult *)loginResult {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _nickName = loginResult.nickname;
    [defaults setObject:loginResult.nickname forKey:NICKNAME];
    _userId = loginResult.userid;
    [defaults setObject:loginResult.userid forKey:USERID];
    _encriptUserId = [NSString encrypt:_userId key:Encrypt_Key];
    _phone = loginResult.phone;
    [defaults setObject:loginResult.phone forKey:PHONE];
    _iconPath = loginResult.iconpath;
    [defaults setObject:loginResult.iconpath forKey:[NSString stringWithFormat:@"%@_%@",loginResult.userid,ICONPATH]];
    _loginSession = loginResult.loginsession;
    [defaults setObject:loginResult.loginsession forKey:LOGINSESSION];
    [defaults synchronize];
}

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:NICKNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:USERID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setFamilyName:(NSString *)familyName {
    _familyName = familyName;
    [[NSUserDefaults standardUserDefaults] setObject:familyName forKey:[NSString stringWithFormat:@"%@_%@",self.userId,FAMILYNAME]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIconPath:(NSString *)iconPath {
    _iconPath = iconPath;
    [[NSUserDefaults standardUserDefaults] setObject:iconPath forKey:[NSString stringWithFormat:@"%@_%@",self.userId,ICONPATH]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLoginSession:(NSString *)loginSession {
    _loginSession = loginSession;
    [[NSUserDefaults standardUserDefaults] setObject:loginSession forKey:LOGINSESSION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setFamilyId:(NSString *)familyId {
    _familyId = familyId;
    [[NSUserDefaults standardUserDefaults] setObject:familyId forKey:[NSString stringWithFormat:@"%@_%@",self.userId,FAMILYID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAccount:(NSString *)account {
    _account = account;
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:ACCOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString *)password {
    _password = password;
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:[NSString stringWithFormat:@"%@_%@",self.account,PASSWORD]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setRememberPwd:(BOOL)rememberPwd {
    _rememberPwd = rememberPwd;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:rememberPwd] forKey:REMEMBER_PWD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOpenNotification:(NSString *)openNotification {
    _openNotification = openNotification;
    [[NSUserDefaults standardUserDefaults] setObject:openNotification forKey:[NSString stringWithFormat:@"%@_%@",self.account,OPENNOTIFICATION]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nickName = [defaults objectForKey:NICKNAME];
    self.userId = [defaults objectForKey:USERID];
    self.phone = [defaults objectForKey:PHONE];
    self.encriptUserId = [NSString encrypt:self.userId key:Encrypt_Key];
    self.familyName = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@",self.userId,FAMILYNAME]];
    self.iconPath = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@",self.userId,ICONPATH]];
    self.loginSession = [defaults objectForKey:LOGINSESSION];
    self.familyId = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@",self.userId,FAMILYID]];
    self.account = [defaults objectForKey:ACCOUNT];
    self.password = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@",self.account,PASSWORD]];
    self.rememberPwd = [[defaults objectForKey:REMEMBER_PWD] boolValue];
    self.openNotification = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@",self.account,OPENNOTIFICATION]];
    if (BL_IsStrEmpty(self.openNotification)) {
        self.openNotification = @"1";//默认开启推送
    }
}

@end
