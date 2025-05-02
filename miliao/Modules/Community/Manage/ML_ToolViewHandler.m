//
//  ML_ToolViewHandler.m
//  YBImageBrowserDemo
//
//  Created by 波儿菜 on 2019/7/16.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "ML_ToolViewHandler.h"
#import "YBIBImageData.h"
#import "YBIBToastView.h"
#import <SDWebImage/SDWebImage.h>
#import "MLLinkLabel.h"

@interface ML_ToolViewHandler ()
@property (nonatomic, strong) UIButton *pageBtn;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *zhanButton;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *gitfButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIView *videoBgView;
//@property (nonatomic, strong) UIImageView *supView;
@property (nonatomic, strong) UIImageView *sexIV;
@property (nonatomic, strong) UILabel *creatTime;
@property (strong, nonatomic) UIImageView *ML_AvImgV;
@property (strong, nonatomic) UILabel *ML_Name;
@property (strong, nonatomic) MLLinkLabel *contentTextView;
@end

@implementation ML_ToolViewHandler

#pragma mark - <YBIBToolViewHandler>

@synthesize yb_containerView = _yb_containerView;
@synthesize yb_currentData = _yb_currentData;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentOrientation = _yb_currentOrientation;

- (void)yb_containerViewIsReadied {
    UIView *bottomBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 608*mHeightScale, ML_ScreenWidth, 264*mHeightScale)];
    bottomBackView.backgroundColor=[UIColor whiteColor];
    [self.yb_containerView addSubview:bottomBackView];
    [self.yb_containerView addSubview:self.pageBtn];
//    [self.yb_containerView addSubview:self.moreButton];
//    [self.yb_containerView addSubview:self.supView];
    
    UIImageView *topBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 170*mHeightScale)];
    topBack.image = kGetImage(@"bg_top");
    [self.Browser addSubview:topBack];
    [self.Browser sendSubviewToBack:topBack];
    self.Browser.backgroundColor = UIColor.whiteColor;
    self.Browser.collectionView.frame = CGRectMake(0, 148*mHeightScale, ML_ScreenWidth, 460*mHeightScale);
    self.Browser.collectionView.layer.cornerRadius = 16*mHeightScale;
    self.Browser.collectionView.layer.masksToBounds = YES;
    self.Browser.collectionView.backgroundColor = UIColor.blackColor;
   
    
    
    
    
    
    UIView *bottomBG = [[UIView alloc]initWithFrame:CGRectMake(16*mWidthScale, 722*mHeightScale, 343*mWidthScale, 56*mHeightScale)];
    bottomBG.layer.cornerRadius = 28*mHeightScale;
    bottomBG.backgroundColor = UIColor.whiteColor;
    bottomBG.layer.shadowOffset = CGSizeMake(0, 1);
    bottomBG.layer.shadowColor = [UIColor colorWithHexString:@"000000" alpha:0.25].CGColor;
    bottomBG.layer.shadowOpacity = 0.5;
    [self.yb_containerView addSubview:bottomBG];
    
    [self.yb_containerView addSubview:self.ML_AvImgV];
    [self.yb_containerView addSubview:self.ML_Name];
    [self.yb_containerView addSubview:self.backButton];
    [self.ML_Name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_AvImgV.mas_right).offset(10);
        make.top.mas_equalTo(self.ML_AvImgV.mas_top);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    self.sexIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.yb_containerView addSubview:self.sexIV];
    [self.sexIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_Name.mas_right).offset(5);
        make.width.height.mas_equalTo(16*mWidthScale);
        make.centerY.mas_equalTo(self.ML_Name.mas_centerY);
    }];
    
    
    self.creatTime = [[UILabel alloc]initWithFrame:CGRectZero];
    self.creatTime.font = [UIFont systemFontOfSize:10];
    self.creatTime.textColor = kGetColor(@"aaa6ae");
    [self.yb_containerView addSubview:self.creatTime];
    [self.creatTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_Name.mas_left);
        make.top.mas_equalTo(self.ML_Name.mas_bottom);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    [self.yb_containerView addSubview:self.ML_GuanzhuBtn];
    [self.ML_GuanzhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(64*mWidthScale);
        make.height.mas_equalTo(32*mHeightScale);
        make.top.mas_equalTo(self.ML_Name.mas_top);
        make.right.mas_equalTo(-20*mWidthScale);
    }];
    [self.yb_containerView addSubview:self.contentTextView];
    [self.yb_containerView addSubview:self.chatButton];
    [self.yb_containerView addSubview:self.gitfButton];
    
    [self imageViewAddClickWithImageView:self.ML_AvImgV];
}

