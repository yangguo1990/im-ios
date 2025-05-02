#import "HY_AdViewController.h"
#import "MLTabbarViewController.h"
#import "MLLoginViewController.h"
#import<CoreTelephony/CTCellularData.h>
#import <AFNetworking/AFNetworking-umbrella.h>
#import "MLNavViewController.h"

#import "ML_GetUserInfoApi.h"
#import "SiLiaoBack-Swift.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "ML_RequestManager.h"
#import "MLNetworkConfig.h"
@interface HY_AdViewController ()
@property (nonatomic, assign)BOOL mallConfigModel;
@property (nonatomic, assign)BOOL isLua;
@property (nonatomic,strong)NSArray *ossUrls;
@property (nonatomic,assign)NSInteger index;
@end
@implementation HY_AdViewController

- (instancetype)initWithIsLua:(BOOL)isLua
{
    self = [super init];
    if (self) {
        self.isLua = isLua;
    }
    return self;
}

-(NSArray*)randomSortArray:(NSArray*)array{
    NSMutableArray *randomizedArray = [array mutableCopy];
    NSUInteger i = randomizedArray.count;
    while (--i > 0) {
        int j = arc4random()%(i+1);
        [randomizedArray exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    return randomizedArray;
}


- (void)getOssurl{
    [SVProgressHUD showWithStatus:@"加载中,请耐心等候..."];
    [self httpDns];
    return;
    NSArray *ossaddress = @[@"https://domain3.oss-accelerate.aliyuncs.com/data/domain/smt/domain1.txt",@"https://domain4.oss-accelerate.aliyuncs.com/data/domain/smt/domain1.txt"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager GET:ossaddress[0] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject is %@",responseObject);
        self.ossUrls = [self randomSortArray:responseObject];//@[@"api.liaotianba.xyz",@"app.liaotianba.pro",@"yyin.liaotianba.pro"];//
        NSLog(@"ossurls is %@",self.ossUrls);
        [self httpDns];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [manager GET:ossaddress[1] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseobject is %@",responseObject);
            self.ossUrls = responseObject;
            [self httpDns];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"远程配置获取失败,请重新启动app"];
        }];
    }];
}

- (void)httpDns{
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    HttpdnsResult *result = [httpdns resolveHostSyncNonBlocking:self.ossUrls[self.index] byIpType:HttpdnsQueryIPTypeAuto];
    if (result) {
        NSLog(@"result is %@",result);
        NSString *url = self.ossUrls[self.index];
        [ML_AppUserInfoManager sharedManager].host = url;
        NSUInteger count = result.ips.count;
//        int i = arc4random()%count;
        NSString * ip = result.firstIpv4Address;
        NSString *baseUrl = [NSString stringWithFormat:@"https://%@",url];
        AFHTTPSessionManager *manager = [ML_RequestManager sharedAfnManager];
        [manager.requestSerializer setValue:url forHTTPHeaderField:@"host"];

        [manager GET:baseUrl parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [ML_AppUserInfoManager sharedManager].hostip = baseUrl;
            [ML_AppUserInfoManager sharedManager].host = url;
            [self getUrlSuccess];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.index++;
            if (self.index < self.ossUrls.count) {
                [self httpDns];
            }else{
                [ML_AppUserInfoManager sharedManager].hostip = @"http://120.79.207.69:8848";
                [ML_AppUserInfoManager sharedManager].host = @"api.z4wmuct.com";
                [self getUrlSuccess];
            }
        }];
        
    } else {
        self.index++;
        if (self.index < self.ossUrls.count) {
            [self httpDns];
        }else{
            [ML_AppUserInfoManager sharedManager].hostip = @"http://120.79.207.69:8848";
            [ML_AppUserInfoManager sharedManager].host = @"api.z4wmuct.com";
            [self getUrlSuccess];
        }
    }
}

