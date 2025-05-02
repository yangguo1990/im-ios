//
//  ML_AgreementViewController.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_AgreementViewController.h"
#import <WebKit/WebKit.h>

@interface ML_AgreementViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong)WKWebView *webview;

@end

@implementation ML_AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"隐私协议", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight)];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:MlPrivacyhtml];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"webViewWebContentProcessDidTerminate");
    exit(0);
}

@end
