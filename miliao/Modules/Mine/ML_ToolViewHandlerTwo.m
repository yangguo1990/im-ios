//
//  ML_ToolViewHandlerTwo.m
//  YBImageBrowserDemo
//
//  Created by 波儿菜 on 2019/7/16.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "ML_ToolViewHandlerTwo.h"
#import "YBIBImageData.h"
#import "YBIBToastView.h"
#import <SDWebImage/SDWebImage.h>
#import "MLLinkLabel.h"

@interface ML_ToolViewHandlerTwo ()
@property (nonatomic, strong) UIButton *pageBtn;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *zhanButton;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *gitfButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIView *videoBgView;
@property (nonatomic, strong) UIImageView *supView;

@property (strong, nonatomic) UIImageView *ML_AvImgV;
@property (strong, nonatomic) UILabel *ML_Name;
@property (strong, nonatomic) MLLinkLabel *contentTextView;
@end

@implementation ML_ToolViewHandlerTwo

#pragma mark - <YBIBToolViewHandler>

@synthesize yb_containerView = _yb_containerView;
@synthesize yb_currentData = _yb_currentData;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentOrientation = _yb_currentOrientation;

- (void)yb_containerViewIsReadied {

    [self.yb_containerView addSubview:self.backButton];

}

- (void)setConText:(NSString *)contentStr
{
    
    self.ML_AvImgV.tag = [self.model.userId integerValue];
    
    [_ML_AvImgV sd_setImageWithURL:kGetUrlPath(self.model.icon) placeholderImage:kPlaceImage];
    _ML_Name.text = self.model.username;
    
    CGFloat ML_AvImgVMax = CGRectGetMaxY(self.ML_AvImgV.frame);
    
    if (contentStr) {
        
        
        //初始短文字
        NSMutableString *shortStr = [[NSMutableString alloc] initWithString:contentStr];
        NSMutableAttributedString *shortAttrStr = [[NSMutableAttributedString alloc]initWithString:shortStr];
        
        self.contentTextView.attributedText = shortAttrStr;
        
        CGFloat height = [shortStr boundingRectWithSize:CGSizeMake(ML_ScreenWidth - self.ML_AvImgV.x * 2, MAXFLOAT) font:self.contentTextView.font lineSpacing:self.contentTextView.lineSpacing maxLines:100];
        
        
        if (height > 50) {
            self.contentTextView.frame = CGRectMake(self.ML_AvImgV.x, CGRectGetMaxY(self.ML_AvImgV.frame) + 12, ML_ScreenWidth - self.ML_AvImgV.x * 2, 50);
            [self.supView addSubview:self.zhanButton];
            
            ML_AvImgVMax = CGRectGetMaxY(self.zhanButton.frame);
            
        } else {
            
            height += 15;
            self.contentTextView.frame = CGRectMake(self.ML_AvImgV.x, CGRectGetMaxY(self.ML_AvImgV.frame) + 12, ML_ScreenWidth - self.ML_AvImgV.x * 2, height);
            ML_AvImgVMax = CGRectGetMaxY(self.contentTextView.frame) + 10;
        }
        
    }
    
    self.chatButton.frame = CGRectMake(self.ML_AvImgV.x, ML_AvImgVMax, 77, 48);
    self.gitfButton.frame = CGRectMake(CGRectGetMaxX(_chatButton.frame) + 16, _chatButton.y, _chatButton.width, _chatButton.height);
    
    CGFloat W = ML_ScreenWidth - CGRectGetMaxX(_gitfButton.frame) - 16 * 2;
    // 渐变视频按钮的背景
    self.videoBgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gitfButton.frame) + 16, _chatButton.y, W, _chatButton.height)];
    self.videoBgView.layer.cornerRadius = 24;
    self.videoBgView.layer.masksToBounds = NO;
    self.videoBgView.layer.shadowOffset = CGSizeMake(-5, 5);
    self.videoBgView.layer.shadowRadius = 8;
    self.videoBgView.layer.shadowOpacity = 0.75;
    [self.supView addSubview:self.videoBgView];
    //图层建立
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.videoBgView.bounds;
    gl.cornerRadius = 24;
    gl.startPoint = CGPointMake(0.45, 0.5);
    gl.endPoint = CGPointMake(0.55, 0.5);
    gl.colors = @[(__bridge id)kZhuColor.CGColor, (__bridge id)kZhuColor.CGColor];
    gl.locations = @[@(0.0f), @(1.0f)];
    [self.videoBgView.layer addSublayer:gl];
    // 视频按钮
    [self.videoBgView addSubview:self.videoButton];
    self.videoButton.frame = self.videoBgView.bounds;

    
    CGFloat MaxH = CGRectGetMaxY(self.chatButton.frame);
    self.supView.frame = CGRectMake(0, ML_ScreenHeight - 48 - MaxH - (SSL_isFullScreen?40:0), ML_ScreenWidth, MaxH);
}

- (void)yb_hide:(BOOL)hide {
    
}


