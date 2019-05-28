//
//  BLCommonWebViewController.m
//  Supor
//
//  Created by 古北电子 on 2018/9/12.
//  Copyright © 2018年 古北电子. All rights reserved.
//

#import "BLCommonWebViewController.h"
#import <WebKit/WebKit.h>

@interface BLCommonWebViewController ()<WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic,strong) UIProgressView *progress;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, assign) NSInteger backCountClicked;

@end

@implementation BLCommonWebViewController

+ (void)load {
    [BLRoutesManager addRoute:kWebViewRoute className:NSStringFromClass([BLCommonWebViewController class]) handler:^BOOL(NSDictionary<NSString *,id> *parameters) {
        return YES;
    }];
}

// 允许多个手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark 加载进度条
- (UIProgressView *)progress
{
    if (_progress == nil) {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, BL_kDeviceWidth, 2)];
        _progress.tintColor = BL_HEX_RGB(0x5297FF);
        _progress.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 解决右滑返回失效问题
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.backCountClicked = 0;
    
    [self initBackBtnShowCloseBtn:NO];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, BL_kDeviceWidth, BL_kViewHeightWithoutStatusAndNavi-BL_kBottomSafeAreaHeight)];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    
    //TODO:kvo监听，获得页面title和加载进度值
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    NSURL *url = [NSURL URLWithString:self.requestUrl];
    
    //判断是否要清缓存
    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:kNeedClearWKWebViewCache] boolValue];
    if (flag) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kNeedClearWKWebViewCache];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:15.0];
        [self.webView loadRequest:request];
    }else {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initBackBtnShowCloseBtn:(BOOL)showCloseBtn {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 30.0, self.navigationController.navigationBar.height)];
    [back setImage:[UIImage imageNamed:@"blnavi_backIcon"] forState:UIControlStateNormal];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, 0.0, 0.0)];
    [back addTarget:self action:@selector(backNavItemTapped) forControlEvents:UIControlEventTouchUpInside];
    back.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(0, 0, 40.0, self.navigationController.navigationBar.height)];
    [closeBtn setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
    [closeBtn setTitleColor:BL_HEXSTRING_RGB(@"333333") forState:UIControlStateNormal];
    closeBtn.titleLabel.font = BL_SYSTEM_FONT(15);
    closeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [closeBtn addTarget:self action:@selector(closeWebViewClicked) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    NSArray *actionButtonItems;
    if (showCloseBtn) {
        actionButtonItems = @[backButtonItem, closeButtonItem];
    }else {
        actionButtonItems = @[backButtonItem];
    }

    self.navigationItem.leftBarButtonItems = actionButtonItems;
}

- (void)backNavItemTapped {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        [self initBackBtnShowCloseBtn:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeWebViewClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [webView evaluateJavaScript:@"document.getElementsByClassName('inner_header')[0].style.display='none'" completionHandler:nil];//移除头部的导航栏
//    [webView evaluateJavaScript:@"document.getElementsByClassName('empty-img')[0].style.display='none'" completionHandler:nil];//移除错误显示的图片
//    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#378BFA'"completionHandler:nil];
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.webView.estimatedProgress animated:YES];
            if (self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 移除观察者
- (void)dealloc {
    self.webView.scrollView.delegate = nil;
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

@end
