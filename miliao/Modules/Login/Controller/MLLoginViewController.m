//
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLLoginViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "MLUserMessageViewController.h"
#import "MLLoginCodeViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MLLoginWebViewController.h"
#import <NTESQuickPass/NTESQuickPass.h>
#import "MLLoginApi.h"
#import "MLTabbarViewController.h"
#import "MLFriendModelViewController.h"
#import "UIViewController+MLHud.h"
#import "MLNavViewController.h"
#import<CoreTelephony/CTCellularData.h>
#import "MLLoginView.h"
#import "MLLoginDianxinWebViewController.h"
#import "UIAlertView+NTESBlock.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "YYText.h"
#import "YYLabel.h"


@interface MLLoginViewController ()<UIScrollViewDelegate, NTESQuickLoginManagerDelegate>
@property (nonatomic,assign)BOOL isCodebtnlogin;
@property (strong, nonatomic)UIImageView *loginImage;
@property (strong, nonatomic)UIScrollView *loginScrollView;
@property (strong, nonatomic)UIView *bgView;
@property (strong, nonatomic)UIButton *selectimg;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,copy)NSString *securityPhone;
//@property (nonatomic,strong)NTESQuickLoginManager *manager;
@property (nonatomic,strong)NSDictionary *onekeydict;
@property (nonatomic,strong)NSDictionary *accessdict;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)BOOL isEm;
@property (nonatomic,strong)NTESQuickLoginModel *model;
@property (nonatomic,strong)MLLoginView *loginView;
@property (nonatomic,strong)UIView *NmaskView;
@property (nonatomic,strong)NSString *contactInformation;
@end

@implementation MLLoginViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    //[self.manager closeAuthController:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self setCustomUI];
    //self.manager.model.currentVC = self;
    
    self.isSelect = NO;
    self.isCodebtnlogin = NO;
    
//    if (kisCH) {
//            [self getPhone];
//    }
//    self.ML_navView.hidden = YES;
 
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//
//    [self.manager.model.currentVC dismissViewControllerAnimated:NO completion:nil];
//
//}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"base/getContactInformation"];
         [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

             self.contactInformation = response.data[@"contactInformation"];
             
            
        } error:^(MLNetworkResponse *response) {
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    
    
    self.ML_navView.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getPhone];
}


- (void)dealloc
{
    
    
}

- (void)fcSignIn {

    
}
   
- (void)signIn:(UIButton *)sender {


}

- (void)setWindowCustomUI
{
    self.view.backgroundColor = UIColor.whiteColor;
    self.loginScrollView = [[UIScrollView alloc]init];
    self.loginScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.loginScrollView.delegate = self;
    [self.view addSubview:self.loginScrollView];

    
    self.loginImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.loginImage.contentMode = UIViewContentModeScaleAspectFill;
    self.loginImage.image = [UIImage imageNamed:@"001_deng_bg"];
//    self.loginImage.frame = CGRectMake(0, -90, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2 + 49 + 48);
    self.loginImage.userInteractionEnabled = NO;
    self.loginView.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2);
//    self.loginImage.contentMode = UIViewContentModeScalea;
    [self.loginScrollView addSubview:self.loginImage];
    
    self.bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //self.bgView.backgroundColor = [UIColor colorFromHexString:@"#000000"];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
    //self.bgView.backgroundColor = [uicolo];
    [self.view addSubview:self.bgView];
    [self setupUI];
}