- (void)setConText:(NSString *)contentStr
{
    
    self.ML_AvImgV.tag = [self.model.userId integerValue];
    
    [_ML_AvImgV sd_setImageWithURL:kGetUrlPath(self.model.icon) placeholderImage:kPlaceImage];
    _ML_Name.text = self.model.username;
    if ([self.model.gender isEqualToString:@"1"]) {
        self.sexIV.image = kGetImage(@"male");
    }else{
        self.sexIV.image = kGetImage(@"female");
    }
    
    if (self.model.location) {
        self.creatTime.text = [NSString stringWithFormat:@"%@·%@",self.model.createTime,self.model.location];
    }else{
        self.creatTime.text = self.model.createTime;
    }
    
    CGFloat ML_AvImgVMax = CGRectGetMaxY(self.ML_AvImgV.frame);
    
    if (contentStr) {
        
        
        //初始短文字
        NSMutableString *shortStr = [[NSMutableString alloc] initWithString:contentStr];
        NSMutableAttributedString *shortAttrStr = [[NSMutableAttributedString alloc]initWithString:shortStr];
        
        self.contentTextView.attributedText = shortAttrStr;
        
        CGFloat height = [shortStr boundingRectWithSize:CGSizeMake(ML_ScreenWidth - self.ML_AvImgV.x * 2, MAXFLOAT) font:self.contentTextView.font lineSpacing:self.contentTextView.lineSpacing maxLines:100];
        
        
        if (height > 50) {
            self.contentTextView.frame = CGRectMake(16*mWidthScale, 628*mHeightScale, ML_ScreenWidth - 32*mWidthScale, 50);
//            [self.supView addSubview:self.zhanButton];
            
            ML_AvImgVMax = CGRectGetMaxY(self.contentTextView.frame);
            
        } else {
            
            height += 15;
            self.contentTextView.frame = CGRectMake(16*mWidthScale, 628*mHeightScale, ML_ScreenWidth - 32*mWidthScale, height);;
            ML_AvImgVMax = CGRectGetMaxY(self.contentTextView.frame) + 10;
        }
        
    }
    
    self.chatButton.frame = CGRectMake(40*mWidthScale, 732*mHeightScale, 24*mWidthScale, 40*mHeightScale);
    
    self.gitfButton.frame = CGRectMake(90*mWidthScale,732*mHeightScale,24*mWidthScale,40*mWidthScale);
    
    CGFloat W = ML_ScreenWidth - CGRectGetMaxX(_gitfButton.frame) - 16 * 2;
    // 渐变视频按钮的背景
    self.videoBgView = [[UIView alloc] initWithFrame:CGRectMake(166*mWidthScale, 726*mHeightScale, 183*mWidthScale, 48*mHeightScale)];
    self.videoBgView.layer.cornerRadius = 24;
    self.videoBgView.hidden = YES;
    self.videoBgView.layer.masksToBounds = YES;
//    self.videoBgView.layer.masksToBounds = NO;
//    self.videoBgView.layer.shadowOffset = CGSizeMake(-5, 5);
//    self.videoBgView.layer.shadowRadius = 8;
//    self.videoBgView.layer.shadowOpacity = 0.75;
    [self.yb_containerView addSubview:self.videoBgView];
    //图层建立
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.videoBgView.bounds;
    gl.cornerRadius = 24;
    gl.startPoint = CGPointMake(0.45, 0.5);
    gl.endPoint = CGPointMake(0.55, 0.5);
    gl.colors = @[(__bridge id)kZhuColor.CGColor, (__bridge id)kZhuColor.CGColor];
    gl.locations = @[@(0.0f), @(1.0f)];
//    [self.videoBgView.layer addSublayer:gl];
    // 视频按钮
    [self.videoBgView addSubview:self.videoButton];
    self.videoButton.frame = self.videoBgView.bounds;

    
    CGFloat MaxH = CGRectGetMaxY(self.chatButton.frame);
//    self.supView.frame = CGRectMake(0, 548*mHeightScale, ML_ScreenWidth, 280*mHeightScale);
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
- (void)ML_ToolViewHandlerBtnClick:(UIButton *)btn
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
        self.contentTextView.frame = CGRectMake(16*mWidthScale, 628*mHeightScale, ML_ScreenWidth - 32*mWidthScale, 50);;
        
    } else {
        height += 5;
        self.contentTextView.frame = CGRectMake(16*mWidthScale, 628*mHeightScale, ML_ScreenWidth - 32*mWidthScale, height);;
    }
    
    self.zhanButton.frame = CGRectMake(self.yb_containerView.width - self.ML_AvImgV.x - 30, CGRectGetMaxY(self.contentTextView.frame), 30, 40);
    
    ML_AvImgVMax = CGRectGetMaxY(self.zhanButton.frame);
    
