//
//  UITableView+BLEmptyData.m
//  Supor
//
//  Created by 古北电子 on 2018/8/23.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "UITableView+BLEmptyData.h"

@implementation UITableView (BLEmptyData)

- (void)bl_tableViewDisplayWitMsg:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (rowCount == 0) {
            // Display a message when the table is empty
            UIImageView *noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.centerX-60, self.centerY-180, 120, 103)];
            noDataImage.image = [UIImage imageNamed:@"bldevice_noDevice"];
            
            
            // 没有数据的时候，UILabel的显示样式
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, noDataImage.bottom+22, BL_kDeviceWidth-40, 22)];
            messageLabel.text = message;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.textColor = BL_HEXSTRING_RGB(@"999999");
            messageLabel.font = BL_SYSTEM_FONT(15);

            UIView *vvvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            vvvv.backgroundColor = [UIColor clearColor];
            self.backgroundView = vvvv;
            
            [vvvv addSubview:noDataImage];
            [vvvv addSubview:messageLabel];
            
        } else {
            self.backgroundView = nil;
            self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
    });
}

- (void)bl_tableViewDisplayWitMsg:(NSString *)message imageName:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger)rowCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (rowCount == 0) {
            // Display a message when the table is empty
            UIImageView *noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.centerX-60, self.centerY-180, 120, 103)];
            noDataImage.image = [UIImage imageNamed:imageName];
            
            
            // 没有数据的时候，UILabel的显示样式
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, noDataImage.bottom+22, BL_kDeviceWidth-40, 22)];
            messageLabel.text = message;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.textColor = BL_HEXSTRING_RGB(@"999999");
            messageLabel.font = BL_SYSTEM_FONT(15);
            
            UIView *vvvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            vvvv.backgroundColor = [UIColor clearColor];
            self.backgroundView = vvvv;
            
            [vvvv addSubview:noDataImage];
            [vvvv addSubview:messageLabel];
            
        } else {
            self.backgroundView = nil;
            self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
    });
}

@end
