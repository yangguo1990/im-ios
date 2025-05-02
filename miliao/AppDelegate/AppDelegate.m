//
//  AppDelegate.m
//  miliao
//
//  Created by apple on 2022/8/17.
// FB: 1185059072@qq.com Linbiyi123

#import "AppDelegate.h"
#import "MLTabbarViewController.h"
#import "MLLoginViewController.h"
#import "MLNavViewController.h"
#import "HY_AdViewController.h"
#import <YTKNetwork/YTKNetwork.h>
#import <AFNetworking/AFNetworking-umbrella.h>
#import "MLNetworkConfig.h"










#import "NSDictionary+NTESJson.h"


#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchResult.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "MLIPAddress.h"
#import <Foundation/Foundation.h>
#import "IPToolManager.h"
#import <SAMKeychain/SAMKeychain.h>
#import <SharetraceSDK/SharetraceSDK.h>
#import "ML_GetUserInfoApi.h"
#import "WXApi.h"
#import "WXPayTools.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AlipayVerifySDK/MPVerifySDKService.h>
#import <libCNamaSDK/FURenderer.h>
#import "authpack.h"
#import "ML_RequestManager.h"
#import <NTESQuickPass/NTESQuickPass.h>
//#import <UMCommon/UMCommon.h>
//#import <Bugly/Bugly.h>
#import <Colours/Colours.h>
#import "UIimage+ML.h"
#import "SiLiaoBack-Swift.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
@import PushKit;

NSString *NTESNotificationLogout = @"NTESNotificationLogout";
static BOOL isBackGroundActivateApplication;
//static BOOL isBackGroundDelayForNotificiton;

@interface AppDelegate ()<BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate,SharetraceDelegate, WXApiDelegate, JPUSHRegisterDelegate>


@property (nonatomic,strong) BMKLocationManager *locationManager;
@property (nonatomic, strong) BMKLocatingCompletionBlock completionBlock;
@property (nonatomic,strong)BMKMapManager *mapmanger;
@property (nonatomic,strong)NTESQuickLoginManager *manager;
@property (nonatomic,strong)NSString *strToken;

@property (nonatomic,strong)UIImage *_offlineImage;
@property (nonatomic,strong)UIImage *_busyImage;

@end

@implementation AppDelegate



- (UIImage *)offlineImage {
    if (self._offlineImage != nil) { return self._offlineImage; }
    NSDictionary *offlineAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#222222"]};
    UIColor *offlineColor = [UIColor colorWithHexString:@"#FFE4D6" alpha:0.9];
    CGSize offlineSize = CGSizeMake(48, 18);
    UIImage *image = [UIImage imageWithColor:offlineColor size: offlineSize text:@"离线" textAttributes:offlineAttr corner:6];
    self._offlineImage = image;
    return image;
}
- (UIImage *)busyImage {
    if (self._busyImage != nil) { return self._busyImage; }
    NSDictionary *offlineAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#222222"]};
    UIColor *offlineColor = [UIColor colorWithHexString:@"#FFE4D6" alpha:0.9];
    CGSize offlineSize = CGSizeMake(48, 18);
    UIImage *image = [UIImage imageWithColor:offlineColor size: offlineSize text:@"勿扰" textAttributes:offlineAttr corner:6];
    self._busyImage = image;
    return image;
}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)setupRootViewController:(UIViewController *)rootViewController {
    
    rootViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [UIView transitionWithView:self.window duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    } completion:nil];
    
    
    if (!self.gestureBaseView) {
        self.window.rootViewController = rootViewController;
        self.gestureBaseView = [[BBGestureBaseView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
        [self.window insertSubview:self.gestureBaseView atIndex:0];
    }else{
        [self.gestureBaseView removeObserver];
        self.window.rootViewController = rootViewController;
        [self.gestureBaseView addObserver];
        [self.window sendSubviewToBack:self.gestureBaseView];
    }
    
    self.gestureBaseView.hidden = YES;
    
}

- (void)hasNotiLunch
{
    
    if ([_Rob_euCnotiDic[@"aps"][@"msgType"] intValue] == 0 || [_Rob_euCnotiDic[@"aps"][@"msgType"] intValue] == 8) {
        POST_NOTIFICATION(@"tanchuChat", _Rob_euCnotiDic, nil);
    } else {
        
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSLog(@"receive remote notification:  %@", userInfo);
    
   // NSLog(@"********** iOS7.0之后 background **********");
    //杀死状态下，直接跳转到跳转页面。
    if (!isBackGroundActivateApplication)
    {
//        if (isBackGroundDelayForNotificiton) {
            _Rob_euCnotiDic = nil;
            self.Rob_euCnotiDic = userInfo;
            kSelf;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakself hasNotiLunch];
                [[NSNotificationCenter defaultCenter] removeObserver:@"tanchuChat"];
            });
            return;
//        }

        
    }
    
}

