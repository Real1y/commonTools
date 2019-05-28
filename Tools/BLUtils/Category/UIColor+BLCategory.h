//
//  UIColor+BLCategory.h
//  Supor
//
//  Created by 古北电子 on 2018/8/14.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BLCategory)

+ (UIColor *)bl_colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)bl_colorWithRGBHex:(UInt32)hex;

@end
