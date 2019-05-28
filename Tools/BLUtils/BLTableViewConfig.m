//
//  BLTableViewConfig.m
//  Supor
//
//  Created by 古北电子 on 2018/8/20.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLTableViewConfig.h"

@implementation BLTableViewConfig

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title content:(NSString *)content selector:(NSString *)selector {
    self = [super init];
    if (self) {
        _imageName = imageName;
        _title = title;
        _content = content;
        _selector = selector;
    }
    
    return self;
}

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title content:(NSString *)content commonType:(BLCommonType)commonType {
    self = [super init];
    if (self) {
        _imageName = imageName;
        _title = title;
        _content = content;
        _commonType = commonType;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content commonType:(BLCommonType)commonType selector:(NSString *)selector {
    self = [super init];
    if (self) {
        _title = title;
        _content = content;
        _commonType = commonType;
        _selector = selector;
    }
    
    return self;
}

@end
