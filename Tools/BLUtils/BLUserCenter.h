//
//  BLUserCenter.h
//  Supor
//
//  Created by 古北电子 on 2018/8/14.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUserCenter : NSObject

+ (BLUserCenter *)sharedInstance;

//清除单例
- (void)clearUserCenter;

- (void)setLoginResultInfo:(BLLoginResult *)loginResult;

@property (copy, nonatomic) NSString *nickName;

@property (copy, nonatomic) NSString *userId;

//经过DES加密后的userId，用于用户创建自己的家庭
@property (copy, nonatomic) NSString *encriptUserId;

//familyName
@property (copy, nonatomic) NSString *familyName;

@property (copy, nonatomic) NSString *iconPath;

//登录成功，返回login session
@property (copy, nonatomic) NSString *loginSession;

@property (copy, nonatomic) NSString *sex;

@property (copy, nonatomic) NSString *birthday;

@property (copy, nonatomic) NSString *phone;

@property (copy, nonatomic) NSString *email;

@property (copy, nonatomic) NSString *familyVersion;

@property (copy, nonatomic) NSString *familyId;

//用户名密码
@property (copy, nonatomic) NSString *account;

@property (copy, nonatomic) NSString *password;

@property (assign, nonatomic) BOOL rememberPwd;

//是否开启了推送,开启为1，未开启为0；
@property (copy, nonatomic) NSString *openNotification;

@end
