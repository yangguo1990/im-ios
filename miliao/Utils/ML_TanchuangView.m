

#import "ML_TanchuangView.h"
#import "UIViewController+CurrentShowVC.h"
#import "ML_ChongVC.h"
#import "UIButton+ML.h"

@interface ML_TanchuangView()
@property (nonatomic, strong) NSArray *winningArr;
@property (nonatomic, assign) BOOL isDiCha;
@property (nonatomic, assign) BOOL isBed;
@property (nonatomic, strong) NSMutableArray *labelIds;
@property (nonatomic, assign) ML_TanchuangViewType type;
@property (nonatomic, assign) NSDictionary *pDic;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,strong)UIImageView *bgContentView;
@property(nonatomic,strong)UIImageView *v1;
@property(nonatomic,strong)UIButton *lovebt;
@property(nonatomic,strong)UIButton*unlovebt;
@property (nonatomic, strong) UITextView *textV;
@end

@implementation ML_TanchuangView

+ (void)showWithTitle:(NSString *)str time:(int)miao
{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 201) {
            [view removeFromSuperview];
        }
    }
    
    __block UILabel *conterV = [[UILabel alloc] initWithFrame:CGRectMake(0, UIScreenHeight / 2 - 25, UIScreenWidth, 50)];
    conterV.tag = 201;
    conterV.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    conterV.text = str;
    conterV.textAlignment = NSTextAlignmentCenter;
    conterV.numberOfLines = 0;
    conterV.font = kGetFont(16);
    conterV.textColor = kGetColor(@"#FFFFFF");
    conterV.layer.cornerRadius = 5;
    conterV.layer.masksToBounds = YES;
    CGSize size = [conterV.text sizeWithFont:conterV.font maxSize:CGSizeMake(UIScreenWidth - 100, 100)];
    conterV.frame = CGRectMake(UIScreenWidth / 2 - (size.width + 15) / 2, UIScreenHeight / 2 - (size.height + 15) / 2 - 40, size.width + 15, size.height + 15);
    [[UIApplication sharedApplication].keyWindow addSubview:conterV];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:conterV];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(miao/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{

        [conterV removeFromSuperview];
    });
    
    
}

+ (void)showWithTitle:(NSString *)str
{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 201) {
            [view removeFromSuperview];
        }
    }
    
    __block UILabel *conterV = [[UILabel alloc] initWithFrame:CGRectMake(0, UIScreenHeight / 2 - 25, UIScreenWidth, 50)];
    conterV.tag = 201;
    conterV.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    conterV.text = str;
    conterV.textAlignment = NSTextAlignmentCenter;
    conterV.numberOfLines = 0;
    conterV.font = kGetFont(16);
    conterV.textColor = kGetColor(@"#FFFFFF");
    conterV.layer.cornerRadius = 5;
    conterV.layer.masksToBounds = YES;
    CGSize size = [conterV.text sizeWithFont:conterV.font maxSize:CGSizeMake(UIScreenWidth - 100, 100)];
    conterV.frame = CGRectMake(UIScreenWidth / 2 - (size.width + 15) / 2, UIScreenHeight / 2 - (size.height + 15) / 2 - 40, size.width + 15, size.height + 15);
    [[UIApplication sharedApplication].keyWindow addSubview:conterV];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:conterV];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{

        [conterV removeFromSuperview];
    });
    
    
}

+ (instancetype)shareInstance {
    static ML_TanchuangView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ML_TanchuangView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight)];

    });
    return instance;
//    return [[ML_TanchuangView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenHeight)];
}

+ (void)conterVHidden
{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 201) {
            [view removeFromSuperview];
        }
    }
}

- (void)endJianTapped
{
    if (_isBgHideView) {
        [self hideView];
    }
}

- (void)handlePanGesture
{
    [self endEditing:YES];
}

#pragma mark - init Method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        
        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture)];
        [self addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endJianTapped)];
        [self addGestureRecognizer:tap];

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.dataArr = [NSMutableArray array];
    }
    return self;
}


- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    BOOL isAddObj = YES;
    for (NSDictionary *dataDic in self.dataArr) {
        if ([dataDic[@"type"] intValue] == [dic[@"type"] intValue]) { // 上一个同类型的view还没有弹就不需要再添加
            isAddObj = NO;
            break;
        }
    }
    
    if (isAddObj) {
        [self.dataArr addObject:dic];
    }
    
    
    if (self.dataArr.count == 1) { // 立刻弹出第一个
        
        NSDictionary *dic = [self.dataArr firstObject];
        
        [self settingUIWithDic:dic];
    }
}