- (void)getPhone{
 
    __block NTESQuickLoginManager *manager = [NTESQuickLoginManager sharedInstance];
//    self.manager = manager; f07a6b736eb641229e99ebca42d9575f  a9fcce639f354107b7820a94d9c17faa
//    [manager registerWithBusinessID:[ML_KBaseUrl isEqualToString:@"http://api.kangs2023.com"]?@"a9fcce639f354107b7820a94d9c17faa":@"f07a6b736eb641229e99ebca42d9575f"];
    [manager registerWithBusinessID:@"77e7db3463db46cba849f11009cb739d"];
    BOOL shouldQuickLogin = [manager shouldQuickLogin];
    [manager setTimeoutInterval:3000];
    //    [self.manager.model.currentVC dismissViewControllerAnimated:NO completion:nil];
    
    __block UIImageView *MT_bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    MT_bgImgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MT_bgImgView];

    UIImageView *MT_loginView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    MT_loginView.contentMode = UIViewContentModeScaleAspectFill;
    MT_loginView.image = [UIImage imageNamed:@"001_deng_bg"];
    [MT_bgImgView addSubview:MT_loginView];
    
    
    if (manager.getCarrier && shouldQuickLogin) {
//        [SVProgressHUD show];

        kSelf;
        [manager getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {

            NSNumber *boolNum = [resultDic objectForKey:@"success"];
            BOOL success = [boolNum boolValue];
            if (success) {

                weakself.onekeydict = resultDic;
                NSLog(@"onekeydict---%@",resultDic);
                /// 设置授权页 UI 界面
                //[[NTESQuickLoginManager sharedInstance] setupModel:];
                // 拉取授权页面，该方法必须在设置授权页 UI 界面之后调用
                dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
                    if (weakself.isSelect) {

                        [SVProgressHUD dismiss];
                        [manager authLoginButtonClick];
                    } else {
                        [weakself setCustomUI];
                    }


                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isJi"] boolValue]) {

                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{

                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isJi"];

                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:@"你的帐号被踢出下线，请注意帐号信息安全" delegate:nil cancelButtonTitle:Localized(@"确定", nil) otherButtonTitles:nil, nil];
                                [alert show];
                            });

                    }

                });


            } else {
                dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
                    [SVProgressHUD dismiss];
                    [MT_bgImgView removeFromSuperview];
                    [weakself gotoPhoneLoginVC];
//                    [weakself setWindowCustomUI];
                });
            }
        }];
    } else {

        
        [MT_bgImgView removeFromSuperview];
        [self gotoPhoneLoginVC];
//        [self setWindowCustomUI];
    }
}
- (void)gotoPhoneLoginVC
{
    MLLoginCodeViewController *vc = [[MLLoginCodeViewController alloc] init];

    
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [self.view sendSubviewToBack:vc.view];
        
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isJi"] boolValue]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isJi"];
//                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
//                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    
        dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:@"你的帐号被踢出下线，请注意帐号信息安全" delegate:nil cancelButtonTitle:Localized(@"确定", nil) otherButtonTitles:nil, nil];
                [alert show];
        });