- (void)getUrlSuccess{
    NSLog(@"server url is %@",[ML_AppUserInfoManager sharedManager].hostip);
    NSLog(@"server url is %@",[ML_AppUserInfoManager sharedManager].host);
    [MLNetworkConfig networkConfig];
    if (self.isLua) {
        self.ML_bgImageView.image = kGetImage(@"dclangu");
        
        [SVProgressHUD show];

        
//        [[AppDelegate shareAppDelegate] setupCallKit];
        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        kSelf;
        ML_GetUserInfoApi *api = [[ML_GetUserInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token?:@"" extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"我的信息---%@",response.data);
            UserInfoData * loginCurrentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

            UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response.data[@"user"]];
            if (response.data[@"pay"]) {
                currentData.alipay_U = [NSString stringWithFormat:@"%@", response.data[@"pay"][@"alipay"]];
                currentData.wxpay_U = [NSString stringWithFormat:@"%@", response.data[@"pay"][@"wxpay"]];
            }
            currentData.domain = loginCurrentData.domain;
            currentData.thirdId = loginCurrentData.thirdId;
            currentData.imToken = loginCurrentData.imToken;
            currentData.must = loginCurrentData.must;
            currentData.token = loginCurrentData.token;
            currentData.userId = loginCurrentData.userId;
            currentData.wxPay = loginCurrentData.wxPay;
            [UserCenter updateUserInfo];
            
            [UserCenter loginAlreadyWithCompletion:^(BOOL x) {
                if(x){
                    //im登录成功
                    MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
                    });
                }else{
                    //im登录失败
                    [KEY_WINDOW.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                    MLNavViewController *nav = [[MLNavViewController alloc]initWithRootViewController:[[MLLoginViewController alloc]init]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        KEY_WINDOW.window.rootViewController = nav;
                    });
                    
                }
            }];

        } error:^(MLNetworkResponse *response) {
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户信息更新失败:%@ 请重新启动app",response.msg]];
        } failure:^(NSError *error) {
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"用户信息更新失败:%@ 请重新启动 app",error.localizedDescription]];
        }];
    } else {
        self.ML_bgImageView.image = kGetImage(@"001_deng_bg");
        [self HY_netGetPopData];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.index = 0;
    [self getOssurl];
        self.ML_navView.hidden = YES;
        self.ML_bgImageView.frame = self.view.bounds;
        self.ML_bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.ML_bgImageView.hidden = NO;
    self.ML_bgImageView.image = kGetImage(@"001_deng_bg");
    
}

- (void)HY_netGetPopData
{
    
    if (__IPHONE_10_0) {
        [self networkStatusDidFinishLaunchingWithOptions];
    }else {
        //2.2已经开启网络权限 监听网络状态
        [self addReachabilityManagerDidFinishLaunchingWithOptions];
    }
      
    
}

/*
 CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题
 获取网络权限状态
 */
- (void)networkStatusDidFinishLaunchingWithOptions {
    //2.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
      
    /*
     此函数会在网络权限改变时再次调用
     */
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestricted:
                  
                NSLog(@"Restricted");
                //2.1权限关闭的情况下 再次请求网络数据会弹出设置网络提示
        
                break;
            case kCTCellularDataNotRestricted:
                  
                NSLog(@"NotRestricted");
                //2.2已经开启网络权限 监听网络状态
                [self addReachabilityManagerDidFinishLaunchingWithOptions];
//                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            case kCTCellularDataRestrictedStateUnknown:
                  
                NSLog(@"Unknown");
                //2.3未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
           
                break;
                  
            default:
                break;
        }
    };
}
  
/**
 实时检查当前网络状态
 */
- (void)addReachabilityManagerDidFinishLaunchingWithOptions{
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
      
    //这个可以放在需要侦听的页面
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                if (!self.mallConfigModel) {
                    self.mallConfigModel = YES;
                   [self getInfo_applicationDidFinishLaunchingWithOptions];
                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                if (!self.mallConfigModel) {
                    self.mallConfigModel = YES;
                   [self getInfo_applicationDidFinishLaunchingWithOptions];
                }
                break;
            }
            default:
                break;
        }
    }];
      
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}
  
- (void)getInfo_applicationDidFinishLaunchingWithOptions {
      
   
    [[AppDelegate shareAppDelegate] registerPushService];
    
    [[AppDelegate shareAppDelegate] setOther];
    
    [[AppDelegate shareAppDelegate] ML_netGetPopData];
    


    
    [[AppDelegate shareAppDelegate] commonInitListenEvents];
//    [[AppDelegate shareAppDelegate].window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    MLNavViewController *nav = [[MLNavViewController alloc] initWithRootViewController:[[MLLoginViewController alloc]init]];

    
    [[AppDelegate shareAppDelegate] setupRootViewController:nav];
}


@end