- (void)settingUIWithDic:(NSDictionary *)dic
{
    
    self.isBgHideView = NO;
    
    // 防止弹出时呼出键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [[UIViewController topShowViewController].view endEditing:YES];
    });
    
    
    self.type = [dic[@"type"] intValue];
    
    self.bgContentView = [[UIImageView alloc] init];
    self.bgContentView.userInteractionEnabled = YES;
    [self addSubview:self.bgContentView];
    
    if ([dic[@"imgStr"] containsString:@"http"] || [dic[@"imgStr"] containsString:@"https"]) {
        
        kSelf;
        [self.bgContentView sd_setImageWithURL:kGetUrlPath(dic[@"imgStr"]) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

            weakself.bgContentView.frame = CGRectMake(ML_ScreenWidth / 2 - image.size.width / 2 / 2, ML_ScreenHeight / 2 - image.size.height / 2 / 2, image.size.width / 2, image.size.height / 2);
            
            switch ([dic[@"type"] intValue]) {
                    
                case ML_TanchuangViewType_zadan:
                {
                    weakself.isDiCha = YES;
                    
                    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, weakself.bgContentView.height - 80, weakself.bgContentView.width - 80, 50)];
                    [goBtn addTarget:weakself action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [weakself.bgContentView addSubview:goBtn];
                    
                    break;
                }
                case ML_TanchuangViewType_jianliDone:
                {
                    NSArray *arr = dic[@"data"];
                    
                    UIImageView *avImgV = [[UIImageView alloc] initWithFrame:CGRectMake(weakself.bgContentView.width / 2 - 38, weakself.bgContentView.height / 2 - 100, 76, 76)];
                    [avImgV sd_setImageWithURL:kGetUrlPath([arr objectAtIndex:1])];
                    avImgV.layer.masksToBounds = YES;
                    avImgV.layer.cornerRadius = 38;
                    [weakself.bgContentView addSubview:avImgV];
                    
                    
                    UILabel *conterV = [[UILabel alloc] initWithFrame:CGRectMake(38, weakself.bgContentView.height / 2 + 20, weakself.bgContentView.width - 38 * 2, 40)];
                    conterV.text = dic[@"title"];
                    conterV.textAlignment = NSTextAlignmentCenter;
                    conterV.numberOfLines = 0;
                    conterV.font = kGetFont(16);
                    conterV.text = [arr objectAtIndex:2];
                    conterV.textColor = kGetColor(@"#333333");
                    [weakself.bgContentView addSubview:conterV];
                    
                    UIButton *chaBtn = [[UIButton alloc] initWithFrame:CGRectMake(23, weakself.bgContentView.height - 60, 100, 40)];
//                    [chaBtn setImage:kGetImage(@"liCha") forState:UIControlStateNormal];
                    [chaBtn addTarget:weakself action:@selector(chaBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [weakself.bgContentView addSubview:chaBtn];
                    
                    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(weakself.bgContentView.width - 23 - 100, weakself.bgContentView.height - 60, 100, 40)];
                    [goBtn addTarget:weakself action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [weakself.bgContentView addSubview:goBtn];
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            
            
            [weakself show];
        }];
    } else {
        UIImage *image = kGetImage(dic[@"imgStr"]);
        self.bgContentView.image = image;
        self.bgContentView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgContentView.frame = CGRectMake(ML_ScreenWidth / 2 - image.size.width / 2, ML_ScreenHeight / 2 - image.size.height / 2, image.size.width, image.size.height);
        self.bgContentView.layer.cornerRadius = 10;
        self.bgContentView.layer.masksToBounds = YES;
        
        switch ([dic[@"type"] intValue]) {

            case ML_TanchuangViewType_MsgListVCMore:
            {
                
                self.isBgHideView = YES;
                
                self.bgContentView.frame = CGRectMake(ML_ScreenWidth - 16 - 150, ML_NavViewHeight, 150, 108);
                self.bgContentView.backgroundColor = kGetColor(@"#ffffff");
                [self addSubview:self.bgContentView];
                
                UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bgContentView.width, 53.5)];
                [btn1 setTitle:Localized(@"一键删除", nil) forState:UIControlStateNormal];
                btn1.titleLabel.font = kGetFont(16);
                [btn1 setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                btn1.tag = 1;
                [btn1 addTarget:self action:@selector(ML_TanchuangViewType_MsgListVCMoreClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn1];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1.frame) + 0.7, self.bgContentView.width, 0.5)];
                [self.bgContentView addSubview:line];
                line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
                
                UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 53.5, self.bgContentView.width, 53.5)];
                [btn2 setTitle:Localized(@"一键已读", nil) forState:UIControlStateNormal];
                btn2.tag = 2;
                btn2.titleLabel.font = kGetFont(16);
                [btn2 setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                [btn2 addTarget:self action:@selector(ML_TanchuangViewType_MsgListVCMoreClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn2];
                
                break;
            }
            case ML_TanchuangViewType_TishiImg:
            {
                
                UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bgContentView.height - 60, self.bgContentView.width, 60)];
                [btn1 setTitle:Localized(@"我已知晓本次内容", nil) forState:UIControlStateNormal];
                [btn1 setTitleColor:[UIColor colorWithHexString:@"#eeeeee"] forState:UIControlStateNormal];
                btn1.titleLabel.font = kGetFont(18);
                btn1.backgroundColor = kLineVColor;
                [btn1 setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                [btn1 addTarget:self action:@selector(ML_TanchuangViewType_MsgListVCMoreClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn1];
                
                ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"msgId" : dic[@"data"]} urlStr:@"push/hasPopUpPushMessage"];

                kSelf;
                [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                    
                } error:^(MLNetworkResponse *response) {

                } failure:^(NSError *error) {
                    
                }];
                
                break;
            }
            case ML_TanchuangViewType_chongzhi:
            {
                CGFloat kuan = ML_ScreenWidth - 80;
                
                UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kuan, 50)];
                t1.text = Localized(@"操作提示", nil);
                t1.textAlignment = NSTextAlignmentCenter;
                t1.numberOfLines = 0;
                t1.font = kGetFont(18);
                t1.textColor = kGetColor(@"#333333");
                [self.bgContentView addSubview:t1];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(t1.frame), kuan - 20, 1)];
                [self.bgContentView addSubview:line];
                line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
                
                
                UILabel *conterV = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, kuan - 54, 30)];
                conterV.text = dic[@"data"];
                conterV.textAlignment = NSTextAlignmentCenter;
                conterV.numberOfLines = 0;
                conterV.font = kGetFont(14);
                conterV.textColor = kGetColor(@"#999999");
                CGSize sizeC = [conterV.text sizeWithFont:conterV.font maxSize:CGSizeMake(kuan - 54, 100)];
                [self.bgContentView addSubview:conterV];
