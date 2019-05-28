//
//  UITextField+BLCategory.h
//  Supor
//
//  Created by 古北电子 on 2018/8/17.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (BLCategory)

//修改Placeholder颜色
- (void)bl_setTextFieldPlaceholderColor:(UIColor *)color;

//修改clearButtonMode图片
- (void)bl_setClearButtonImage:(UIImage *)image;

@end
