//
//  NSString+BLCategory.m
//  Supor
//
//  Created by 古北电子 on 2018/8/22.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "NSString+BLCategory.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <GTMBase64.h>

//偏移量
#define gIv             @"12345678"

@implementation NSString (BLCategory)

#pragma mark - 加密方法
+ (NSString *)encrypt:(NSString*)plainText key:(NSString *)key {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (data.length + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [gIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(kCCEncrypt,               //  加密/解密
                       kCCAlgorithmDES,          //  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,    //  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,                     //  密钥
                       kCCKeySizeDES,            //  DES 密钥的大小（kCCKeySizeDES=8）
                       iv,                       //  可选的初始矢量
                       [data bytes],             //  数据的存储单元
                       data.length,              // 数据的大小
                       (void *)dataOut,          // 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    
    NSData *dataFor = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
    NSString *result = [GTMBase64 stringByEncodingData:dataFor];
    
    return result;
}

#pragma mark - 解密方法
+ (NSString *)decrypt:(NSString*)encryptText key:(NSString *)key {
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeDES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}

+ (NSString *)md5ForLower32Bite:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

//根据身份证号码获取生日
+(NSString *)getBirthdayFromCertificate:(NSString *)certificateNo{
    
    NSString *year = [certificateNo substringWithRange:NSMakeRange(6, 4)];
    NSString *month = [certificateNo substringWithRange:NSMakeRange(10, 2)];
    NSString *day = [certificateNo substringWithRange:NSMakeRange(12, 2)];
    
    NSMutableString *birthday = [[NSMutableString alloc]initWithCapacity:10];
    [birthday appendFormat:@"%@-",year];
    [birthday appendFormat:@"%@-",month];
    [birthday appendFormat:@"%@",day];
    
    return birthday;
}

//校验url是否合法
+ (BOOL)isUrlAddress:(NSString *)url {
    NSString *reg =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return [urlPredicate evaluateWithObject:url];
}

//校验邮箱
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSRange range = [email rangeOfString:@".."];
    
    if (range.location != NSNotFound) {
        
        return NO;
    }
    //通用版本
    //NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    //自定义版本
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]+";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

//验证手机号码的合法性(以1开头的十一位数字)
+(BOOL)isValidatePhoneNum:(NSString *)phoneNum{
    
    NSString *regex =@"1[0-9]{10}";//@"(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}";
    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [mobileTest evaluateWithObject:phoneNum];
    
}

//校验密码合法性
+ (BOOL)isValidatePassword:(NSString *)password {
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:password];
//    return isMatch;
    if (password.length >= 6 && password.length <= 18) {
        return YES;
    }
    
    return NO;
}

//验证姓名为2－10汉字
+(BOOL) validateChinese: (NSString *)userName
{
    if (BL_IsStrEmpty(userName))
    {
        return NO;
    }
    NSString *shouhuorenRegex = @"[\\u4e00-\\u9fa5\\•\\·]{2,32}";//@"[\\u4e00-\\u9fa5]{2,10}";
    NSPredicate *shouhuorenTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", shouhuorenRegex];
    return [shouhuorenTest evaluateWithObject:userName];
}

//手机号隐位处理
+(NSString *)hiddenPhoneNum:(NSString *)phoneNum
{
    if (phoneNum.length == 11)
    {
        NSRange range = {3,6};
        
        NSString * aString = [phoneNum stringByReplacingCharactersInRange:range withString:@"******"];
        return  aString;
    }
    else
    {
        return phoneNum;
    }
}

//身份证号隐位处理
+(NSString *)hiddenIdCard:(NSString *)idCard
{
    NSRange range = {1,idCard.length -2};
    NSString * aString = [idCard stringByReplacingCharactersInRange:range withString:@"****************"];
    return  aString;
}

//邮箱号隐位处理
+(NSString *)hiddeEmail:(NSString *)email
{
    
    NSRange range1 = [email rangeOfString:@"@"];
    NSString *subStr = [email substringWithRange:NSMakeRange(0, range1.location)];
    if (subStr.length==1)
    {
        NSString *aString = [NSString stringWithFormat:@"%@%@***%@",subStr,subStr,email];
        return aString;
    }
    else if (subStr.length == 2)
    {
        NSRange range = {0,subStr.length-1};
        NSString *string = [email stringByReplacingCharactersInRange:range withString:@"***"];
        NSString *aString = [NSString stringWithFormat:@"%@%@",subStr,string];
        return aString;
    }
    else
    {
        NSRange range = {2,subStr.length-3};
        NSString *aString = [email stringByReplacingCharactersInRange:range withString:@"***"];
        return  aString;
    }
}


//手机号码加空格
+(NSString *)addWhiteSpaceInStrForPhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length == 11) {
        
        NSMutableString *mobilePhoneStr = [NSMutableString stringWithFormat:@"%@",phoneNumber];
        
        [mobilePhoneStr insertString:@" " atIndex:3];
        
        [mobilePhoneStr insertString:@" " atIndex:8];
        
        return mobilePhoneStr;
        
    }else
    {
        return phoneNumber;
    }
}

//去除字符串空白部分
+(NSString *)deleteWhiteSpaceInStr:(NSString *)string
{
    if (BL_IsNilOrNull(string))
    {
        return @"";
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [string componentsSeparatedByCharactersInSet:whitespace];
    
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    
    string = [filteredArray componentsJoinedByString:@""];
    
    return string;
}

//金额加逗号
+(NSString *)amountAddDouhao:(NSString *)string
{
    NSRange range = [string rangeOfString:@"."];
    NSString *str = nil;
    NSString *tmpStr = nil;
    if (range.location != NSNotFound) {
        str = [string substringFromIndex:range.location];
        tmpStr = [string substringToIndex:range.location];
    }else{
        tmpStr = string;
    }
    
    NSString *newString = @"";
    while (tmpStr.length > 3) {
        
        NSString *subString = [tmpStr substringFromIndex:tmpStr.length-3];
        newString = [NSString stringWithFormat:@"%@%@",subString,newString];
        if (subString.length == 3) {
            newString = [NSString stringWithFormat:@",%@",newString];
        }
        tmpStr = [tmpStr substringToIndex:tmpStr.length-3];
    }
    if (tmpStr.length > 0) {
        newString = [NSString stringWithFormat:@"%@%@",tmpStr,newString];
    }
    if (str) {
        newString = [newString stringByAppendingString:str];
    }
    return newString;
    
}

+ (NSString *)decimalNumberWithDoubleNumber:(NSNumber *)doubleNumber
{
    double conversionValue = [doubleNumber doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

//金额移除逗号
+ (NSString *)amountRemoveDouhao:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    return string;
}

@end
