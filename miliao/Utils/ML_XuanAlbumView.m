

#import "ML_XuanAlbumView.h"
#import "UIView+XHAdd.h"
#import "TZImagePickerController.h"
#import "UIView+TFPopup.h"

static NSInteger tagIndex = 345464;

@interface ML_XuanAlbumView ()

@property (nonatomic, copy) void(^didAcitonIndex)(NSInteger index);
@property (nonatomic, strong) NSArray <PopItemModel *>*items;

@end

@implementation ML_XuanAlbumView

+ (void)popItems:(NSArray <PopItemModel *>*)items action:(void(^)(NSInteger index))acitonIndex {
    CGFloat itemH = 54*items.count + 5 + (SSL_isFullScreen ? 34 : 0);
    
    ML_AppPopupParam *param = [[ML_AppPopupParam alloc] init];
    param.dragEnable = YES;
    
    ML_XuanAlbumView *popView = [[ML_XuanAlbumView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, itemH)];
    param.popupSize = popView.size;
    popView.items = items;
    popView.didAcitonIndex = acitonIndex;
    [popView configViews];
    [popView tf_showSlide:KEY_WINDOW.window direction:PopupDirectionBottom popupParam:param];
}

+ (void)popItemsWithView:(UIView *)view items:(NSArray <PopItemModel *>*)items action:(void(^)(NSInteger index))acitonIndex {
    CGFloat itemH = 54*items.count + 5 + (SSL_isFullScreen ? 34 : 0);
    
    ML_AppPopupParam *param = [[ML_AppPopupParam alloc] init];
    param.dragEnable = YES;
    
    ML_XuanAlbumView *popView = [[ML_XuanAlbumView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, itemH)];
    param.popupSize = popView.size;
    popView.items = items;
    popView.didAcitonIndex = acitonIndex;
    [popView configViews];
    [popView tf_showSlide:view direction:PopupDirectionBottom popupParam:param];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        CGFloat radius = 12; // 圆角大小
        CGRect rect = self.bounds;
        UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight; // 圆角位置
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = rect;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
        
        
    }
    return self;
}

- (void)onZipaiBtn:(UIButton *)btn {
    NSInteger index = btn.tag - tagIndex;
    if (index == (self.items.count - 1)) {
        [self onCancelBtn];
    }
    else {
        [self onCancelBtn];
        
        if (self.didAcitonIndex) {
            self.didAcitonIndex(index);
        }
    }
}


- (void)onCancelBtn {
    [self tf_hide];
}

- (void)configViews {
    
    for (int i=0; i< self.items.count; i++) {
        
        PopItemModel *model = self.items[i];
        
        UIButton *zipaiBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 54*i, ML_ScreenWidth, 54 + ((i == self.items.count-1)? + 5 : 0))];
        
        [zipaiBtn setTitle:model.title forState:UIControlStateNormal];
        if (model.textColor) {
            [zipaiBtn setTitleColor:model.textColor forState:UIControlStateNormal];
        }
        else {
            [zipaiBtn setTitleColor:UIColorHex(0x1A1A1A) forState:UIControlStateNormal];
        }
        
        if (model.imgName.length) {
            [zipaiBtn setImage:[UIImage imageNamed:model.imgName] forState:UIControlStateNormal];
        }
        
        zipaiBtn.titleLabel.font = model.font;
        if (!model.isTitle) {
            [zipaiBtn addTarget:self action:@selector(onZipaiBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        zipaiBtn.userInteractionEnabled = !model.isTitle;
        zipaiBtn.tag = tagIndex + i;
        if (i == self.items.count-1) {
            
//            zipaiBtn.height = 59;
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 5)];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
            [zipaiBtn addSubview:lineV];
            
        } else {
            if (i > 0) {
                
//                zipaiBtn.height = 54;
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 1)];
                lineV.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
                [zipaiBtn addSubview:lineV];
            }
            
//            zipaiBtn.height = 54;
        }
//        zipaiBtn.top = 12 + i * zipaiBtn.height;
//        zipaiBtn.left = 0;
//        zipaiBtn.width = ML_ScreenWidth;
        
        [self addSubview:zipaiBtn];
    }
    
}