//                CGRect frame = conterV.frame;
                conterV.frame = CGRectMake((kuan - sizeC.width) / 2, CGRectGetMaxY(line.frame) + 20, sizeC.width, sizeC.height);
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(conterV.frame) + 20, kuan / 2 - 0.5, 60)];
                [btn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                btn.titleLabel.font = kGetFont(16);
                [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                btn.tag = 0;
                [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn];
                
                UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn.width + 0.5, btn.y, btn.width, 60)];
                [btn2 setTitle:Localized(@"充值", nil) forState:UIControlStateNormal];
                btn2.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                [btn2 setTitleColor:kZhuColor forState:UIControlStateNormal];
                btn2.titleLabel.font = kGetFont(16);
                btn2.tag = 1;
                [btn2 addTarget:self action:@selector(onChuangChongzhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn2];
                
                self.bgContentView.backgroundColor = [UIColor whiteColor];
                CGFloat gao = CGRectGetMaxY(btn.frame);
                self.bgContentView.frame = CGRectMake((ML_ScreenWidth - kuan) / 2, ML_ScreenHeight / 2 - gao / 2, kuan, gao);
                break;
                
            }
            case ML_TanchuangViewType_lahei:
            {
                self.pDic = dic[@"pDic"];
                CGFloat kuan = ML_ScreenWidth - 80;
                
                UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kuan, 50)];
                t1.text = Localized(@"操作提示", nil);
                t1.textAlignment = NSTextAlignmentCenter;
                t1.numberOfLines = 0;
                t1.font = kGetFont(18);
                t1.textColor = kGetColor(@"#333333");
                [self.bgContentView addSubview:t1];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(t1.frame), kuan - 20, 1)];
                [self.bgContentView addSubview:line];
                line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
                
                
                UILabel *conterV = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, kuan - 54, 30)];
                conterV.text = dic[@"data"];
                conterV.textAlignment = NSTextAlignmentCenter;
                conterV.numberOfLines = 0;
                conterV.font = kGetFont(14);
                conterV.textColor = kGetColor(@"#999999");
                CGSize sizeC = [conterV.text sizeWithFont:conterV.font maxSize:CGSizeMake(kuan - 54, 100)];
                [self.bgContentView addSubview:conterV];
                CGRect frame = conterV.frame;
                conterV.frame = CGRectMake((kuan - sizeC.width) / 2, CGRectGetMaxY(line.frame) + 20, sizeC.width, sizeC.height);
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(conterV.frame) + 20, kuan / 2 - 0.5, 60)];
                [btn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                btn.titleLabel.font = kGetFont(16);
                [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                btn.tag = 0;
                [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn];
                
                UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn.width + 0.5, btn.y, btn.width, 60)];
                [btn2 setTitle:Localized(@"确定", nil) forState:UIControlStateNormal];
                btn2.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                [btn2 setTitleColor:kZhuColor forState:UIControlStateNormal];
                btn2.titleLabel.font = kGetFont(16);
                btn2.tag = 1;
                [btn2 addTarget:self action:@selector(onLaheizhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn2];
                
                self.bgContentView.backgroundColor = [UIColor whiteColor];
                CGFloat gao = CGRectGetMaxY(btn.frame);
                self.bgContentView.frame = CGRectMake((ML_ScreenWidth - kuan) / 2, ML_ScreenHeight / 2 - gao / 2, kuan, gao);
                break;
            }
            case ML_TanchuangViewType_pingjia:
            {
                
                [self bringSubviewToFront:self.bgContentView];
                
                self.pDic = dic[@"data"];
                NSDictionary *hostInfoDic = self.pDic[@"hostInfo"];
                NSDictionary *callInfoDic = self.pDic[@"callInfo"];;
                CGFloat kuan = ML_ScreenWidth - 32;
    
                
                UIImageView *v1 = [[UIImageView alloc] initWithImage:kGetImage(@"Group 319")];
                v1.frame=CGRectMake(0, 0, 80*mWidthScale, 80*mWidthScale);
                v1.tag = 11;
                v1.layer.masksToBounds = YES;
                [self.bgContentView addSubview:v1];
                self.v1 = v1;
                
                UIImageView *v0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80*mWidthScale, 80*mWidthScale)];
                v0.tag = 21;
                [v0 sd_setImageWithURL:kGetUrlPath(hostInfoDic[@"hostIcon"])];
                v0.contentMode = UIViewContentModeScaleAspectFill;
                v0.layer.masksToBounds = YES;
                v0.layer.cornerRadius = 40*mWidthScale;
                [v1 addSubview:v0];
                
                UILabel *v2 = [[UILabel alloc] initWithFrame:CGRectMake(112*mWidthScale, 23*mHeightScale, 260*mWidthScale, 24*mHeightScale)];
                v2.text = hostInfoDic[@"hostName"];
                v2.tag = 12;
                v2.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
                v2.textAlignment = NSTextAlignmentLeft;
                v2.textColor = kGetColor(@"#000000");
                [self.bgContentView addSubview:v2];
                
                
                UIButton *v3 = [[UIButton alloc] initWithFrame:CGRectMake(105*mWidthScale, 50*mHeightScale, 80*mWidthScale, 20*mHeightScale)];
                [v3 setImage:kGetImage(@"ID") forState:UIControlStateNormal];
                [v3 setTitle:[NSString stringWithFormat:@" %@", hostInfoDic[@"hostId"]] forState:UIControlStateNormal];
                v3.titleLabel.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
                v3.tag = 13;
                [v3 setTitleColor:kGetColor(@"#8c8c8c") forState:UIControlStateNormal];
                [self.bgContentView addSubview:v3];
                
                UILabel *v4 = [[UILabel alloc] initWithFrame:CGRectMake(112*mWidthScale, 72*mHeightScale, 100*mWidthScale, 20*mHeightScale)];
                v4.text = [NSString stringWithFormat:@"%@:%@%@", Localized(@"通话", nil), callInfoDic[@"totalTime"], Localized(@"分钟", nil)];
                v4.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
                v4.tag = 14;
                v4.textAlignment = NSTextAlignmentLeft;
                v4.textColor = kGetColor(@"#8c8c8c");
                [self.bgContentView addSubview:v4];
                
                UILabel *v5 = [[UILabel alloc] initWithFrame:CGRectMake(220*mWidthScale, 72*mHeightScale, 100*mWidthScale, 20*mHeightScale)];
                v5.text = [NSString stringWithFormat:@"%@:%@%@", Localized(@"消费", nil), callInfoDic[@"totalConsume"], Localized(@"金币", nil)];
                v5.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
                v5.tag = 15;
                v5.textAlignment = NSTextAlignmentLeft;
                v5.textColor = kGetColor(@"#8c8c8c");
                [self.bgContentView addSubview:v5];
                
                