//    });
        
    }
    
}
- (void)setCustomUI {
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    NTESQuickLoginModel *model = [[NTESQuickLoginModel alloc] init];
    self.model = model;
    model.presentDirectionType = NTESPresentDirectionPush;
    model.navTextColor = [UIColor blueColor];
    model.navBgColor = [UIColor whiteColor];
    model.authWindowPop = NTESAuthWindowPopFullScreen;
    model.bgImage = kGetImage(@"001_deng_bg");
    model.contentMode = UIViewContentModeScaleAspectFill;
    model.backgroundColor = [UIColor whiteColor];
    //
//    model.videoURL = @"https://dahuixiong.oss-cn-shenzhen.aliyuncs.com/data/video/bg_login.mp4";
    model.localVideoFileName = @"logingShip.mp4";
    model.isRepeatPlay = YES;

    /// logo
    /// 
    model.logoImg = [UIImage imageNamed:@"AppIcon"];
    model.logoWidth = 74;
    model.logoHeight = 74;
    model.logoOffsetTopY = 141;
    model.logoHidden = NO;

    /// 手机号码
    model.numberFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:28];
    model.numberOffsetX = 0;
    model.numberColor = UIColor.whiteColor;
    model.numberOffsetTopY = 259;
    
    model.brandColor = [UIColor whiteColor];
    model.brandFont = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    model.brandOffsetTopY = 328;

    /// 登录按钮
    model.logBtnTextFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    model.logBtnTextColor = [UIColor colorFromHexString:@"#333333"];
    model.logBtnText = @"本机号码一键登录";
    model.logBtnRadius = 25;
    model.logBtnHeight = 53;
    model.logBtnOriginLeft = 27;
    model.logBtnOriginRight = 27;
    model.logBtnUsableBGColor = UIColor.whiteColor;
    model.logBtnOffsetTopY = 357;
    //model.startPoint = CGPointMake(0, 0.5);
    //model.endPoint = CGPointMake(1, 0.5);
    //model.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor];


    
        /// 隐私协议
    model.appPrivacyText = Localized(@"登录即默认同意《用户协议》和《隐私协议》并授权Meeting获得本机号码", nil);
    if (kisCH) {
        model.appPrivacyText = @"登录即默认同意《用户协议》和《隐私协议》并授权云水谣情获得本机号码";
    }
    model.appFPrivacyText = Localized(@"《用户协议》", nil);
    model.appPrivacyOriginBottomMargin = 50;
    model.appFPrivacyURL = MlAgreementhtml;
    model.appSPrivacyText = Localized(@"《隐私协议》", nil);
    model.appSPrivacyURL = MlPrivacyhtml;
    //model.shouldHiddenPrivacyMarks = YES;
    model.uncheckedImg = [[UIImage imageNamed:@"icon_gouxuan_16_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkedImg = [[UIImage imageNamed:@"icon_gouxuan_30_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkboxWH = 32;
    model.checkBoxAlignment = NSCheckBoxAlignmentTop;
    model.protocolColor = UIColor.whiteColor;
    //model.privacyState = YES;
    model.isOpenSwipeGesture = NO;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    model.privacyColor = [UIColor colorFromHexString:@"#999999"];
    model.statusBarStyle = UIStatusBarStyleLightContent;
    
    
    kSelf;
    model.customViewBlock = ^(UIView * _Nullable customView) {
        UILabel *otherLabel = [[UILabel alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherLabelTapped:)];
        [otherLabel addGestureRecognizer:tap];
        otherLabel.userInteractionEnabled = YES;
        otherLabel.text = Localized(@"手机验证码登录", nil);
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
        otherLabel.font = [UIFont fontWithName:@"PingFang SC-Medium" size:16];
        [customView addSubview:otherLabel];
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(customView);
            make.top.equalTo(customView).mas_offset(453);
            make.height.mas_equalTo(16);
        }];
        
        
        UILabel *otherLabel2 = [[UILabel alloc] init];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherLabelTapped2:)];
        [otherLabel2 addGestureRecognizer:tap2];
        otherLabel2.userInteractionEnabled = YES;
        otherLabel2.text = Localized(@"客服微信号", nil);
        otherLabel2.textAlignment = NSTextAlignmentRight;
        otherLabel2.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
        otherLabel2.font = [UIFont fontWithName:@"PingFang SC-Medium" size:16];
        [customView addSubview:otherLabel2];
        [otherLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(customView).mas_offset(ML_NavViewHeight - 20);
            make.right.equalTo(customView).mas_offset(-16);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        
    };

    /**返回按钮点击事件回调*/
//    model.backActionBlock = ^{
//        NSLog(@"返回按钮点击");
//    };

    /**登录按钮点击事件回调*/
//    model.loginActionBlock = ^{
//        NSLog(@"loginAction");
//    };
    
    [model setLoginActionBlock:^(BOOL isChecked) {
        if (!weakself.isSelect) {
            
            //success 等于YES时，电信 resultCode = 0，移动 resultCode = 103000，联通 resultCode = 100
            [weakself setupSHowresultCode:[weakself.onekeydict[@"resultCode"] integerValue]]; //登录弹框----
        }
        if (!weakself.onekeydict) {
            kplaceToast(@"获取手机号码中...");
            [weakself getPhone];
            return;
        }
        
        NSLog(@"点击登录事件");
    }];

    /**复选框点击事件回调*/
    model.checkActionBlock = ^(BOOL isChecked) {
        if (isChecked) {
            //选中复选框;
            weakself.isSelect = YES;
        } else {
            //取消复选框;
            weakself.isSelect = NO;
        }
    };
            
    /**协议点击事件回调*/
    model.privacyActionBlock = ^(int privacyType) {
        if (privacyType == 0) {
            //点击默认协议
        } else if (privacyType == 1) {
            // 点击自定义第1个协议;
        } else if (privacyType == 2) {
            // 点击自定义第1个协议;
        }
    };
                            
    /**协议点击事件回调，不会跳转到默认的协议页面。开发者可以在回调里，自行跳转到自定义的协议页面*/
//    model.pageCustomBlock = ^{
//        // 跳转到自定义的控制器
//        NSLog(@"ffff");
//    };

    model.navBarHidden = YES;
    model.currentVC = self;
    
    model.currentVC.view.backgroundColor = [UIColor redColor];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [[NTESQuickLoginManager sharedInstance] setupModel:self.model];
    
    [[NTESQuickLoginManager sharedInstance] CUCMCTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            // 取号成功，获取acessToken
            NSLog(@"acessToken---%@",resultDic);
            weakself.accessdict = resultDic;

            [weakself giveMLLoginApiyiToken:weakself.onekeydict[@"token"] accessToken:resultDic[@"accessToken"] logoType:nil];
            
        } else {
            // 取号失败
            
        }
    } animated:NO];
    
}