@end


@implementation PopItemModel

- (instancetype)initTitle:(NSString *)title color:(UIColor *)color imgName:(NSString *)imgName font:(UIFont *)font
{
    self = [super init];
    if (self) {
        self.imgName = imgName;
        self.textColor = color;
        self.title = title;
        self.font = font;
    }
    return self;
}

+ (PopItemModel *)cancelModel {
    return [[PopItemModel alloc] initTitle:Localized(@"取消", nil) color:[UIColor colorWithHexString:@"#ff6fb3"] imgName:@"" font:[UIFont systemFontOfSize:14]];
}

+ (PopItemModel *)cancelWithTitle:(NSString *)title {
    return [[PopItemModel alloc] initTitle:title color:UIColorHex(0x808080) imgName:@"" font:[UIFont systemFontOfSize:14]];
}

+ (NSArray <PopItemModel *>*)ToFYInputInfoController {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:@"自拍" color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"从相册选取", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)toFYTabBarControllerNvshengRenzheng {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:@"完成认证或者成为会员再视频交友更放心" color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
    model1.isTitle = YES;
    
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:@"去认证" color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)ToYueBuzu {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:@"账户余额不足，请及时充值" color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
    model1.isTitle = YES;
    
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:@"去充值" color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelWithTitle:@"忍一忍"]];
    
}


+ (NSArray <PopItemModel *>*)toAlumQuanXian {
    
    NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
    NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
    if (!appName) appName = [infoDict valueForKey:@"CFBundleExecutable"];
    NSString *tipText = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Allow %@ to access your album in \"Settings -> Privacy -> Photos\""],appName];
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:tipText color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
    model1.isTitle = YES;
    
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:@"去设置" color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelModel]];
    
}


