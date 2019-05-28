//
//  UIColor+BLCategory.m
//  Supor
//
//  Created by 古北电子 on 2018/8/14.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "UIColor+BLCategory.h"

@implementation UIColor (BLCategory)

+ (UIColor *)bl_colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)bl_colorWithHexString:(NSString *)stringToConvert
{
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor bl_colorWithRGBHex:hexNum];
}

@end
