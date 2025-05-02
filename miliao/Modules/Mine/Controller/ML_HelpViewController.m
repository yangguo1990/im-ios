//
//  ML_HelpViewController.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_HelpViewController.h"
#import <WebKit/WebKit.h>

@interface ML_HelpViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong)WKWebView *webview;

@end

@implementation ML_HelpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"帮助", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    
     self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight)];
     [self.view addSubview:self.webview];
     self.webview.navigationDelegate = self;
     NSURL *url = [NSURL URLWithString:self.urlStr];
     NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
     [self.webview loadRequest:request];
}



@end