+ (NSArray <PopItemModel *>*)toFYShenFenZhengController {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:Localized(@"拍照", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"从相册选取", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)ToFYEditInfoController {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:Localized(@"相册", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"视频", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)toFYSearchInfoController {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:Localized(@"女", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"男", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)toCao {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:@"去留言" color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:@"去聊天" color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
//    if (WorkplaceApppManager.share.IsAppStatus) {
//        return @[model1, model2, [PopItemModel cancelModel]];
//    }
//    else {
        return @[model1, model2, [PopItemModel cancelModel]];
//    }
}

+ (NSArray <PopItemModel *>*)toWorkplaceApppFabuDTController {
    
//    FYPopItemModel *model1 = [[FYPopItemModel alloc] initTitle:@"分享给好友" color:UIColorHex(0xFF1637) imgName:@"" font:[UIFont systemFontOfSize:14]];
    PopItemModel *Model2 = [[PopItemModel alloc] initTitle:@"公开评论" color:UIColorHex(0x808080) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *Model3 = [[PopItemModel alloc] initTitle:@"私密评论" color:UIColorHex(0x808080) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
//    return @[model1, model2, model3, [FYPopItemModel cancelModel]];
    return @[Model2, Model3, [PopItemModel cancelModel]];
    
}


+ (NSArray <PopItemModel *>*)toFYChatController2 {
    
    PopItemModel *model = [[PopItemModel alloc] initTitle:@"确认清空聊天记录" color:UIColorHex(0xFF1637) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)toFYChatController3 {
    

    PopItemModel *model1 = [[PopItemModel alloc] initTitle:@"  视频通话" color:UIColorHex(0x1A1A1A) imgName:@"pop_video_icon" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:@"  语音通话" color:UIColorHex(0x1A1A1A) imgName:@"pop_audio_icon" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)toFYChatController4 {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:Localized(@"需要开通会员才能使用音视频功能", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
    model1.isTitle = YES;
    
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"开通会员", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelWithTitle:Localized(@"取消", nil)]];
    
}

+ (NSArray <PopItemModel *>*)FYMessageController {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:Localized(@"删除会话", nil) color:UIColorHex(0x1A1A1A) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"清空聊天记录并删除", nil) color:UIColorHex(0xFF1637) imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, [PopItemModel cancelModel]];
    
}


+ (NSArray <PopItemModel *>*)popAudioMoreSetting {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:@"扬声器" color:UIColorHex(0x808080) imgName:@"组件-搭讪成功备份 6" font:[UIFont systemFontOfSize:12]];
    model1.selImgName = @"组件-搭讪成功备份 6-1";
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:@"麦克风" color:UIColorHex(0x808080) imgName:@"组件-搭讪成功备份 5" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    model2.selImgName = @"组件-搭讪成功备份 5-1";
    PopItemModel *model3 = [[PopItemModel alloc] initTitle:@"挂断" color:UIColorHex(0x808080) imgName:@"组件-搭讪成功备份 7" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, model3];
    
}

+ (NSArray <PopItemModel *>*)popShareItem {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:@"  微信好友" color:UIColorHex(0x808080) imgName:@"wx" font:[UIFont systemFontOfSize:14]];

    PopItemModel *model2 = [[PopItemModel alloc] initTitle:@"  朋友圈" color:UIColorHex(0x808080) imgName:@"pyq" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model3 = [[PopItemModel alloc] initTitle:@"  复制链接" color:UIColorHex(0x808080) imgName:@"xz" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, model3, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)ToFYProfileControllerWithIsla:(BOOL)isLahei {
    
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:Localized(@"清除聊天记录", nil) color:[UIColor colorWithHexString:@"#333333"] imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"举报", nil) color:[UIColor colorWithHexString:@"#333333"] imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model3 = [[PopItemModel alloc] initTitle:isLahei?@"移出黑名单":Localized(@"拉黑", nil) color:[UIColor colorWithHexString:@"#333333"] imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model1, model2, model3, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)TwoToFYProfileControllerWithIsla:(BOOL)isLahei {
    
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"举报", nil) color:[UIColor colorWithHexString:@"#333333"] imgName:@"jubao" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model3 = [[PopItemModel alloc] initTitle:isLahei?@"移出黑名单":Localized(@"拉黑", nil) color:[UIColor colorWithHexString:@"#333333"] imgName:@"lahei" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    return @[model2, model3, [PopItemModel cancelModel]];
    
}

+ (NSArray <PopItemModel *>*)toFYChatController {
    
    PopItemModel *model0 = [[PopItemModel alloc] initTitle:@"查看主页" color:kZhuColor imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:Localized(@"举报", nil) color:[UIColor colorWithHexString:@"#333333"] imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"拉黑", nil) color:[UIColor colorWithHexString:@"#333333"] imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];

    return @[model0, model1, model2, [PopItemModel cancelModel]];
}

+ (NSArray <PopItemModel *>*)toInfoController {
    
    PopItemModel *model0 = [[PopItemModel alloc] initTitle:@"查看主页" color:kZhuColor imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:Localized(@"拉黑", nil) color:[UIColor colorWithHexString:@"#333333"] imgName:@"" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];

    return @[model0, model2, [PopItemModel cancelModel]];
}

+ (NSArray <PopItemModel *>*)popVideoMoreSetting {
    
    PopItemModel *model2 = [[PopItemModel alloc] initTitle:@"麦克风" color:UIColorHex(0x808080) imgName:@"组件-搭讪成功备份 5-1" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    model2.selImgName = @"组件-搭讪成功备份 5";
    PopItemModel *model1 = [[PopItemModel alloc] initTitle:@"扬声器" color:UIColorHex(0x808080) imgName:@"组件-搭讪成功备份 6" font:[UIFont systemFontOfSize:12]];
    model1.selImgName = @"组件-搭讪成功备份 6-1";
    PopItemModel *model3 = [[PopItemModel alloc] initTitle:@"挂断" color:UIColorHex(0x808080) imgName:@"组件-搭讪成功备份 7" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    PopItemModel *model0 = [[PopItemModel alloc] initTitle:@"摄像头" color:UIColorHex(0x808080) imgName:@"组件-搭讪成功备份 5(1)-1" font:[UIFont systemFontOfSize:12]];
    model0.selImgName = @"组件-搭讪成功备份 5(1)";
    
    return @[model1, model2, model3, model0];
    
}

@end
