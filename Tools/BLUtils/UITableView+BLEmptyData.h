//
//  UITableView+BLEmptyData.h
//  Supor
//
//  Created by 古北电子 on 2018/8/23.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (BLEmptyData)

- (void)bl_tableViewDisplayWitMsg:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount;

- (void)bl_tableViewDisplayWitMsg:(NSString *)message imageName:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger)rowCount;

@end