#pragma - NTESQuickLoginManagerDelegate

- (void)authViewWillAppear {
    NSLog(@"授权页面将要弹出");
}

- (void)authViewDidAppear {
    NSLog(@"授权页面已经弹出");
}

- (void)authViewWillDisappear {
    NSLog(@"授权页面将要消失");
}

- (void)authViewDidDisappear {
     NSLog(@"授权页面已经消失");
}

- (void)authViewDidLoad {
     NSLog(@"授权页面初始化了");
}

- (void)authViewDealloc {
    NSLog(@"授权页面销毁了");
}


-(void)setupSHowresultCode:(NSInteger)resultCode{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.NmaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.NmaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    kSelf;
    self.loginView = [MLLoginView alterVietextview:[NSString stringWithFormat:@"%ld",(long)resultCode] StrblocksureBtClcik:^{
        
        if (weakself.isCodebtnlogin || resultCode == -1) {
            
            MLLoginCodeViewController *vc = [[MLLoginCodeViewController alloc]init];
            vc.isEm = weakself.isEm;
            vc.isPresent = YES;
            [weakself.navigationController pushViewController:vc animated:YES];
            self.isEm = NO;;
        } else {
            [weakself.loginView cancelclick];
            //        weakself.model.checkActionBlock(YES);
            weakself.model.checkedSelected = YES;
            weakself.isSelect = YES;
            [[NTESQuickLoginManager sharedInstance] authLoginButtonClick];
        }
    } cancelClick:^{
        weakself.isCodebtnlogin = NO;
    } userClick:^{
//        [self.maskView removeFromSuperview];
        MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
        vc.navtitle = @"用户协议";
        vc.webhtml = MlAgreementhtml;
        [weakself.navigationController pushViewController:vc animated:YES];
    } agreetClick:^{
//        [self.maskView removeFromSuperview];
        MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
        vc.navtitle = @"隐私政策";
        vc.webhtml = MlPrivacyhtml;
        [weakself.navigationController pushViewController:vc animated:YES];
    } phoneClick:^{

//        NSInteger resultCode = self.onekeydict[@"resultCode"];
        if (resultCode == 0) { //电信
            MLLoginDianxinWebViewController *vc = [[MLLoginDianxinWebViewController alloc]init];
            [weakself.navigationController pushViewController:vc animated:YES];
        }else if(resultCode == 103000){//移动
            MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
            vc.navtitle = @"移动服务政策";
            vc.webhtml = Mlyidongtml;
            [weakself.navigationController pushViewController:vc animated:YES];
            
        }else{//联通
            MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
            vc.navtitle = @"联通服务政策";
            vc.webhtml = Mlliantongtml;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
//         [self.maskView removeFromSuperview];
    }];
     [self.NmaskView addSubview:self.loginView];
     [window addSubview:self.NmaskView];
}

/*
 -(void)tapAgreeClick{
     NSLog(@"协议");
     MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
     vc.navtitle = @"用户协议";
     vc.webhtml = MlAgreementhtml;
 //    [self presentViewController:vc animated:YES completion:^{
 //
 //    }];
     [self.navigationController pushViewController:vc animated:YES];
 }
 -(void)tapindexClick{
     NSLog(@"隐私");
     MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
     vc.navtitle = @"隐私政策";
     vc.webhtml = MlPrivacyhtml;
 //    [self presentViewController:vc animated:YES completion:^{
 //
 //    }];
     [self.navigationController pushViewController:vc animated:YES];
 }
 */


- (void)otherLabelTapped:(UITapGestureRecognizer *)tap {
    if (self.isSelect == NO) {
//     CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//     shake.fromValue = [NSNumber numberWithFloat:-5];
//      shake.toValue = [NSNumber numberWithFloat:5];
//      shake.duration = 0.1;//执行时间
//        shake.autoreverses = YES;//是否重复
//        shake.repeatCount = 2;//次数
//
//        [[NTESQuickLoginManager sharedInstance].model.privacyTextView.layer addAnimation:shake forKey:@"shakeAnimation"];
//    [[NTESQuickLoginManager sharedInstance].model.checkBox.layer addAnimation:shake forKey:@"shakeAnimation"];
        self.isCodebtnlogin = YES;
        [self setupSHowresultCode:[self.onekeydict[@"resultCode"] integerValue]]; //登录弹框----
        
        NSLog(@"loginAction====复选框未勾选");
    } else {
        MLLoginCodeViewController *vc = [[MLLoginCodeViewController alloc]init];
        vc.isEm = self.isEm;
        vc.isPresent = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.isEm = NO;;
    }
}

- (void)otherLabelTapped2:(UITapGestureRecognizer *)tap {

        NSLog(@"loginActiootherLabelTapped2");

    if (!self.contactInformation) {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: Localized(@"客服微信号", nil) message:self.contactInformation delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"复制", nil), nil];
    [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
        switch (alertIndex) {
            case 1:
            {
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.contactInformation;
                
                
            }
                break;
            default:
                break;
        }
    }];
    
    
}