- (void)clearAppBadge
{

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    
    [self clearAppBadge];
    
    POST_NOTIFICATION(APPEnterForeground_NOT,nil,nil);

    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    
    NSString* token0;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 13.0) {
        // 针对 11.0 以上的iOS系统进行处理
        
        if (![deviceToken isKindOfClass:[NSData class]]) return;
        const unsigned *tokenBytes = [deviceToken bytes];
        NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        NSLog(@"deviceToken:%@",hexToken);
        token0 = hexToken;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        
        
        NSString *strToken = [NSString stringWithFormat:@"%@",deviceToken];
        NSMutableString * token = [[NSMutableString alloc] initWithString:strToken];
        [token replaceOccurrencesOfString:@"<" withString:@"" options:0 range:NSMakeRange(0, [token length])];
        [token replaceOccurrencesOfString:@">" withString:@"" options:0 range:NSMakeRange(0, [token length])];
        [token replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, [token length])];
        token0 = token;
    }
    
    
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
    
    //sdk注册DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];

}

- (void)registerPushService
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
             [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
   
                 if(settings.authorizationStatus == UNAuthorizationStatusDenied) {
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NotTongQuan"];
                 } else {
                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NotTongQuan"];
                 }
             }];
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else{
        //apns
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NotTongQuan"];
        } else {
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NotTongQuan"];
        }
        
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    
    
      [[IQKeyboardManager sharedManager] setEnable:YES];
      [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
      [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
      [application setStatusBarStyle:UIStatusBarStyleDefault];
    
//    [UMConfigure initWithAppkey:@"640c594ed64e68613948207e" channel:@"nil"];

    
    [self setupMainViewController];
    [self.window makeKeyAndVisible];
    HttpDnsService *httpdns = [[HttpDnsService alloc] initWithAccountID:916172 secretKey:@"4a9323973eb04882e657651a2f0b926f"];
//    HttpDnsService *httpdns = [[HttpDnsService alloc] initWithAccountID:140006 secretKey:@"010dabff7c8d6f5b0ded877a832ef679"];
        // 若开启了鉴权访问，则需要到控制台获得鉴权密钥并在初始化时进行配置
        // HttpDnsService *httpdns = [[HttpDnsService alloc] initWithAccountID:xxxxxx secretKey:@"your secret key"];

        // 打开日志，调试排查问题时使用
        [httpdns setLogEnabled:NO];

        // 设置httpdns域名解析网络请求是否需要走HTTPS方式
        [httpdns setHTTPSRequestEnabled:YES];

        // 设置开启持久化缓存，使得APP启动后可以复用上次活跃时缓存在本地的IP，提高启动后获取域名解析结果的速度
        [httpdns setPersistentCacheIPEnabled:YES];

        // 设置允许使用已经过期的IP，当域名的IP配置比较稳定时可以使用，提高解析效率
        [httpdns setReuseExpiredIPEnabled:NO];

        // 设置底层HTTPDNS网络请求超时时间，单位为秒
        [httpdns setTimeoutInterval:2];

        // 设置是否支持IPv6地址解析，只有开启这个开关，解析接口才有能力解析域名的IPv6地址并返回
        [httpdns setIPv6Enabled:NO];
    
    return YES;
}
- (void)setOther
{
    
//    [WXApi registerApp:@"wx47ed39b0ce916f97" universalLink:@"https://your_domain/app/"];
    
    [Sharetrace initWithDelegate:self];
    
    [MLNetworkConfig networkConfig];
    

    [MPVerifySDKService initSDKService];
    

    
}




#pragma mark BMKLocationkit-----

-(void)BMKLocationkit{

    IPToolManager *ipManager = [IPToolManager sharedManager];
    NSString *address = [ipManager currentIpAddress];
    NSLog(@"获取具体的ip地址---%@",address);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:address forKey:@"ipaddr"];
    [defaults synchronize];
    
    NSString *sss =  [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSLog(@"保存唯一识别码---%@",sss);
    BOOL isopend = [SAMKeychain setPassword:sss forService:@"信息" account:@"key"];
    if (isopend) {
        NSLog(@"保存成功");
    }
    
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertView class]]] setTintColor:kZhuColor]; [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]] setTintColor:kZhuColor];
    
    
// 旧：ykT8O6SoOGik7hFGgbFIr6l06ve2D9RI yXwn6Z4sXU2oavbM8PfWXNAzy0LgUEHu
    [[BMKLocationAuth sharedInstance] setAgreePrivacy:YES];
    [BMKMapManager setAgreePrivacy:YES];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"dcYAsskR8aDHVZBVH6RLbipVp3JqCxgj" authDelegate:self];