//                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(v5.frame) + 10, kuan - 70, 1)];
//                [self.bgContentView addSubview:line];
//                line.tag = 17;
//                line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
                UILabel *xhlabel=[[UILabel alloc]initWithFrame:CGRectMake(16*mWidthScale, 112*mHeightScale, 200, 21*mHeightScale)];
                xhlabel.text=@"你喜欢该主播吗?";
                xhlabel.textColor=kGetColor(@"000000");
                xhlabel.font=[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
                [self.bgContentView addSubview:xhlabel];
                
                UIButton *loveBtn = [[UIButton alloc] initWithFrame:CGRectMake(16*mWidthScale, 145*mHeightScale, 50, 90)];
                self.lovebt=loveBtn;
                [loveBtn setTitle:Localized(@"喜欢", nil) forState:UIControlStateNormal];//
                [loveBtn setImage:kGetImage(@"like_s") forState:UIControlStateSelected];
                [loveBtn setImage:kGetImage(@"like") forState:UIControlStateNormal];
                [loveBtn setTitleColor:[UIColor colorWithHexString:@"#FB4240"] forState:UIControlStateSelected];
                [loveBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                [loveBtn setImageEdgeInsets:UIEdgeInsetsMake(-40*mHeightScale, 0, 0, 0)];
                [loveBtn setTitleEdgeInsets:UIEdgeInsetsMake(28*mWidthScale, -50*mWidthScale, 0, 0)];
               
                loveBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
                loveBtn.tag = 0;
                loveBtn.selected = YES;
//                [loveBtn setIconInTopWithSpacing:5];
                [loveBtn addTarget:self action:@selector(loveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:loveBtn];
                
                UIButton *unLoveBtn = [[UIButton alloc] initWithFrame:CGRectMake(104*mWidthScale, 145*mHeightScale, 50, 90)];
                self.unlovebt=unLoveBtn;
                [unLoveBtn setTitle:Localized(@"不喜欢", nil) forState:UIControlStateNormal];//
                [unLoveBtn setImage:kGetImage(@"Nlike") forState:UIControlStateNormal];
                [unLoveBtn setImage:kGetImage(@"Nlike_s") forState:UIControlStateSelected];
                [unLoveBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                [unLoveBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateSelected];
                [unLoveBtn setImageEdgeInsets:UIEdgeInsetsMake(-40*mHeightScale, 0, 0, 0)];
                [unLoveBtn setTitleEdgeInsets:UIEdgeInsetsMake(28*mWidthScale, -48*mWidthScale, 0, 0)];
                unLoveBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
                unLoveBtn.tag = 1;
//                [unLoveBtn setIconInTopWithSpacing:5];
                [unLoveBtn addTarget:self action:@selector(loveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:unLoveBtn];
                
                
                UILabel *v6 = [[UILabel alloc] initWithFrame:CGRectMake(16*mWidthScale, 220*mHeightScale, 200, 21*mHeightScale)];
                v6.text = Localized(@"评价下该主播", nil);
                v6.tag = 16;
                v6.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
                v6.textAlignment = NSTextAlignmentLeft;
                v6.textColor = kGetColor(@"#000000");
                [self.bgContentView addSubview:v6];
                
                NSArray *tags2 = self.pDic[@"goodLabels"];
                CGFloat maxX = 0;
                CGFloat maxY = 0;
                int i = 0;
                int row = 0;
                int col = 0;
                UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(v6.frame) + 5, 343*mWidthScale, 80*mHeightScale)];
                scr.tag = 10020;
                [self.bgContentView addSubview:scr];
                
                if (!kisCH) {
                    v6.hidden = YES;
                    scr.hidden = YES;
                    tags2 = nil;
                    maxY = v6.y;
                }
                
                for (NSDictionary *dic in tags2) {
                    NSString *tagStr = dic[@"name"];
                    CGSize size = [tagStr sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 30)];
                    size.width += 30;
                    UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(maxX, maxY + row * (6 + 30), size.width, 30)];
                    
                    [label addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    if (CGRectGetMaxX(label.frame) >= (kuan-32)) {
                        maxX = 0;
                        col = 0;
                        row += 1;
                    }
                    label.frame = CGRectMake(maxX, maxY + row * (6 + 32), size.width, 32);
                    
                    if (CGRectGetMaxX(label.frame) < (kuan-32)) {
                        col += 1;
                    }
                    
                    label.tag = 10000 + i;
                    [label setTitle:tagStr forState:UIControlStateNormal];
                    label.titleLabel.textAlignment = NSTextAlignmentCenter;
//                    label.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
                    label.layer.cornerRadius = 15;
                    label.layer.borderColor= [UIColor colorWithHexString:@"#dddddd"].CGColor;
                    label.layer.borderWidth = 0.5;
                    label.layer.masksToBounds = YES;
                    [label setTitleColor:[UIColor colorWithHexString:@"#8c8c8c"] forState:UIControlStateNormal];
                    label.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
                    [scr addSubview:label];
                    maxX = CGRectGetMaxX(label.frame) + 6;
                    
                    if (i == (tags2.count-1)) {
                        maxY = CGRectGetMaxY(label.frame);
                    }
                    
                    i++;
                    
                }
                self.labelIds = [NSMutableArray array];
                [scr setContentSize:CGSizeMake(0, maxY)];
                UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(16*mWidthScale, 341*mHeightScale, 343*mWidthScale, 44*mHeightScale)];
                [btn2 setTitle:Localized(@"确定", nil) forState:UIControlStateNormal];
                btn2.tag = 100000;
                btn2.backgroundColor = kZhuColor;
                btn2.layer.cornerRadius=22*mHeightScale;
                [btn2 setTitleColor:kGetColor(@"#000000") forState:UIControlStateNormal];
                btn2.titleLabel.font = kGetFont(16);
                [btn2 addTarget:self action:@selector(donBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn2];
                
                self.bgContentView.tag = 33;
                self.bgContentView.backgroundColor = [UIColor whiteColor];
                CGFloat gao = CGRectGetMaxY(btn2.frame);
                self.bgContentView.frame = CGRectMake(0, 387, 375, 425);
                v1.frame = CGRectMake(16*mWidthScale, 16*mHeightScale,80*mWidthScale,80*mWidthScale);
                v1.layer.cornerRadius = v1.width / 2;
                
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(340*mWidthScale, 5, 30, 30)];
                [btn setImage:kGetImage(@"icon_guanbi_22_666_nor") forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn];
                
                
                break;
            }
            case ML_TanchuangViewType_Duihuan:
            {
                self.pDic = dic[@"data"];
                CGFloat kuan = ML_ScreenWidth - 80;
                
                UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kuan, 50)];
                t1.text = Localized(@"操作提示", nil);
                t1.textAlignment = NSTextAlignmentCenter;
                t1.numberOfLines = 0;
                t1.font = kGetFont(18);
                t1.textColor = kGetColor(@"#333333");
                [self.bgContentView addSubview:t1];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(t1.frame), kuan - 20, 1)];
                [self.bgContentView addSubview:line];
                line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
                
                
                UILabel *conterV = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, kuan - 54, 30)];
