//
//  BLBaseViewController.h
//  heat
//
//  Created by 青峰 on 2018/12/14.
//  Copyright © 2018 青峰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isHidenBackBtn;

@property (nonatomic, strong) UIButton *backBtn;

- (void)setBackNavItemImage:(NSString *)imageName;

- (void)backNavItemTapped;

- (void)setRightBarButtonItemWithImageName:(NSString *)imageName TitleName:(NSString *)titleName titleTintColor:(UIColor *)titleTintColor;

- (void)rightNavItemTapped;

//toast提示message
- (void)showMessage:(NSString *)message;

//根据errorcode提示
- (void)showErrorMessageWithErrorCode:(NSString *)errorCode;

//显示加载圈
- (void)showWaiting;

//显示加载圈在window上
- (void)showWaitingOnWindow;

- (void)showWaitingWithText:(NSString *)text;

- (void)showWaitingAndInit;

//隐藏加载圈
- (void)hideWaiting;

- (void)hideWaitingOnWindow;

- (void)initAllTextfileds;//文本框随键盘提升

//给tableview添加手势，点击空白处键盘隐藏
- (void)tableViewAddGesture:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
