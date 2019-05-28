//
//  BLCalculagraph.h
//  Supor
//
//  Created by 古北电子 on 2018/8/27.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLCalculagraph : NSObject
{
@private
    CGFloat time_;
    
    CGFloat timeOut_;
    
    NSTimer *timer_;
    
    BOOL    _validate;
}

@property (nonatomic, assign) CGFloat time;

@property (nonatomic, assign) CGFloat timeOut;

@property (nonatomic, assign) NSInteger interval;

- (CGFloat)seconds;

- (void)startWithInterval:(NSInteger)seconds;

- (void)stop;


- (BOOL)isValidate;
@end