//    self.chatButton.frame = CGRectMake(self.ML_AvImgV.x, ML_AvImgVMax, 77, 48);
//    self.gitfButton.frame = CGRectMake(CGRectGetMaxX(_chatButton.frame) + 16, _chatButton.y, _chatButton.width, _chatButton.height);
    
    CGFloat W = ML_ScreenWidth - CGRectGetMaxX(_gitfButton.frame) - 16 * 2;
    // 渐变视频按钮的背景
    self.videoBgView.frame = CGRectMake(166*mWidthScale, 728*mHeightScale, 193*mWidthScale, 44*mHeightScale);

    CGFloat MaxH = CGRectGetMaxY(self.chatButton.frame);
//    self.supView.frame = CGRectMake(0, 548*mHeightScale, ML_ScreenWidth, 280*mHeightScale);
    
}


#pragma mark - getters
- (UIButton *)pageBtn {
    if (!_pageBtn) {
        _pageBtn = [[UIButton alloc] initWithFrame:CGRectMake(303*mWidthScale, 164*mHeightScale, 56*mWidthScale, 24*mHeightScale)];
        _pageBtn.userInteractionEnabled = NO;
        _pageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_pageBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_pageBtn setBackgroundImage:kGetImage(@"pageBt") forState:UIControlStateNormal];
    }
    return _pageBtn;
}


- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(16*mWidthScale, 54*mHeightScale, 24, 24)];
        _backButton.tag = 0;
        [_backButton addTarget:self action:@selector(ML_ToolViewHandlerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:kGetImage(@"icon_back_24_FFF_nor_1") forState:UIControlStateNormal];

    }
    return _backButton;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 120, 20, 108, ML_NavViewHeight - 20)];
        _moreButton.tag = 1;
        [_moreButton addTarget:self action:@selector(ML_ToolViewHandlerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_moreButton setImage:kGetImage(@"icon_fenxiang_24_FFF_nor") forState:UIControlStateNormal];
        [_moreButton setImage:kGetImage(@"button_home_page_32") forState:UIControlStateNormal];
        _moreButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
        _moreButton.layer.shadowOffset = CGSizeMake(0, 1);
        _moreButton.layer.shadowOpacity = 1;
        _moreButton.layer.shadowRadius = 4;
    }
    return _moreButton;
}


- (UIImageView *)ML_AvImgV
{
    if (!_ML_AvImgV) {
        
        _ML_AvImgV = [[UIImageView alloc] initWithFrame:CGRectMake(16*mWidthScale, 88*mHeightScale, 44*mWidthScale, 44*mWidthScale)];
        _ML_AvImgV.layer.masksToBounds = YES;
        _ML_AvImgV.layer.cornerRadius = 22*mHeightScale;
    }
    return _ML_AvImgV;
}

- (UILabel *)ML_Name{
    if (!_ML_Name) {
        
        _ML_Name = [[UILabel alloc] initWithFrame:CGRectZero];
        _ML_Name.textColor = [UIColor colorWithHexString:@"#000000"];
        [_ML_Name setFont:[UIFont boldSystemFontOfSize:14]];
        _ML_Name.textAlignment = NSTextAlignmentLeft;
        
    }
    return _ML_Name;
}

