//
//  MLTabbarViewController.m
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import "MLTabbarViewController.h"
#import "MLNavViewController.h"
#import "HY_AdViewController.h"
#import "MLHomeViewController.h"
#import "MLCommunityViewController.h"
//#import "ML_SessionListViewController.h"


#import "MLLoginViewController.h"

#import <SDWebImage/SDWebImage.h>
#import "MLMineViewController.h"

#import "HY_TabBar.h"
#import "ML_ChongVC.h"
#import "ML_BangdanVC.h"

#import "SiLiaoBack-Swift.h"
#define TabbarItemBadgeValue @"badgeValue"

@interface MLTabbarViewController ()<HY_TabBarDelegate>

@property (nonatomic,assign) NSInteger sessionUnreadCount;
@property (nonatomic,assign) NSInteger systemUnreadCount;
@property (nonatomic, strong) UIView *msgTanView;
@property (nonatomic, strong) NSString *msgTanUserId;
@property (nonatomic,assign) NSInteger customSystemUnreadCount;
@property (nonatomic, weak) HY_TabBar *customTabBar;
@property (nonatomic, strong) MessageVC *message;
@end

@implementation MLTabbarViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[MLTabbarViewController class]]) {
        return (MLTabbarViewController *)vc;
    }else{
        return nil;
    }
}

- (void)dealloc{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //会话界面发送拍摄的视频，拍摄结束后点击发送后可能顶部会有红条，导致的界面错位。
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)shuaUnCountMsg:(NSNotification *)nt
{
     [self refreshSessionBadge];
}

- (void)isDingGift:(NSNotification *)nt
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDing_gift"];
    });
}

- (void)delayAcd
{
    
    [self.msgTanView removeFromSuperview];
    self.msgTanView = nil;
}

- (void)tanReceiveText:(NSNotification *)nt
{
    NSDictionary *dic = nt.object;
    
    
    self.msgTanUserId = [NSString stringWithFormat:@"%@", dic[@"userId"]];

    if ([self.msgTanUserId isEqualToString:@"100000"]) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayAcd) object:nil];
    
    [self performSelector:@selector(delayAcd) withObject:nil afterDelay:5.0];
    
    [self.msgTanView removeFromSuperview];
    self.msgTanView = nil;
    
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(7, ML_ScreenHeight - ML_TabbarHeight - 120, ML_ScreenWidth - 14, 96)];
    view.layer.cornerRadius = 12;
    view.tag = 1001;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    view.layer.shadowOpacity = 0.15f;
    view.layer.shadowRadius = 4.0f;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    //设置缓存
    view.layer.shouldRasterize = YES;
    //设置抗锯齿边缘
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    self.msgTanView = view;
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(msgTanViewClick)];
    [view addGestureRecognizer:viewTap];
    
    
    UIImageView *avV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 8, 80, 80)];
    avV.userInteractionEnabled = YES;
    avV.layer.cornerRadius = avV.height / 2;
    avV.layer.masksToBounds = YES;
    [avV sd_setImageWithURL:kGetUrlPath(dic[@"icon"])];
    [view addSubview:avV];
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avVClick)];
    [avV addGestureRecognizer:indexTap];
    
    CGSize size = [dic[@"name"] sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(200, 30)];
    
    UILabel *nameV = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avV.frame) + 13, avV.y, size.width, 30)];
    nameV.font = [UIFont systemFontOfSize:16];
    nameV.text = dic[@"name"];
    nameV.textColor = [UIColor colorWithHexString:@"#333333"];
    [view addSubview:nameV];
    
    UIButton *agebtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameV.frame) + 10, nameV.y + 5, 40, 20)];
    agebtn.titleLabel.font = [UIFont systemFontOfSize:10];
    agebtn.layer.cornerRadius = 10;
    agebtn.layer.masksToBounds = YES;
    [view addSubview:agebtn];
    if ([dic[@"gender"] intValue] == 1) {
        [agebtn setTitle:[NSString stringWithFormat:@"♂%@", dic[@"age"]] forState:UIControlStateNormal];
        agebtn.backgroundColor = [UIColor colorWithHexString:@"#0491FF"];
//            [weakself.agebtn setImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-2"] forState:UIControlStateNormal];
    } else {
        [agebtn setTitle:[NSString stringWithFormat:@"♀%@", dic[@"age"]] forState:UIControlStateNormal];
       agebtn.backgroundColor = [UIColor colorWithHexString:@"#FB4240"];
//            [weakself.agebtn setImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-2"] forState:UIControlStateNormal];
        
    }
    
    UIButton *huibtn = [[UIButton alloc] initWithFrame:CGRectMake(view.width - 90, nameV.y +2, 75, 26)];
    huibtn.userInteractionEnabled = NO;
    [huibtn setTitle:@"回复" forState:UIControlStateNormal];
    huibtn.backgroundColor = [UIColor colorWithHexString:@"#AFBDFA"];
    huibtn.layer.cornerRadius = 13;
    huibtn.layer.masksToBounds = YES;
    [view addSubview:huibtn];
    
    UILabel *msgV = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avV.frame) + 13, CGRectGetMaxY(avV.frame) - 30, ML_ScreenWidth - 130, 30)];
    msgV.font = [UIFont systemFontOfSize:14];
    msgV.text = dic[@"text"];
    msgV.textColor = [UIColor colorWithHexString:@"#999999"];
    [view addSubview:msgV];
    
}

