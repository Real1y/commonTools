//
//  UITextField+BLCategory.m
//  Supor
//
//  Created by 古北电子 on 2018/8/17.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "UITextField+BLCategory.h"

@implementation UITextField (BLCategory)

- (void)bl_setTextFieldPlaceholderColor:(UIColor *)color {
    if (!color) {
        return;
    }
    
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)bl_setClearButtonImage:(UIImage *)image {
    if (!image) {
        return;
    }
    
    [[self valueForKey:@"_clearButton"] setImage:image forState:UIControlStateNormal];
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

@end
