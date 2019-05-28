//
//  BLTableViewConfig.h
//  Supor
//
//  Created by 古北电子 on 2018/8/20.
//  Copyright © 2018年 古北电子. All rights reserved.
//
// tableview中cell数据配置类
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BLCommonType) {
    BLCommonTypeOne,
    BLCommonTypeTwo,
    BLCommonTypeThree
};

@interface BLTableViewConfig : NSObject


/**
 以下几个接口根据需要自行选择设置
 */
- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title content:(NSString *)content selector:(NSString *)selector;

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title content:(NSString *)content commonType:(BLCommonType)commonType;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content commonType:(BLCommonType)commonType selector:(NSString *)selector;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *selector;

@property (nonatomic, assign) BLCommonType commonType;

@end