- (void)avVClick
{
    [self.msgTanView removeFromSuperview];
    [self gotoInfoVC:self.msgTanUserId];
}

- (void)msgTanViewClick
{
    [self.msgTanView removeFromSuperview];
    [self gotoChatVC:self.msgTanUserId];
}

- (void)tanchuChat:(NSNotification *)nt
{
    [self.msgTanView removeFromSuperview];
    NSDictionary *Rob_euCnotiDic = nt.object;
    if (Rob_euCnotiDic[@"userId"]) {
        
        [self gotoChatVC:[NSString stringWithFormat:@"%@", Rob_euCnotiDic[@"userId"]]];
    }
}

- (void)pushChongVC
{
    
    [[UIViewController topShowViewController].navigationController pushViewController:[ML_ChongVC new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTabbar];
    [self tabBar:self.customTabBar didSelectedButtonFrom:0 to:tabarMoIndel];

    
//    extern NSString *NTESCustomNotificationCountChanged;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCustomNotifyChanged:) name:NTESCustomNotificationCountChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isDingGift:) name:@"isDingGift" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tanReceiveText:) name:@"tanReceiveText" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChongVC) name:@"pushChongVC" object:nil];
    
    ADD_NOTIFICATION(@"tanchuChat", self, @selector(tanchuChat:), nil);
    
    [self setupAllChildViewControllers];
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"autoLogin"]) {
//
//        [[AppDelegate shareAppDelegate] setupCallKit];
//        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
//
//        [[[NIMSDK sharedSDK] loginManager] login:currentData.userId
//                                           token:currentData.imToken
//                                      completion:^(NSError *error) {
//                                          if(!error){
//
//                                              NSLog(@"NIM登录成功 ====%@", error);
//
//
//                                              NTESLoginData *sdkData = [[NTESLoginData alloc] init];
//                                              sdkData.account   = currentData.userId;
//                                              sdkData.token     = currentData.imToken;
//                                              [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
//
//                                              [[NTESServiceManager sharedManager] start];
//
//                                              [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoLogin"];
////                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"getGiftList" object:nil];
//
//
//                                          } else {
//
//                                              NSLog(@"=== NIM登录失败 ====%@", error);
//
//                                              [KEY_WINDOW.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
//                                              MLNavViewController *nav = [[MLNavViewController alloc]initWithRootViewController:[[HY_AdViewController alloc]init]];
//                                              KEY_WINDOW.window.rootViewController = nav;
//
////                                              [[AppDelegate shareAppDelegate] setupRootViewController:nav];
//                                          }
//
//                                      }];
//
//    }
    
    
    [self refreshSessionBadge];
//    extern NSString *NTESCustomNotificationCountChanged;
//    [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    for (UIView * view in self.tabBar.subviews){
        if (![view isKindOfClass:[HY_TabBar class]]) {
            [view removeFromSuperview];
        }
    }
}
- (void)setupTabbar
{
    HY_TabBar *customTabBar = [[HY_TabBar alloc] init];
    
    self.tabBar.barTintColor = UIColor.whiteColor;

    if (@available(iOS 13.0, *)) {
        [UITabBar appearance].backgroundImage = [UIImage new];
        [UITabBar appearance].backgroundColor = UIColor.whiteColor;
    }

    
    
    customTabBar.frame = CGRectMake(16*mWidthScale, 0, 343*mWidthScale, 52*mHeightScale);
    customTabBar.layer.cornerRadius = 26*mHeightScale;
    customTabBar.layer.masksToBounds = YES;
    customTabBar.layer.borderColor = kGetColor(@"a4a4a5").CGColor;
    customTabBar.layer.borderWidth = 0.5;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}
