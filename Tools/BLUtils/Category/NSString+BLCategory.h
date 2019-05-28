//
//  NSString+BLCategory.h
//  Supor
//
//  Created by 古北电子 on 2018/8/22.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BLCategory)

//des加密
+ (NSString *)encrypt:(NSString*)plainText key:(NSString *)key;

//des解密
+ (NSString *)decrypt:(NSString*)encryptText key:(NSString *)key;

+ (NSString *)md5ForLower32Bite:(NSString *)str;

//根据身份证号码获取生日
+ (NSString *)getBirthdayFromCertificate:(NSString *)certificateNo;
//校验url是否合法
+ (BOOL)isUrlAddress:(NSString *)url;
//校验邮箱
+ (BOOL)isValidateEmail:(NSString *)email;
//校验手机号
+ (BOOL)isValidatePhoneNum:(NSString *)phoneNum;
//校验密码
+ (BOOL)isValidatePassword:(NSString *)password;
//验证姓名为2－10汉字
+(BOOL) validateChinese: (NSString *)userName;
//手机号隐位处理
+ (NSString *)hiddenPhoneNum:(NSString *)phoneNum;
//身份证号隐位处理
+ (NSString *)hiddenIdCard:(NSString *)idCard;
//邮箱号隐位处理
+ (NSString *)hiddeEmail:(NSString *)email;
//手机号码加空格
+ (NSString *)addWhiteSpaceInStrForPhoneNumber:(NSString *)phoneNumber;
//去除字符串空白部分
+(NSString *)deleteWhiteSpaceInStr:(NSString *)string;
//金额加逗号
+ (NSString *)amountAddDouhao:(NSString *)string;
//金额移除逗号
+ (NSString *)amountRemoveDouhao:(NSString *)string;
//将double类型的NSNumber转换成字符串，主要解决金额精度的问题
+ (NSString *)decimalNumberWithDoubleNumber:(NSNumber *)doubleNumber;

@end