#pragma mark----登录---------

//一键登录验证码登录------
-(void)giveMLLoginApiyiToken:(NSString *)yiToken accessToken:(NSString *)accessToken logoType:(NSString *)logoType{
    [SVProgressHUD show];
    
    NSString *type = @"1";
    if ([logoType isEqualToString:@"googleToken"])
    {
        type = @"2";
        
    } else if ([logoType isEqualToString:@"faceboookToken"]) {
        type = @"3";
    }
    
    kSelf;
    MLLoginApi *api = [[MLLoginApi alloc] initWithtype:type thirdId:@"" accessToken:accessToken code:@"" dev:@"" yiToken:yiToken nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    if ([type isEqualToString:@"3"]) {
        api.facebookUserId = accessToken?:@"";
    }
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"登录----%@--%@--%@",response.data,response.msg,response.status);
//        [weakself.loginView cancelclick];
        
        [SVProgressHUD dismiss];
        if (response.data[@"user"]) { //有填写 无填写
            UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response.data[@"user"]];
            currentData.domain = response.data[@"domain"]?:@"";
            currentData.thirdId = response.data[@"thirdId"]?:@"";
            [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
//            if([response.data[@"trait"] boolValue] == 1){
                MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
                 
                    [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
        }  else if ([response.status intValue] == 20){
            weakself.model.checkedSelected = YES;
            weakself.isSelect = YES;
            
            [weakself getPhone];

        
        } else if ([response.status intValue] == 0){
            MLUserMessageViewController *vc = [[MLUserMessageViewController alloc]init];
            vc.phonestr = response.data[@"thirdId"];
            vc.type = @"thirdId";
            if ([type isEqualToString:@"2"]) {
                vc.type = @"googleId";
                vc.phonestr = response.data[@"googleId"];
            } else if ([type isEqualToString:@"3"]) {
                vc.type = @"facebookId";
                vc.phonestr = response.data[@"facebookId"];
            }
//            [weakself.navigationController pushViewController:vc animated:YES];
            
            MLNavViewController *navVC = [[MLNavViewController alloc] initWithRootViewController:vc];
            [[AppDelegate shareAppDelegate] setupRootViewController:navVC];
            
        }
    } error:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        NSLog(@"登录----%@--%@--%@",response.data,response.msg,response.status);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}




-(void)setupUI{

    self.loginScrollView.contentSize=CGSizeMake(0,[UIScreen mainScreen].bounds.size.height * 2);//设置内容的大小
    self.loginScrollView.pagingEnabled=NO;//分页效果是否可用，默认为no
    self.loginScrollView.bounces=NO;//是否有反弹效果，默认为yes
    self.loginScrollView.userInteractionEnabled = NO;
    self.loginScrollView.indicatorStyle=UIScrollViewIndicatorStyleWhite;//滚动条风格
    [self.loginScrollView flashScrollIndicators];//一显示就显示一下滚动条，用来提示用户的
    //self.loginScrollView.showsHorizontalScrollIndicator=YES;//显示滚动条
   
    self.loginScrollView.backgroundColor=[UIColor redColor];

//    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    [UIView animateWithDuration:40.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction
  animations:^{
        self.loginImage.frame = CGRectMake(0, -48 - [UIScreen mainScreen].bounds.size.height - 86, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2 + 49 + 48);
    } completion:^(BOOL finished) {
        self.loginImage.frame = CGRectMake(0, -48, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2 + 49 + 48);
    }];
    
    [self setupBgView];
}