//                conterV.text = [NSString stringWithFormat:@"是否消耗%@积分来兑换%@金币", dic[@"data"][@"credit"], dic[@"data"][@"coin"]];
                conterV.text = [NSString stringWithFormat:Localized(@"是否消耗积分来兑换金币", nil)];
                conterV.textAlignment = NSTextAlignmentCenter;
                conterV.numberOfLines = 0;
                conterV.font = kGetFont(14);
                conterV.textColor = kGetColor(@"#999999");
                CGSize sizeC = [conterV.text sizeWithFont:conterV.font maxSize:CGSizeMake(kuan - 54, 100)];
                [self.bgContentView addSubview:conterV];
//                CGRect frame = conterV.frame;
                conterV.frame = CGRectMake((kuan - sizeC.width) / 2, CGRectGetMaxY(line.frame) + 20, sizeC.width, sizeC.height);
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(conterV.frame) + 20, kuan / 2 - 0.5, 60)];
                [btn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                btn.titleLabel.font = kGetFont(16);
                [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                btn.tag = 0;
                [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn];
                
                UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn.width + 0.5, btn.y, btn.width, 60)];
                [btn2 setTitle:Localized(@"确定", nil) forState:UIControlStateNormal];
                btn2.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                [btn2 setTitleColor:kZhuColor forState:UIControlStateNormal];
                btn2.titleLabel.font = kGetFont(16);
                btn2.tag = 1;
                [btn2 addTarget:self action:@selector(onDuihuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn2];
                
                self.bgContentView.backgroundColor = [UIColor whiteColor];
                CGFloat gao = CGRectGetMaxY(btn.frame);
                self.bgContentView.frame = CGRectMake((ML_ScreenWidth - kuan) / 2, ML_ScreenHeight / 2 - gao / 2, kuan, gao);
                break;
            }
            case ML_TanchuangViewType_DongBao:
            {
                
                CGFloat kuan = ML_ScreenWidth - 80;
                
                UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kuan, 50)];
                t1.text = Localized(@"操作提示", nil);
                t1.textAlignment = NSTextAlignmentCenter;
                t1.numberOfLines = 0;
                t1.font = kGetFont(18);
                t1.textColor = kGetColor(@"#333333");
                [self.bgContentView addSubview:t1];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(t1.frame), kuan - 20, 1)];
                [self.bgContentView addSubview:line];
                line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
                
                
                UILabel *conterV = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, kuan - 54, 30)];
                conterV.text = dic[@"data"];
                conterV.textAlignment = NSTextAlignmentCenter;
                conterV.numberOfLines = 0;
                conterV.font = kGetFont(14);
                conterV.textColor = kGetColor(@"#999999");
                CGSize sizeC = [conterV.text sizeWithFont:conterV.font maxSize:CGSizeMake(kuan - 54, 100)];
                [self.bgContentView addSubview:conterV];