- (UIButton *)ML_GuanzhuBtn
{
    if (!_ML_GuanzhuBtn) {
        _ML_GuanzhuBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _ML_GuanzhuBtn.tag = 5;
        _ML_GuanzhuBtn.hidden = YES;
        _ML_GuanzhuBtn.titleLabel.font = kGetFont(13);
        _ML_GuanzhuBtn.layer.cornerRadius = _ML_GuanzhuBtn.height / 2;
        _ML_GuanzhuBtn.layer.masksToBounds = YES;
//        [_ML_GuanzhuBtn setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
//        [_ML_GuanzhuBtn setTitle:Localized(@"已关注", nil) forState:UIControlStateSelected];
        [_ML_GuanzhuBtn setBackgroundImage:kGetImage(@"Cfollow_NO") forState:UIControlStateNormal];
        [_ML_GuanzhuBtn setBackgroundImage:kGetImage(@"Cfollow") forState:UIControlStateSelected];
        [_ML_GuanzhuBtn addTarget:self action:@selector(ML_ToolViewHandlerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"userId" : self.model.userId} urlStr:@"user/whetherFocus"];

         kSelf;
         [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
             weakself.gitfButton.hidden = ![response.data[@"isShow"] boolValue];
             weakself.chatButton.hidden = ![response.data[@"isShow"] boolValue];
             weakself.videoBgView.hidden = ![response.data[@"isShow"] boolValue];
             weakself.ML_GuanzhuBtn.hidden = ![response.data[@"isShow"] boolValue];
             weakself.ML_GuanzhuBtn.selected = [response.data[@"flag"] boolValue];
//             if ([ML_AppUtil isCensor]) {
//                 weakself.gitfButton.hidden = YES;
//             }
         } error:^(MLNetworkResponse *response) {

         } failure:^(NSError *error) {
             
         }];
         
        
    }
    return _ML_GuanzhuBtn;
}

- (UIButton *)zhanButton
{
    if (!_zhanButton) {
        _zhanButton = [[UIButton alloc] initWithFrame:CGRectMake(self.yb_containerView.width - self.ML_AvImgV.x - 30, CGRectGetMaxY(self.contentTextView.frame), 30, 40)];
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
        _chatButton.hidden = YES;
        [_chatButton addTarget:self action:@selector(ML_ToolViewHandlerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:kGetImage(@"Cmessage") forState:UIControlStateNormal];
        _chatButton.tag = 2;
        [_chatButton setTitle:@"消息" forState:UIControlStateNormal];
        [_chatButton setImageEdgeInsets:UIEdgeInsetsMake(-18*mHeightScale, 0, 0, 0)];
        [_chatButton setTitleEdgeInsets:UIEdgeInsetsMake(27*mHeightScale, -27*mHeightScale, 0, 0)];
        _chatButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [_chatButton setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];

    }
    return _chatButton;
}

- (UIButton *)gitfButton
{
    if (!_gitfButton) {
        _gitfButton = [[UIButton alloc] init];
        _gitfButton.hidden = YES;
        [_gitfButton addTarget:self action:@selector(ML_ToolViewHandlerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_gitfButton setImage:kGetImage(@"Cgift") forState:UIControlStateNormal];
        [_gitfButton setImageEdgeInsets:UIEdgeInsetsMake(-18*mHeightScale, 0, 0, 0)];
        [_gitfButton setTitleEdgeInsets:UIEdgeInsetsMake(27*mHeightScale, -27*mHeightScale, 0, 0)];
        _gitfButton.tag = 3;
        [_gitfButton setTitle:@"礼物" forState:UIControlStateNormal];
        _gitfButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [_gitfButton setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];

    }
    return _gitfButton;
}

- (UIButton *)videoButton
{
    
    if (!_videoButton) {
        _videoButton = [[UIButton alloc] init];
        _videoButton.tag = 4;
        [_videoButton addTarget:self action:@selector(ML_ToolViewHandlerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
      
        if (kisCH) {
            [_videoButton setBackgroundImage:kGetImage(@"buttonBG1") forState:UIControlStateNormal];
            [_videoButton setTitle:@"视频聊天" forState:UIControlStateNormal];
            [_videoButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        } else {
            _videoButton.layer.cornerRadius = self.chatButton.height / 2;
            _videoButton.layer.masksToBounds = YES;
            _videoButton.backgroundColor = kZhuColor;
            [_videoButton setTitle:Localized(@"Video", nil) forState:UIControlStateNormal];
            [_videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
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
        _contentTextView.textColor = [UIColor colorWithHexString:@"#000000"];
        _contentTextView.font = [UIFont systemFontOfSize:14.0f];
        _contentTextView.textAlignment = NSTextAlignmentLeft;
//        _contentTextView.textInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _contentTextView.allowLineBreakInsideLinks = NO;
        _contentTextView.linkTextAttributes = nil;
        _contentTextView.activeLinkTextAttributes = nil;
    }
    return _contentTextView;
}


@end
