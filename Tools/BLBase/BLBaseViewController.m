//
//  BLBaseViewController.m
//  heat
//
//  Created by 青峰 on 2018/12/14.
//  Copyright © 2018 青峰. All rights reserved.
//

#import "BLBaseViewController.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>

@interface BLBaseViewController ()<UITextFieldDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate>

@end

@implementation BLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Y起点在导航条下面
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.hidesBackButton = YES;
    //去除导航栏返回默认文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    //
    //    self.navigationController.navigationBar.backItem.title = @"";
//    self.view.backgroundColor = BL_RGBCOLOR(244, 244, 244);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BL_HEX_RGB(0x333333)}];
    
    if (!self.isHidenBackBtn)
    {
        [self initBackBtn];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage bl_imageWithColor:[UIColor whiteColor] size:CGSizeMake(BL_kDeviceWidth, BL_kNavAndStatusBarHight)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BL_HEX_RGB(0x333333)}];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)initBackBtn {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [back setFrame:CGRectMake(0, 0, 60.0, self.navigationController.navigationBar.height)];
    [back setImage:[UIImage imageNamed:@"blnavi_backIcon"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backNavItemTapped) forControlEvents:UIControlEventTouchUpInside];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0.0, -45.0, 0.0, 0.0)];
    back.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setBackNavItemImage:(NSString *)imageName {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [back setFrame:CGRectMake(0, 0, 60.0, self.navigationController.navigationBar.height)];
    [back setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backNavItemTapped) forControlEvents:UIControlEventTouchUpInside];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0.0, -40.0, 0.0, 0.0)];
    back.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backNavItemTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightBarButtonItemWithImageName:(NSString *)imageName TitleName:(NSString *)titleName titleTintColor:(UIColor *)titleTintColor{
    if (!BL_IsStrEmpty(imageName)) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 18, 18);
        if ([imageName isEqualToString:@"更多"]) {
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }else {
            [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(rightNavItemTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButtonitem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightButtonitem;
    }else if(!BL_IsStrEmpty(titleName)){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:titleName style:UIBarButtonItemStylePlain target:self action:@selector(rightNavItemTapped)];
        if (!BL_IsNilOrNull(titleTintColor)) {
            self.navigationItem.rightBarButtonItem.tintColor = titleTintColor;
        }else {
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
            
        }
    }
}

- (void)rightNavItemTapped {
    
}

- (void)showMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *errorString = BL_IsStrEmpty(message) ? @"未知错误" : message;
        [self.view makeToast:NSLocalizedString(errorString, nil) duration:1.0f position:CSToastPositionCenter];
    });
}

- (void)showErrorMessageWithErrorCode:(NSString *)errorCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *codeString = [NSString stringWithFormat:@"error code:%@",errorCode];
        [self.view makeToast:NSLocalizedString(codeString, nil) duration:1.0f position:CSToastPositionCenter];
    });
}

- (void)showWaiting {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (BL_IsNilOrNull(self.view)) {
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)showWaitingOnWindow {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (BL_IsNilOrNull(self.view)) {
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    });
}

- (void)showWaitingWithText:(NSString *)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.label.text = text;
}

- (void)showWaitingAndInit {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (BL_IsNilOrNull(self.view)) {
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)hideWaiting {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (BL_IsNilOrNull(self.view)) {
            return;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)hideWaitingOnWindow {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (BL_IsNilOrNull(self.view)) {
            return;
        }
        [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)initAllTextfileds
{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITextField class]]){
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
        }
        
        for(UIView *subView in view.subviews) {
            if([subView isKindOfClass:[UITextField class]]){
                UITextField *tf = (UITextField *)subView;
                tf.delegate = self;
            }
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect screenFrame = [textField.superview convertRect:textField.frame toView:self.view];
    
    CGFloat offset = 0;
    if (BL_isFullScreen) {
        NSLog(@"%f",BL_kBottomSafeAreaHeight);
        offset = self.view.frame.size.height - (screenFrame.origin.y + screenFrame.size.height + 216 + 50 + 34);//全面屏需要多减去一个安全区高度
    }else {
        offset = self.view.frame.size.height - (screenFrame.origin.y + screenFrame.size.height + 216 + 50);
    }
    
    if(offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0f+BL_kNavAndStatusBarHight;
        self.view.frame = frame;
    }];
    
    return YES;
}

- (void)tableViewAddGesture:(UITableView *)tableView {
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [tableView addGestureRecognizer:tableViewGesture];
}

- (void)tableViewTouchInSide {
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