//                CGRect frame = conterV.frame;
                conterV.frame = CGRectMake((kuan - sizeC.width) / 2, CGRectGetMaxY(line.frame) + 20, sizeC.width, sizeC.height);
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(conterV.frame) + 20, kuan / 2 - 0.5, 60)];
                [btn setTitle:Localized(@"取消", nil) forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                btn.titleLabel.font = kGetFont(16);
                [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                btn.tag = 0;
                [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn];
                
                UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn.width + 0.5, btn.y, btn.width, 60)];
                [btn2 setTitle:Localized(@"确定", nil) forState:UIControlStateNormal];
                btn2.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                [btn2 setTitleColor:kZhuColor forState:UIControlStateNormal];
                btn2.titleLabel.font = kGetFont(16);
                btn2.tag = 1;
                [btn2 addTarget:self action:@selector(quedingBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [self.bgContentView addSubview:btn2];
                
                self.bgContentView.backgroundColor = [UIColor whiteColor];
                CGFloat gao = CGRectGetMaxY(btn.frame);
                self.bgContentView.frame = CGRectMake((ML_ScreenWidth - kuan) / 2, ML_ScreenHeight / 2 - gao / 2, kuan, gao);
                break;
            }
            default:
                break;
        }
        
        [self show];
    }
}