- (void)yb_pageChanged {
    
    [self.pageBtn setTitle:[NSString stringWithFormat:@"%ld/%ld", self.Browser.currentPage+1, self.Browser.dataSourceArray.count] forState:UIControlStateNormal];
    self.pageBtn.hidden = (self.Browser.dataSourceArray.count==1);
    if (self.contentTextView.tag) {
        self.contentTextView.tag = 0;

        [self setConText:self.model.title];
    }
    
}

#pragma mark - event
- (void)ML_ToolViewHandlerTwoBtnClick:(UIButton *)btn
{
    NSLog(@"tag ===%d", btn.tag);
    
   if (self.ML_ToolViewHandlerBtnBlock) {
       self.ML_ToolViewHandlerBtnBlock(btn.tag);
   }
}

- (void)ML_ZhanShhouBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSString *contentStr = self.model.title;
    
    CGFloat ML_AvImgVMax = CGRectGetMaxY(self.ML_AvImgV.frame);

    //初始短文字 18126249637
    NSMutableString *shortStr = [[NSMutableString alloc] initWithString:contentStr];
    NSMutableAttributedString *shortAttrStr = [[NSMutableAttributedString alloc]initWithString:shortStr];
    
//    self.contentTextView.attributedText = shortAttrStr;
    self.contentTextView.text = contentStr;
    
    CGFloat height = [shortStr boundingRectWithSize:CGSizeMake(ML_ScreenWidth - self.ML_AvImgV.x * 2, MAXFLOAT) font:self.contentTextView.font lineSpacing:self.contentTextView.lineSpacing maxLines:100];
    
    
    if (!btn.selected) {
        self.contentTextView.frame = CGRectMake(self.ML_AvImgV.x, CGRectGetMaxY(self.ML_AvImgV.frame) + 12, ML_ScreenWidth - self.ML_AvImgV.x * 2, 50);
        
    } else {
        height += 5;
        self.contentTextView.frame = CGRectMake(self.ML_AvImgV.x, CGRectGetMaxY(self.ML_AvImgV.frame) + 12, ML_ScreenWidth - self.ML_AvImgV.x * 2, height);
    }
    
    self.zhanButton.frame = CGRectMake(self.supView.width - self.ML_AvImgV.x - 30, CGRectGetMaxY(self.contentTextView.frame), 30, 40);
    
    ML_AvImgVMax = CGRectGetMaxY(self.zhanButton.frame);
    
    self.chatButton.frame = CGRectMake(self.ML_AvImgV.x, ML_AvImgVMax, 77, 48);
    self.gitfButton.frame = CGRectMake(CGRectGetMaxX(_chatButton.frame) + 16, _chatButton.y, _chatButton.width, _chatButton.height);
    
    CGFloat W = ML_ScreenWidth - CGRectGetMaxX(_gitfButton.frame) - 16 * 2;
    // 渐变视频按钮的背景
    self.videoBgView.frame = CGRectMake(CGRectGetMaxX(_gitfButton.frame) + 16, _chatButton.y, W, _chatButton.height);

    CGFloat MaxH = CGRectGetMaxY(self.chatButton.frame);
    self.supView.frame = CGRectMake(0, ML_ScreenHeight - 48 - MaxH - (SSL_isFullScreen?40:0), ML_ScreenWidth, MaxH);
    
}


#pragma mark - getters
- (UIButton *)pageBtn {
    if (!_pageBtn) {
        _pageBtn = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 40, 20, 80, ML_NavViewHeight - 20)];
        _pageBtn.userInteractionEnabled = NO;
        _pageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_pageBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _pageBtn.layer.cornerRadius = 5.0;
    }
    return _pageBtn;
}


- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 60, ML_NavViewHeight - 20)];
        _backButton.tag = 0;
        [_backButton addTarget:self action:@selector(ML_ToolViewHandlerTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:kGetImage(@"icon_back_24_FFF_nor") forState:UIControlStateNormal];
        _backButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
        _backButton.layer.shadowOffset = CGSizeMake(0, 1);
        _backButton.layer.shadowOpacity = 1;
        _backButton.layer.shadowRadius = 4;
    }
    return _backButton;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 70, 20, 60, ML_NavViewHeight - 20)];
        _moreButton.tag = 1;
        [_moreButton addTarget:self action:@selector(ML_ToolViewHandlerTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setImage:kGetImage(@"icon_fenxiang_24_FFF_nor") forState:UIControlStateNormal];
        _moreButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
        _moreButton.layer.shadowOffset = CGSizeMake(0, 1);
        _moreButton.layer.shadowOpacity = 1;
        _moreButton.layer.shadowRadius = 4;
    }
    return _moreButton;
}
- (UIView *)supView {
    if (!_supView) {
        _supView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight)];
        _supView.userInteractionEnabled = YES;
        UIImage  * img = kGetImage(@"lv_mengceng_up");
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
        _supView.image = img;
    }
    return _supView;
}

- (UIImageView *)ML_AvImgV
{
    if (!_ML_AvImgV) {
        
        _ML_AvImgV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 40, 40)];
        _ML_AvImgV.layer.masksToBounds = YES;
        _ML_AvImgV.layer.cornerRadius = 20;
    }
    return _ML_AvImgV;
}

