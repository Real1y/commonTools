//
//  UIBarButtonItem+BlocksKit.m
//  BlocksKit
//

#import <objc/runtime.h>
#import "UIBarButtonItem+Blocks.h"

static const void *BKBarButtonItemBlockKey = &BKBarButtonItemBlockKey;

@interface UIBarButtonItem (BlocksKitPrivate)

- (void)handleAction:(UIBarButtonItem *)sender;

@end

@implementation UIBarButtonItem (BlocksKit)

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void (^)(id sender))action
{
	self = [self initWithBarButtonSystemItem:systemItem target:self action:@selector(handleAction:)];
	if (!self) return nil;
    
	objc_setAssociatedObject(self, BKBarButtonItemBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
	return self;
}

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void (^)(id sender))action
{
	self = [self initWithImage:image style:style target:self action:@selector(handleAction:)];
	if (!self) return nil;
    
	objc_setAssociatedObject(self, BKBarButtonItemBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
	return self;
}

- (id)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(void (^)(id sender))action
{
	self = [self initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:self action:@selector(handleAction:)];
	if (!self) return nil;
    
	objc_setAssociatedObject(self, BKBarButtonItemBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
	return self;
}

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void (^)(id sender))action
{
	self = [self initWithTitle:title style:style target:self action:@selector(handleAction:)];
	if (!self) return nil;
    
	objc_setAssociatedObject(self, BKBarButtonItemBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
	return self;
}

- (void)handleAction:(UIBarButtonItem *)sender
{
	void (^block)(id) = objc_getAssociatedObject(self, BKBarButtonItemBlockKey);
	if (block) block(self);
}

@end