#pragma mark - tabbar的代理方法
- (void)tabBar:(HY_TabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
}
- (void)tabBarDidClickedPlusButton:(HY_TabBar *)tabBar
{
}

- (void)setupAllChildViewControllers
{
    MLHomeViewController *home = [[MLHomeViewController alloc]init];
    [self setupChildViewController:home title:Localized(@"首页", nil) imageName:@"icon_home_22-nor" selectedImageName:@"icon_home_22-sel"];
    
    MLCommunityViewController *community = [[MLCommunityViewController alloc]init];
    [self setupChildViewController:community title:Localized(@"社区",nil) imageName:@"icon_community_22_nor" selectedImageName:@"icon_community_22_sel"];
    

//    ML_BangdanVC *bangVC = [[ML_BangdanVC alloc]init];
//    [self setupChildViewController:bangVC title:Localized(@"榜单",nil) imageName:@"icon_list_22_nor" selectedImageName:@"icon_list_22_sel"];
    
    
    MessageVC *message = [[MessageVC alloc]init];

//    ML_MsgListVC *message = [[ML_MsgListVC alloc] init];
    [self setupChildViewController:message title:Localized(@"消息", nil) imageName:@"icon_news_22_nor" selectedImageName:@"icon_news_22_sel"];
    self.message = message;
    
    MLMineViewController *mine = [[MLMineViewController alloc] init];
    [self setupChildViewController:mine title:Localized(@"我的", nil) imageName:@"icon_my_22_sel" selectedImageName:@"icon_my_22_sel-155"];
}


- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
//    UINavigationController *navc = [[MLNavViewController alloc] initWithRootViewController:childVc];
//    navc.tabBarItem.title = title;
//    navc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    navc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [navc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: kZhuColor} forState:UIControlStateSelected];
//    [navc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]} forState:UIControlStateNormal];
//    childVc.navigationItem.title = title;
//    [self addChildViewController:navc];
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MLNavViewController *nav = [[MLNavViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //防止UITabbar上跳，这里重置一下
    self.tabBar.frame = CGRectMake(0, UIScreenHeight - UITabbarHeight, UIScreenWidth, UITabbarHeight);
}


- (void)allMessagesDeleted{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}

- (void)allMessagesRead
{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    self.systemUnreadCount = unreadCount;
//    [self refreshContactBadge];
}

#pragma mark - Notification
- (void)onCustomNotifyChanged:(NSNotification *)notification
{

    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

    if (userData.officialInfo) {
        NSDictionary *dic1 = userData.officialInfo[@"officialMsgInfo"];
        BOOL mag =  [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_shanMsgInfo", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]] boolValue];
        NSDictionary *newestMsgDic = dic1[@"newestMsg"];
        if (!mag) {
            self.customSystemUnreadCount += [newestMsgDic[@"notRead"] integerValue];
        }
    }
    
    self.customSystemUnreadCount -= [notification.object integerValue];
    if (self.customSystemUnreadCount < 0) {
        self.customSystemUnreadCount = 0;
    }
    
    [self refreshSessionBadge];
}

- (void)refreshSessionBadge{
    
    self.message.tabBarItem.badgeValue = (self.customSystemUnreadCount + self.sessionUnreadCount) ? @(self.customSystemUnreadCount + self.sessionUnreadCount).stringValue : nil;
}




#pragma mark - Rotate

//- (BOOL)shouldAutorotate{
//    BOOL enableRotate = [NTESBundleSetting sharedConfig].enableRotate;
//    return enableRotate ? [self.selectedViewController shouldAutorotate] : NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    BOOL enableRotate = [NTESBundleSetting sharedConfig].enableRotate;
//    return enableRotate ? [self.selectedViewController supportedInterfaceOrientations] : UIInterfaceOrientationMaskPortrait;
//}


@end