//    dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
        BMKMapManager *mapmanger = [BMKMapManager sharedInstance];
        BOOL ret = [mapmanger start:@"dcYAsskR8aDHVZBVH6RLbipVp3JqCxgj" generalDelegate:self];
        //NSLog(@"ret %@",ret);
        if (!ret) {
            NSLog(@"manager start failed!");
        }

}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{

    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    
    return [Sharetrace handleUniversalLink:userActivity];
}


//iOS9以下
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
        // 处理微信的支付结果
            return [WXApi handleOpenURL:url delegate:self];
    }

    return [Sharetrace handleSchemeLinkURL:url];

}

//iOS9及以上
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary *)options {

    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
            
        }];
    } else if ([url.host isEqualToString:@"pay"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
        // 处理微信的支付结果
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return [Sharetrace handleSchemeLinkURL:url];

}

- (void)getWakeUpTrace:(AppData * _Nullable)appData {
    if (appData != nil) {
        NSString *info = [NSString stringWithFormat:@"appData: \n %@,  %@", appData.paramsData, appData.channel];
        NSLog(@"getWakeUpTrace Success, %@", info);
    } else {
        NSLog(@"getWakeUpTrace nil");
    }
}

- (void)setupMainViewController
{
   
    
    
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([currentData.userId length] && [currentData.token length])
    {
//        [self setupCallKit];
           [self registerPushService];

           [self ML_netGetPopData];


           
           kSelf;
           dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
               [weakself BMKLocationkit];
//               [weakself giveONEkeyLogin];
           });
           
           [self commonInitListenEvents];

           [self setOther];
        
//        NSLog(@"NIM自动登录====%@===%@");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoLogin"];
        

        
        MLNavViewController *nav = [[MLNavViewController alloc]initWithRootViewController:[[HY_AdViewController alloc] initWithIsLua:YES]];
        self.window.rootViewController = nav;
        

    } else {
        [self BMKLocationkit];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"autoLogin"];
        [self setupLoginViewController];
    }
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    
//    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}


- (void)setupLoginViewController
{
//    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    MLNavViewController *nav = [[MLNavViewController alloc]initWithRootViewController:[[HY_AdViewController alloc]init]];
    self.window.rootViewController = nav;
//    self.window.rootViewController = [HY_AdViewController new];
    
}



#pragma mark - 注销
-(void)logout:(NSNotification *)note
{
    [UserCenter logout];
}


- (void)doLogout
{
    
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"info_edit"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"autoLogin"];
    [ML_AppUserInfoManager sharedManager].currentLoginUserData = nil;