-(void)setupBgView{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    btn.layer.cornerRadius = 25;
    btn.hidden = YES;
    [btn setTitle:@"本机号码一键登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(self.bgView.mas_left).mas_offset(27);
            make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-27);
            make.height.mas_equalTo(53);
        }];
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"AppIcon"];
    img.layer.masksToBounds = YES;
    img.layer.cornerRadius = 16;
    [self.view addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(74);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-120);
    }];
    
    UILabel *phone = [[UILabel alloc]init];
    phone.text = self.securityPhone;
    phone.textAlignment = NSTextAlignmentCenter;
    phone.font = [UIFont systemFontOfSize:28];
    phone.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [self.bgView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btn.mas_centerX);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-10);
    }];

    
    if (kisCH) {
        UIButton *codebtnlogin = [UIButton buttonWithType:UIButtonTypeCustom];
        codebtnlogin.backgroundColor = [UIColor whiteColor];
        codebtnlogin.layer.cornerRadius = 21.5;
        [codebtnlogin setTitle:Localized(@"手机验证码登录", nil) forState:UIControlStateNormal];
        codebtnlogin.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [codebtnlogin setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [codebtnlogin addTarget:self action:@selector(codebtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:codebtnlogin];
        [codebtnlogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn.mas_centerX);
            //        make.centerY.mas_equalTo(ML_ScreenHeight / 2);
            make.top.mas_equalTo(btn.mas_bottom).mas_offset(0);
            make.height.mas_equalTo(43);
            make.width.mas_equalTo(ML_ScreenWidth - 80);
        }];
    } else {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, ML_ScreenHeight / 2 - 51, ML_ScreenWidth - 80, 43)];
        btn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        btn.layer.cornerRadius = 43/2;
        btn.tag = 0;
        [btn setTitle:@"Google" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [btn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        
//        FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
        UIButton *loginButton = [[UIButton alloc] init];
        loginButton.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        [loginButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [loginButton setTitle:@"Facebook" forState:UIControlStateNormal];
        loginButton.size = CGSizeMake(ML_ScreenWidth - 80, 43);
        loginButton.layer.cornerRadius = 43/2;
        loginButton.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2 + 28);
        [self.view addSubview:loginButton];
//        loginButton.permissions = @[@"public_profile", @"email"];
        [loginButton addTarget:self action:@selector(fcSignIn) forControlEvents:UIControlEventTouchUpInside];
        
        //
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 44 - 35, CGRectGetMaxY(btn.frame) + 100, 44, 44)];
        [btn3 setBackgroundImage:kGetImage(@"Group 2193") forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(codebtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn3];

        
        UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 + 35, btn3.y, 44, 44)];
        [btn4 setBackgroundImage:kGetImage(@"Group 2194") forState:UIControlStateNormal];
        [btn4 addTarget:self action:@selector(emClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn4];

        
    }
    
    UILabel *otherLabel2 = [[UILabel alloc] init];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherLabelTapped2:)];
    [otherLabel2 addGestureRecognizer:tap2];
    otherLabel2.userInteractionEnabled = YES;
    otherLabel2.text = Localized(@"客服微信号", nil);
    otherLabel2.textAlignment = NSTextAlignmentRight;
    otherLabel2.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
    otherLabel2.font = [UIFont fontWithName:@"PingFang SC-Medium" size:16];
    [self.view addSubview:otherLabel2];
    [otherLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(ML_NavViewHeight - 20);
        make.right.equalTo(self.view).mas_offset(-16);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(200);
    }];

    UIButton *selectimg = [UIButton buttonWithType:UIButtonTypeCustom];
    selectimg.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [selectimg setImage:[UIImage imageNamed:@"icon_gouxuan_16_nor"] forState:UIControlStateNormal];
    [selectimg setImage:[UIImage imageNamed:@"icon_gouxuan_30_sel"] forState:UIControlStateSelected];
    [selectimg addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    selectimg.selected = NO;
    self.selectimg = selectimg;
    [self.bgView addSubview:selectimg];
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(50);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).mas_offset(-SSL_TabbarHeight - 2);
    }];
    
    
    NSString *value = Localized(@"登录即同意《用户协议》和《隐私协议》并授权Meesting获取得本机号码", nil);
    if (kisCH) {
        value = @"登录即同意《用户协议》和《隐私协议》并授权思聊交友获取得本机号码";
    }
    CGSize size = [value sizeWithFont:[UIFont systemFontOfSize: 12] maxSize:CGSizeMake(ML_ScreenWidth - 45 * 2 - 50, 200)];
    CGFloat height = [self getterSpaceLabelHeight:value withLineSpacing:3 withFont:kGetFont(12) withWidth:ML_ScreenWidth - 45 * 2 - 50];
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(90, ML_ScreenHeight - SSL_TabbarHeight-2 - 30, size.width+10, (size.height<20?20:size.height));
    label1.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];

    label1.userInteractionEnabled = YES;
    label1.font = [UIFont systemFontOfSize: 12];
    label1.text = value;

    NSMutableAttributedString *atStr = [[NSMutableAttributedString alloc] initWithString:value];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距为
    [paragraphStyle setLineSpacing:0];
    // 设置文字属性的范围
    [atStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [value length])];

    NSRange rang1 = [value rangeOfString:Localized(@"《用户协议》", nil)];
    NSRange rang2 = [value rangeOfString:Localized(@"《隐私协议》", nil)];

    [atStr yy_setColor:[UIColor wheatColor] range:rang1];
    [atStr yy_setFont:label1.font range:rang1];
    [atStr yy_setFont:label1.font range:rang1];
    [atStr yy_setColor:[UIColor wheatColor] range:rang2];
    [atStr yy_setFont:[UIFont systemFontOfSize:12] range:rang1];
    [atStr yy_setFont:[UIFont systemFontOfSize:12] range:rang2];

    label1.attributedText = atStr;
    label1.numberOfLines = 0; //  一定要放在attributedText之后
    [self.view addSubview:label1];

    kSelf;
    [label1 yb_addAttributeTapActionWithStrings:@[Localized(@"《用户协议》", nil), Localized(@"《隐私协议》", nil)] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        if (index) {
            [self tapindexClick];
        }
        else {
            [self tapAgreeClick];
        }
    }];

    //设置是否有点击效果，默认是YES
    label1.enabledTapEffect = NO;
    
    
}

