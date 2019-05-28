//
//  BLDeviceLinkageInfo.h
//  Supor
//
//  Created by 邰光源 on 2018/12/12.
//  Copyright © 2018 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLDeviceLinkageInfo : NSObject

@property (nonatomic, copy) NSString *did;

@property (nonatomic, copy) NSString *tempId;

//用于判断是否在实例化
@property (nonatomic, assign) BOOL linking;

@end