//    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
//    [[NTESServiceManager sharedManager] destory];
   
    [self setupLoginViewController];
}


#pragma NIMLoginManagerDelegate

- (void)onAutoLoginFailed:(NSError *)error
{
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    NSLog(@"onAutoLoginFailed %zd",error.code);
    [self showAutoLoginErrorAlert:error];
}


#pragma mark - logic impl


- (void)applicationDidEnterBackground:(UIApplication *)
application {
    
    [self tongzhiquanxian];
}

- (void)tongzhiquanxian
{
    ///判断通知权限是否已开启
    if (@available(iOS 10.0, *)) {
        
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
                NSLog(@"adsf======88==%ld", settings.authorizationStatus);
                
                              if(settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                                  // 用户未授权开启通知
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NotTongQuan"];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaTong" object:nil];
                                  });
                              } else {
                                  //用户已授权开启通知
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NotTongQuan"];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaTong" object:nil];
                                   
                                  });
                              }
                
            }];
        
            
        } else {
            //iOS 10 以下系统版本询权方式
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   ///未开启通知
//                    isOpenNoti = NO;
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NotTongQuan"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaTong" object:nil];
                  
                  //更新列表数组的数量和内容（比如通知这一行数据还要不要）
                      //刷新列表
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ///用户已开启通知功能
//                    isOpenNoti = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NotTongQuan"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaTong" object:nil];
                    //更新列表数组的数量和内容（比如通知这一行数据还要不要）
                      //刷新列表
                });
            }
        }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        isBackGroundDelayForNotificiton = NO;
    });
    
    
}


- (void)ML_netGetPopData
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript",@"text/html",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"https://result.eolink.com/hw2mCQ8e5e4c4eba45c258b95b51f822b56ac6522c7874c?uri=/initWithMiliao" parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *content = [NSDictionary parseJSONStringToNSDictionary:jsonString];
            
            [ML_AppConfig sharedManager].configDic = content;
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}


#pragma mark - 登录错误回调
- (void)showAutoLoginErrorAlert:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
    
}


-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

- (void)getUserInfoWithResult:(NSString *)userId
{

}

-(void)shareFacebook:(NSDictionary*)dic{
    
    NSString *head_url =@"http://basefile.updrips.com/040878404B5255_1570985004454_79ca5cea-4800-4108-bc01-3589fff65ba0";
    NSURL *temp_url = [NSURL URLWithString:head_url];
    NSData *temp_image_data =[NSData dataWithContentsOfURL:temp_url];
//    [dic setValue:@"shareMessengerWithImageData" forKey:@"method"];[dic setValue:temp_image_data forKey:@"imageData"];
    [dic setValue:@"shareMessengerWithImageUrl" forKey:@"method"];[dic setValue:head_url forKey:@"imageUrl"];
    NSString *method = [dic objectForKey:@"method"];
    UIImage *image =nil;
    UIViewController *viewController = [[UIViewController alloc] init];
    if([method isEqualToString:@"shareMessengerWithImageData"]){//二进制图片分享
        NSURL *imageBase64 = [NSURL URLWithString:[dic objectForKey:@"imageData"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageBase64];
        image = [UIImage imageWithData:imageData];
        UIImage *shareImage = image;
        NSArray *activityItems = @[shareImage];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = nil;
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            NSLog(@"activityType: %@,\ncompleted: %d,\nreturnedItems:%@,\nactivityError:%@",activityType,completed,returnedItems,activityError);
        };
        [viewController presentViewController:activityVC animated:YES completion:nil];
    }else if([method isEqualToString:@"shareMessengerWithImageUrl"]){//图片链接分享
        NSString *imageUrl = [dic objectForKey:@"imageUrl"];
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *image_data =[NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:image_data];
        UIImage *shareImage = image;
        NSArray *activityItems = @[shareImage];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = nil;
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            NSLog(@"activityType: %@,\ncompleted: %d,\nreturnedItems:%@,\nactivityError:%@",activityType,completed,returnedItems,activityError);
        };
        [viewController presentViewController:activityVC animated:YES completion:nil];
    }
}


@end