- (void)quedingBtnClick
{
    if (self.ML_TanchuangClickBlock) {
        self.ML_TanchuangClickBlock(1);
    }
    [self hideView];
}

- (void)onDuihuanBtnClick
{
    kSelf;
    ML_CommonApi *api3 = [[ML_CommonApi alloc] initWithPDic:@{@"packageId" : self.pDic[@"id"]} urlStr:@"wallet/exchangePackage"];
    [api3 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
  
        kplaceToast(@"兑换中，正在审核！");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
        [weakself hideView];
    } error:^(MLNetworkResponse *response) {
        [weakself hideView];
    } failure:^(NSError *error) {
        [weakself hideView];
    }];
}

- (void)tagBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        btn.backgroundColor = [UIColor colorWithHexString:@"#ffdbdb" alpha:1];
        [btn setTitleColor:kGetColor(@"fb4240") forState:UIControlStateNormal];
        btn.layer.borderColor=kGetColor(@"fb4240").CGColor;
    } else {
        
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithHexString:@"#8c8c8c"] forState:UIControlStateNormal];
        btn.layer.borderColor=kGetColor(@"dddddd").CGColor;
    }
    
    NSArray *tags2 = self.pDic[@"goodLabels"];
    
    if (self.isBed == 1) {
        
        tags2 = self.pDic[@"badLabels"];
    }
    NSInteger tag = btn.tag - 10000;
    NSDictionary *dic = tags2[tag];
    if (btn.selected) {
        [self.labelIds addObject:[NSString stringWithFormat:@"%@", dic[@"id"]?:@""]];
    } else {
        for (NSString *idStr in self.labelIds) {
            if ([idStr isEqualToString:[NSString stringWithFormat:@"%@", dic[@"id"]?:@""]]) {
                [self.labelIds removeObject:idStr];
                break;
            }
        }
    }
    
}

- (void)donBtnClick
{
    if (self.labelIds.count > 3) {
        kplaceToast(Localized(@"选择评价标签不能多于3个", nil));
        return;
    }
    
    if (!self.labelIds.count && kisCH) {
        kplaceToast(Localized(@"请选择评价标签", nil));
        return;
    }
    NSString *jsonString = @"";
    int i = 0;
    for (NSString *idStr in self.labelIds) {
        if ( i == 0) {
            jsonString = [NSString stringWithFormat:@"%@", idStr];
        } else {
            jsonString = [NSString stringWithFormat:@"%@,%@", jsonString,idStr];
        }
        i++;
    }

    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"channelId" : self.pDic[@"channelId"], @"type" : @(self.isBed), @"labelIds" : jsonString} urlStr:@"im/callEvaluate"];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        kplaceToast(Localized(@"评价成功！", nil));
    } error:^(MLNetworkResponse *response) {

    } failure:^(NSError *error) {
        
    }];
    
    [self hideView];
}

