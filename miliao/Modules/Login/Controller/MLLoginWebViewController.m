//
//  MLLoginWebViewController.m
//  miliao
//
//  Created by apple on 2022/9/21.
//

#import "MLLoginWebViewController.h"
#import <WebKit/WebKit.h>

@interface MLLoginWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic,strong)WKWebView *webview;

@end

@implementation MLLoginWebViewController

- (void)ML_backClickklb_la {
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = self.navtitle;
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    self.ML_backBtn.hidden = NO;
}

-(void)setupUI{
    self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight)];
    NSURL *url = [NSURL URLWithString:self.webhtml];
    self.webview.navigationDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
        // 导航代理
    [self.view addSubview:self.webview];
}

#pragma mark - WKScriptMessageHandler
/// 通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"backurl"]) {
        NSLog(@"%@-------",message);
    }
}


#pragma mark - WKNavigationDelegate
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用----%@",webView);
    
}





@end
