//
//  UIView+BLCategory.h
//  Supor
//
//  Created by 古北电子 on 2018/8/14.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BLCategory)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

- (void)bl_removeAllSubviews;

@end