- (UILabel *)ML_Name{
    if (!_ML_Name) {
        
        _ML_Name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.ML_AvImgV.frame) + 12, self.ML_AvImgV.y, 100, self.ML_AvImgV.height)];
        _ML_Name.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [_ML_Name setFont:[UIFont boldSystemFontOfSize:16]];
        _ML_Name.textAlignment = NSTextAlignmentLeft;
        
    }
    return _ML_Name;
}

- (UIButton *)ML_GuanzhuBtn
{
    if (!_ML_GuanzhuBtn) {
        
        _ML_GuanzhuBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.supView.width - 70 - self.ML_AvImgV.x, self.ML_AvImgV.y + 5, 70, 30)];
        _ML_GuanzhuBtn.tag = 5;
        _ML_GuanzhuBtn.titleLabel.font = kGetFont(13);
        _ML_GuanzhuBtn.layer.cornerRadius = _ML_GuanzhuBtn.height / 2;
        _ML_GuanzhuBtn.layer.masksToBounds = YES;
        _ML_GuanzhuBtn.backgroundColor = kZhuColor;
        [_ML_GuanzhuBtn setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
        [_ML_GuanzhuBtn setTitle:Localized(@"已关注", nil) forState:UIControlStateSelected];
        [_ML_GuanzhuBtn addTarget:self action:@selector(ML_ToolViewHandlerTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"userId" : self.model.userId} urlStr:@"user/whetherFocus"];

         kSelf;
         [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

             weakself.ML_GuanzhuBtn.selected = [response.data[@"flag"] boolValue];
             
         } error:^(MLNetworkResponse *response) {

         } failure:^(NSError *error) {
             
         }];
         
        
    }
    return _ML_GuanzhuBtn;
}

- (UIButton *)zhanButton
{
    if (!_zhanButton) {
        _zhanButton = [[UIButton alloc] initWithFrame:CGRectMake(self.supView.width - self.ML_AvImgV.x - 30, CGRectGetMaxY(self.contentTextView.frame), 30, 40)];
        [_zhanButton addTarget:self action:@selector(ML_ZhanShhouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_zhanButton setImage:kGetImage(@"icon_zhankai") forState:UIControlStateSelected];
        [_zhanButton setImage:kGetImage(@"icon_shouqi") forState:UIControlStateNormal];
    }
    return _zhanButton;
}


- (UIButton *)chatButton
{
    if (!_chatButton) {
        
        _chatButton = [[UIButton alloc] init];
        [_chatButton addTarget:self action:@selector(ML_ToolViewHandlerTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setTitle:@"私信" forState:UIControlStateNormal];
        _chatButton.tag = 2;
        _chatButton.layer.borderWidth = 0.5;
        _chatButton.layer.borderColor = kZhuColor.CGColor;
        [_chatButton setTitleColor:kZhuColor forState:UIControlStateNormal];
        _chatButton.layer.backgroundColor = [UIColor colorWithRed:131/255.0 green:93/255.0 blue:255/255.0 alpha:0.1000].CGColor;
        _chatButton.layer.cornerRadius = 24;
    }
    return _chatButton;
}

- (UIButton *)gitfButton
{
    if (!_gitfButton) {
        _gitfButton = [[UIButton alloc] init];
        [_gitfButton addTarget:self action:@selector(ML_ToolViewHandlerTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_gitfButton setTitle:Localized(@"礼物", nil) forState:UIControlStateNormal];
        _gitfButton.tag = 3;
        _gitfButton.layer.borderWidth = 0.5;
        _gitfButton.layer.borderColor = kZhuColor.CGColor;
        [_gitfButton setTitleColor:kZhuColor forState:UIControlStateNormal];
        _gitfButton.layer.backgroundColor = [UIColor colorWithRed:131/255.0 green:93/255.0 blue:255/255.0 alpha:0.1000].CGColor;
        _gitfButton.layer.cornerRadius = _chatButton.layer.cornerRadius;
    }
    return _gitfButton;
}

- (UIButton *)videoButton
{
    
    if (!_videoButton) {
        _videoButton = [[UIButton alloc] init];
        _videoButton.tag = 4;
        [_videoButton addTarget:self action:@selector(ML_ToolViewHandlerTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_videoButton setTitle:Localized(@"视频", nil) forState:UIControlStateNormal];
        _videoButton.titleLabel.font = kGetFont(16);
    }
    return _videoButton;
}

- (MLLinkLabel *)contentTextView
{
    if (!_contentTextView) {
        
        _contentTextView = [[MLLinkLabel alloc] init];
        _contentTextView.lineSpacing = 5;
        _contentTextView.tag = 1;
        _contentTextView.numberOfLines = 0;
        _contentTextView.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _contentTextView.font = [UIFont systemFontOfSize:16.0f];
        _contentTextView.textAlignment = NSTextAlignmentLeft;
//        _contentTextView.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _contentTextView.allowLineBreakInsideLinks = NO;
        _contentTextView.linkTextAttributes = nil;
        _contentTextView.activeLinkTextAttributes = nil;
    }
    return _contentTextView;
}


@end
