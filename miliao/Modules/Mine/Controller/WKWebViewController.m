//
//  WKWebViewController.m
//  TestWKWebView
//
//  Created by lk on 2019/5/13.
//  Copyright © 2019 lk. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT     [UIScreen mainScreen].bounds.size.height

@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UILabel *testLab;
@property (nonatomic, strong) UIButton *ocBtn;
@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = @"在线客服";
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0,88, ML_ScreenWidth, ML_ScreenHeight-88)];
    [self.view addSubview:self.webView];
    NSString *encodeUrl = [self.Rob_euCvar_Url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodeUrl]]];
}




@end
