//4654
//  AppDelegate.h
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import <UIKit/UIKit.h>
#import "ML_BaseVC.h"

#define HAS_LUNCH_NOTIFICATION_NOTI    @"HAS_LUNCH_NOTIFICATION_NOTI"
#define APPEnterForeground_NOT   @"APPEnterForeground_NOT"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) BBGestureBaseView *gestureBaseView;
@property (strong, nonatomic) UIWindow * window;
@property (nonatomic, strong) NSDictionary *Rob_euCnotiDic;   //远程推送信息
@property (nonatomic,assign)BOOL canOpenNotification; //!< 可以通过通知打开页面
+ (AppDelegate* )shareAppDelegate ;
- (void)setupRootViewController:(UIViewController *)rootViewController;
- (void)setupMainViewController;
- (void)registerPushService;
- (void)ML_netGetPopData;
- (void)setupNIMSDK;
- (void)setupServices;
- (void)BMKLocationkit;
//- (void)giveONEkeyLogin;
- (void)commonInitListenEvents;
- (void)setOther;
- (void)setupLoginViewController;
- (void)setupCallKit;


- (UIImage *)offlineImage;
- (UIImage *)busyImage;

- (void)doLogout;

@end