- (CGFloat)getterSpaceLabelHeight:(NSString*)string withLineSpacing:(CGFloat)lineSpacing withFont:(UIFont*)font withWidth:(CGFloat)width{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f
                         };
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
    
    
}



- (void)emClick
{
    self.isEm = YES;
    [self codebtnClick];
}

-(void)tapAgreeClick{
    NSLog(@"协议");
    MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.navtitle = @"用户协议";
    vc.webhtml = MlAgreementhtml;
    [self presentViewController:vc animated:YES completion:^{

    }];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapindexClick{
    NSLog(@"隐私");
    MLLoginWebViewController *vc = [[MLLoginWebViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.navtitle = @"隐私政策";
    vc.webhtml = MlPrivacyhtml;
    [self presentViewController:vc animated:YES completion:^{

    }];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)selectClick:(UIButton *)btn{
    
    //[self setupSHow];
    
    btn.selected = !btn.selected;
    self.isSelect = btn.selected;
}

//本机号码一键登录-----
-(void)btnClick{
    
    if (!self.onekeydict) {
        kplaceToast(@"获取手机号码中...");
        [self getPhone];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) ws = self;
    if (self.selectimg.selected) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        PNSToast(ws.view, @"正在唤起登录", 1.0);
        [self onekeylogin];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        PNSToast(ws.view, Localized(@"请选择用户协议", nil), 1.0);
    }
}

-(void)codebtnClick{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    if (!self.isSelect) {
        [self setupSHowresultCode:-1]; //登录弹框----
        return;
    }
    
    __weak typeof(self) ws = self;
    if (self.selectimg.selected) {
        
                MLLoginCodeViewController *vc = [[MLLoginCodeViewController alloc]init];
        vc.isEm = self.isEm;
        vc.isPresent = YES;
                [self.navigationController pushViewController:vc animated:YES];
        self.isEm = NO;
//            }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        PNSToast(ws.view, @"正在唤起登录", 1.0);
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //PNSToast(ws.view, [resultDic objectForKey:@"msg"], 3.0);
        PNSToast(ws.view, Localized(@"请选择用户协议", nil), 1.0);
    }
}

#pragma mark ---- 一键登录----------
-(void)onekeylogin{

    //MLtexteditviewViewController *vc = [[MLtexteditviewViewController alloc]init];
    //[self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
