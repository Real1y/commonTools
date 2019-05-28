//
//  UIImage+BLCategory.h
//  Supor
//
//  Created by 古北电子 on 2018/8/31.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BLCategory)

+ (UIImage *)bl_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)bl_resizeImage:(NSString *)imgName;
- (UIImage *)bl_resizeImage;
+ (UIImage *)bl_streImageNamed:(NSString *)imageName;
+ (UIImage *)bl_streImageNamed:(NSString *)imageName capX:(CGFloat)x capY:(CGFloat)y;

//修改图片大小
+ (UIImage *)bl_imageResize:(UIImage*)img andResizeTo:(CGSize)newSize;

@end
