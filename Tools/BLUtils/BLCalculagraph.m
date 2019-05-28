//
//  BLCalculagraph.m
//  Supor
//
//  Created by 古北电子 on 2018/8/27.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLCalculagraph.h"
@interface BLCalculagraph()
{
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    UIBackgroundTaskIdentifier backgroundTask;
#endif
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BLCalculagraph

@synthesize time = time_;

@synthesize timer = timer_;

@synthesize timeOut = timeOut_;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.time = 0.0;
    }
    return self;
}

- (void)dealloc
{
    [self stop];
    
}

#if TARGET_OS_IPHONE
+ (BOOL)isMultitaskingSupported
{
    BOOL multiTaskingSupported = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        multiTaskingSupported = [(id)[UIDevice currentDevice] isMultitaskingSupported];
    }
    return multiTaskingSupported;
}
#endif

- (void)startWithInterval:(NSInteger)seconds
{
    [self stop];
    _interval = seconds;
    
    self.time = 0.0;
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    if ([BLCalculagraph isMultitaskingSupported] )
    {
        if (!backgroundTask || backgroundTask == UIBackgroundTaskInvalid)
        {
            backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                // Synchronize the cleanup call on the main thread in case
                // the task actually finishes at around the same time.
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (backgroundTask != UIBackgroundTaskInvalid)
                    {
                        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                        backgroundTask = UIBackgroundTaskInvalid;
                    }
                });
            }];
        }
    }
#endif
    
    NSTimer *timer;
    
    NSDate *date = [NSDate date];
    
    timer = [[NSTimer alloc] initWithFireDate:date interval:seconds target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
    
    _validate = YES;
    
}

- (void)refreshTime
{
    self.time += self.interval;
    
    if (timeOut_ > 0 && self.time >= timeOut_)
    {
        [self stop];
    }
}

- (void)stop
{
    if (self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        
        self.timer = nil;
        
        _validate = NO;
        
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        if ([BLCalculagraph isMultitaskingSupported])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (backgroundTask != UIBackgroundTaskInvalid) {
                    [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                    backgroundTask = UIBackgroundTaskInvalid;
                }
            });
        }
#endif
    }
}

- (CGFloat)seconds
{
    return self.time;
}

- (BOOL)isValidate
{
    return _validate;
}

@end
