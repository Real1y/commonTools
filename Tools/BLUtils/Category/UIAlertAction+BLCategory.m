//
//  UIAlertAction+BLCategory.m
//  Supor
//
//  Created by 古北电子 on 2018/8/14.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "UIAlertAction+BLCategory.h"
#import <objc/runtime.h>

@implementation UIAlertAction (BLCategory)

- (void)bl_setTitleTextColor:(UIColor *)color
{
    if (!color) {
        return;
    }
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([UIAlertAction class], &count);
    for (unsigned int i=0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        if ([[NSString stringWithUTF8String:ivarName] isEqualToString:@"_titleTextColor"]) {
            [self setValue:color forKey:@"_titleTextColor"];
            break;
        }
    }
}

@end