- (void)loveBtnClick:(UIButton *)btn
{
    if (self.isBed == btn.tag) {
        return;
    }
    
    self.isBed = btn.tag;
    
//    int j = 0;
//    for (UIButton *loveBtn in btn.superview.subviews) {
//        if (loveBtn.tag == 0 || loveBtn.tag == 1) {
//
//            loveBtn.selected = NO;
//            j ++;
//            if (j >= 2) {
//                break;
//            }
//        }
//    }
    self.lovebt.selected=NO;
    self.unlovebt.selected=NO;
    btn.selected = YES;
    
    if (!kisCH) {
        return;
    }
    
    UIView *v2 = nil;
    UIView *v3 = nil;
    UIView *v4 = nil;
    UIView *v5 = nil;
    UIView *v6 = nil;
    UIView *lineV = nil;
    
    
    UIView *btn0 = nil;
    
    UIView *btn1 = nil;
    
    for (UIView *view in btn.superview.subviews) {
        if (view.tag >= 10000) {
            [view removeFromSuperview];
        }
        
        if (view.tag == 12) {
            v2 = view;
        } else if (view.tag == 13) {
            v3 = view;
        } else if (view.tag == 14) {
            v4 = view;
        }else if (view.tag == 15) {
            v5 = view;
        }else if (view.tag == 16) {
            v6 = view;
        }else if (view.tag == 17) {
            lineV = view;
        }else if (view.tag == 0) {
            btn0 = view;
        }else if (view.tag == 1) {
            btn1 = view;
        } else if (view.tag == 100000) {
            [view removeFromSuperview];
        }
    }
    
    [self.labelIds removeAllObjects];
    
    NSArray *tags2 = self.pDic[@"goodLabels"];
    
    if (btn.tag == 1) {
        
        tags2 = self.pDic[@"badLabels"];
    }
    
    CGFloat kuan = ML_ScreenWidth - 32;
    CGFloat maxX = 0;
    CGFloat maxY = 0;
    int i = 0;
    int row = 0;
    int col = 0;
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(v6.frame) + 5, kuan-32, 80)];
    scr.tag = 10020;
    [self.bgContentView addSubview:scr];
    for (NSDictionary *dic in tags2) {
        NSString *tagStr = dic[@"name"];
        CGSize size = [tagStr sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 30)];
        size.width += 30;
        UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(maxX, maxY + row * (6 + 30), size.width, 30)];
        
        [label addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (CGRectGetMaxX(label.frame) >= (kuan-32)) {
            maxX = 0;
            col = 0;
            row += 1;
        }
        label.frame = CGRectMake(maxX, maxY + row * (6 + 30), size.width, 30);
        
        if (CGRectGetMaxX(label.frame) < (kuan-32)) {
            col += 1;
        }
        
        label.tag = 10000 + i;
        [label setTitle:tagStr forState:UIControlStateNormal];
        label.titleLabel.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 15;
        label.layer.borderColor= [UIColor colorWithHexString:@"#dddddd"].CGColor;
        label.layer.borderWidth = 0.5;
        label.layer.masksToBounds = YES;
        [label setTitleColor:[UIColor colorWithHexString:@"#8c8c8c"] forState:UIControlStateNormal];
        label.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//        label.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
//        label.layer.cornerRadius = 15;
//        label.layer.masksToBounds = YES;
//        [label setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//        label.titleLabel.font = [UIFont systemFontOfSize:14];
        [scr addSubview:label];
        maxX = CGRectGetMaxX(label.frame) + 6;
        
        if (i == (tags2.count-1)) {
            maxY = CGRectGetMaxY(label.frame);
        }
        
        i++;
        
    }
    [scr setContentSize:CGSizeMake(0, maxY)];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(16*mWidthScale, 341*mHeightScale, 343*mWidthScale, 44*mHeightScale)];
    [btn2 setTitle:Localized(@"确定", nil) forState:UIControlStateNormal];
    btn2.tag = 100000;
    btn2.backgroundColor = kZhuColor;
    btn2.layer.cornerRadius=22*mHeightScale;
    [btn2 setTitleColor:kGetColor(@"#000000") forState:UIControlStateNormal];
    btn2.titleLabel.font = kGetFont(16);
    [btn2 addTarget:self action:@selector(donBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgContentView addSubview:btn2];
    
//    CGFloat gao = CGRectGetMaxY(btn2.frame);
//    self.bgContentView.frame = CGRectMake((ML_ScreenWidth - kuan) / 2, ML_ScreenHeight / 2 - gao / 2, kuan, gao);
//    self.v1.frame = CGRectMake(ML_ScreenWidth / 2 - 67, self.bgContentView.y - 25, 134, ML_ScreenWidth==320?0:134);
}

- (void)onLaheizhiBtnClick
{

       ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.pDic[@"userId"], @"block" : @(![self.pDic[@"block"] boolValue])} urlStr:@"/im/block"];

    
       [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

           if ([self.pDic[@"block"] boolValue]) {
               
               PNSToast([UIViewController topShowViewController].view, Localized(@"已移出黑名单", nil) , 1.0);
           } else {
               
               PNSToast([UIViewController topShowViewController].view, Localized(@"已拉入黑名单", nil), 1.0);
           }
           
       } error:^(MLNetworkResponse *response) {


       } failure:^(NSError *error) {

       }];
    
    [self hideView];
}

- (void)onChuangChongzhiBtnClick
{
    if (self.ML_TanchuangClickBlock) {
        self.ML_TanchuangClickBlock(1);
    }
    dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
        NSLog(@"asdfasdf==adsf====%@==%@", [UIViewController topShowViewController], [UIViewController topShowViewController].navigationController);
        
        [[UIViewController topShowViewController].navigationController pushViewController:[ML_ChongVC new] animated:YES];
    });

    [self hideView];
}

- (void)ML_TanchuangViewType_MsgListVCMoreClick:(UIButton *)btn
{
    
    if (self.ML_TanchuangClickBlock && btn.tag) {
        self.ML_TanchuangClickBlock(btn.tag);
    }
    [self hideView];
}

- (void)hideView
{
    if (self.ML_TanchuangClickBlock) {
        self.ML_TanchuangClickBlock(0);
    }
    
    if (self.dataArr.count > 1) {
        
        self.isBgHideView = YES;
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }

        [self.dataArr removeObjectAtIndex:0];
        NSDictionary *dic = [self.dataArr firstObject];
          
        [self settingUIWithDic:dic];
  
    } else {
        
        [self.dataArr removeAllObjects];
        
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
            
        }
        
        [self removeFromSuperview];
    }
    
}

- (void)show{
    
    [KEY_WINDOW.window addSubview:self];
}


@end

         

