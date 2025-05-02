//  希望您的举手之劳，能为我点颗赞，谢谢~
//  代码地址: https://github.com/Bonway/BBGestureBack
//  BBGestureBack
//  Created by Bonway on 2016/3/17.
//  Copyright © 2016年 Bonway. All rights reserved.
//


#import "ML_BaseVC.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "BBGestureBackConst.h"
#import "ML_CollectionViewFlowLayout.h"
//#import "ML_HostdetailsViewController.h"

static char bbListenTabbarViewMove[] = "bbListenTabbarViewMove";

@interface ML_BaseVC ()

//@property (nonatomic,strong)UIBarButtonItem *bbBackBarItem;

@end

@implementation ML_BaseVC

//static BOOL isHideNavBar_ = YES;
static NSString *const JPSuspensionCacheMsgKey = @"JPSuspensionCacheMsgKey";
static NSString *const JPSuspensionDefaultXKey = @"JPSuspensionDefaultXKey";
static NSString *const JPSuspensionDefaultYKey = @"JPSuspensionDefaultYKey";

- (id)init{
    self = [super init];
    if (self) {
        self.isEnablePanGesture = YES;
        self.blankType = BBPopTypeViewController;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    // 黑色
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault; //黑色,默认值
    }
    
}

//- (void)setupJPSEInstance {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        // 是否可以播放提示音
//        JPSEInstance.canPlaySound = YES;
//        
////        // 配置展开时的提示音
////        JPSEInstance.playSpreadSoundBlock = ^{
////
////        };
////
////        // 配置闭合时的提示音
////        JPSEInstance.playShrinkSoundBlock = ^{
////
////        };
//        
//        JPSEInstance.cacheMsgBlock = ^(NSString *cacheMsg) {
//            [[NSUserDefaults standardUserDefaults] setObject:cacheMsg forKey:JPSuspensionCacheMsgKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        };
//        
//        JPSEInstance.cacheSuspensionFrameBlock = ^(CGRect suspensionFrame) {
//            [[NSUserDefaults standardUserDefaults] setFloat:suspensionFrame.origin.x forKey:JPSuspensionDefaultXKey];
//            [[NSUserDefaults standardUserDefaults] setFloat:suspensionFrame.origin.y forKey:JPSuspensionDefaultYKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        };
//        
//    });
//}
//
//- (void)setupSuspensionView {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        NSString *cachaMsg = [[NSUserDefaults standardUserDefaults] stringForKey:JPSuspensionCacheMsgKey];
//        if (cachaMsg) {
//            NECallViewController *vc = [[NECallViewController alloc] init];
//            
//            [vc.navigationController setNavigationBarHidden:YES];
////            vc.title = cachaMsg;
////            vc.isHideNavBar = YES;
//            CGFloat x = [[NSUserDefaults standardUserDefaults] floatForKey:JPSuspensionDefaultXKey];
//            CGFloat y = [[NSUserDefaults standardUserDefaults] floatForKey:JPSuspensionDefaultYKey];
//            [JPSEInstance setupSuspensionViewWithTargetVC:vc suspensionXY:CGPointMake(x, y)];
//        }
//        
//    });
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([ML_AppUtil isCensor] && @available(iOS 13.0, *)) {
        
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
//    self.isEnablePanGesture = YES;
//    self.blankType = BBPopTypeViewController;
    
//    [self setupJPSEInstance];
//    [self setupSuspensionView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0, *)) {
        
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [[UITableView appearance] setEstimatedRowHeight:0];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0];
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
        
        [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
   
   UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight)];
   [self.view addSubview:bgImageView];
   bgImageView.hidden = YES;
   [self.view sendSubviewToBack:bgImageView];
   self.ML_bgImageView = bgImageView;
   
   
   [self ML_setUpCustomNavklb_la];
   
   
   if (self.navigationController.childViewControllers.count > 1) {
       bgImageView.frame = CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight);
       self.tabBarController.tabBar.hidden = YES;
       self.ML_backBtn.hidden = NO;
   }
}
- (void)ML_addNavRightBtnWithTitle:(NSString *)title image:(UIImage *)image
{
    [self.ML_rightBtn setImage:image forState:UIControlStateNormal];
    [self.ML_rightBtn setTitle:title forState:UIControlStateNormal];
}
- (void)ML_rightItemClicked
{
}
- (void)HY_addTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - SSL_TabbarHeight) style:UITableViewStylePlain];
    if (self.navigationController.childViewControllers.count > 1) {
        tableView.frame = CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight);
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.ML_TableView = tableView;
}

- (void)ML_addCollectionView
{
    ML_CollectionViewFlowLayout * layout = [[ML_CollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.sectionInset = UIEdgeInsetsMake(16, 26, 0, 16);
////    layout.minimumLineSpacing = 0;
//
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 20;
    
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ML_NavViewHeight, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight) collectionViewLayout:layout];
    collect.backgroundColor = [UIColor clearColor];
    collect.delegate=self;
    collect.dataSource=self;
    [self.view addSubview:collect];
    
    self.collectionView = collect;
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    JPSEInstance.navCtr = self.navigationController;
//    kSelf;
//    __weak typeof(self) weakSelf = self;
//    JPSEInstance.willSpreadSuspensionViewControllerBlock = ^(UIViewController<JPSuspensionEntranceProtocol> *targetVC) {
////        [(NECallViewController *)targetVC setIsHideNavBar:YES];
////        [(NECallViewController *)targetVC setRightBtnTitle:@"取消浮窗"];
//        JPSEInstance.isHideNavBar = YES;
//        
//        [weakself.navigationController setNavigationBarHidden:YES];
//        
//        
//    };
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:self.ML_navView];
}
- (void)ML_setUpCustomNavklb_la
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_NavViewHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: navView];
//    [self.view bringSubviewToFront: navView];
    self.ML_navView = navView;
    
    UIView *alphaView = [[UIView alloc] initWithFrame:navView.bounds];
//    alphaView.backgroundColor = [UIColor clearColor];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0;
    [navView addSubview: alphaView];
    self.ML_navAlphaView = alphaView;
    
    // icon_back_24_FFF_nor
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ML_NavViewHeight - 44, 50, 44)];
    [backBtn addTarget:self action:@selector(ML_backClickklb_la) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor_1"] forState:UIControlStateNormal];
    [navView addSubview: backBtn];
    backBtn.hidden = YES;
    self.ML_backBtn = backBtn;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, backBtn.y, ML_ScreenWidth - 130, backBtn.height)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = self.tabBarItem.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]; // 字重
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview: titleLabel];
    [navView bringSubviewToFront:titleLabel];
    self.ML_titleLabel = titleLabel;
    UIButton *rightCustomButton = [[UIButton alloc] init];
    rightCustomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightCustomButton addTarget:self action:@selector(ML_rightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    rightCustomButton.titleLabel.font = kGetFont(14);
    [rightCustomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightCustomButton.contentMode = UIViewContentModeRight;
    rightCustomButton.frame = CGRectMake(ML_ScreenWidth - 80, ML_NavViewHeight - 44, 60, 44);
    self.ML_rightBtn = rightCustomButton;
    [self.ML_navView addSubview:rightCustomButton];
    
}

//-(UIBarButtonItem *)bbBackBarItem{
//    if (!_bbBackBarItem) {
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setImage:[UIImage imageNamed:@"bb_navigation_back"] forState:UIControlStateNormal];
//        backBtn.imageView.contentMode = UIViewContentModeCenter;
//        [backBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
//        _bbBackBarItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//        backBtn.frame = CGRectMake(0, 0, 44, 44);
//        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0,0);
//    }
//    return _bbBackBarItem;
//}

- (void)ML_backClickklb_la{
    
    switch (self.blankType) {
        case BBPopTypeViewController:
            [self bb_popViewController];
            break;
        case BBPopTypeToRootViewController:
            [self bb_popToRootViewController];
            break;
        default:
            break;
    }
    
    
}



-(void)bb_basePopViewController:(UIViewController *)viewController PopType:(BBPopType)popType{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootVC = appDelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    appDelegate.gestureBaseView.hidden = NO;
    
    appDelegate.gestureBaseView.NmaskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:kBBMaskingAlpha];
    appDelegate.gestureBaseView.imgView.transform = CGAffineTransformMakeScale(kBBWindowToScale, kBBWindowToScale);
    
    [UIView animateWithDuration:kBBGestureSpeed animations:^{
        rootVC.view.transform = CGAffineTransformMakeTranslation(([UIScreen mainScreen].bounds.size.width), 0);
        presentedVC.view.transform = CGAffineTransformMakeTranslation(([UIScreen mainScreen].bounds.size.width), 0);
        if (BBIS_IPHONEX && kBBIsOpenIphoneXStyle) {
            rootVC.view.layer.masksToBounds = YES;
            rootVC.view.layer.cornerRadius = kBBIphoneXStyleCorner;
            presentedVC.view.layer.masksToBounds = YES;
            presentedVC.view.layer.cornerRadius = kBBIphoneXStyleCorner;
        }
    } completion:^(BOOL finished) {
        switch (popType) {
            case BBPopTypeViewController:
                if (self.navigationController.viewControllers.count>0) {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
//                [self.navigationController popViewControllerAnimated:NO];
                break;
            case BBPopTypeToViewController:
                [self.navigationController popToViewController:viewController animated:NO];
                break;
            case BBPopTypeToRootViewController:
                [self.navigationController popToRootViewControllerAnimated:NO];
                break;
            default:
                break;
        }
        rootVC.view.transform = CGAffineTransformIdentity;
        presentedVC.view.transform = CGAffineTransformIdentity;
        if (BBIS_IPHONEX && kBBIsOpenIphoneXStyle) {
            rootVC.view.layer.masksToBounds = NO;
            rootVC.view.layer.cornerRadius = 0;
            presentedVC.view.layer.masksToBounds = NO;
            presentedVC.view.layer.cornerRadius = 0;
        }
        appDelegate.gestureBaseView.hidden = YES;
        
    }];
}

- (void)bb_popViewController{
    [self bb_basePopViewController:nil PopType:BBPopTypeViewController];
}

-(void)bb_popToRootViewController{
    [self bb_basePopViewController:nil PopType:BBPopTypeToRootViewController];
}

-(void)bb_popToViewController:(UIViewController *)viewController{
    [self bb_basePopViewController:viewController PopType:BBPopTypeToViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
@interface BBGestureBaseView()
@property(nonatomic,weak)UIView *rootControllerView;
@end

@implementation BBGestureBaseView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.arrayImage = [NSMutableArray array];
        self.backgroundColor = [UIColor blackColor];
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        if (BBIS_IPHONEX && kBBIsOpenIphoneXStyle) {
            self.imgView.layer.masksToBounds = YES;
            self.imgView.layer.cornerRadius = kBBIphoneXStyleCorner;
        }
        self.NmaskView = [[UIView alloc] initWithFrame:self.bounds];
        self.NmaskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:kBBMaskingAlpha];
        [self addSubview: self.imgView];
        [self addSubview: self.NmaskView];
        [self addObserver];
    }
    return self;
}

- (void)removeObserver {
    [self.rootControllerView removeObserver:self forKeyPath:@"transform" context:bbListenTabbarViewMove];
}

- (void)addObserver {
    self.rootControllerView = [AppDelegate shareAppDelegate].window.rootViewController.view;
    [self.rootControllerView addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:bbListenTabbarViewMove];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == bbListenTabbarViewMove){
        NSValue *value  = [change objectForKey:NSKeyValueChangeNewKey];
        CGAffineTransform newTransform = [value CGAffineTransformValue];
        [self showEffectChange:CGPointMake(newTransform.tx, 0) ];
    }
}

- (void)showEffectChange:(CGPoint)pt{
    
    if (pt.x > 0){
        _NmaskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-pt.x / ([UIScreen mainScreen].bounds.size.width) * kBBMaskingAlpha + kBBMaskingAlpha];
        _imgView.transform = CGAffineTransformMakeScale(kBBWindowToScale + (pt.x / ([UIScreen mainScreen].bounds.size.width) * (1 - kBBWindowToScale)), kBBWindowToScale + (pt.x / ([UIScreen mainScreen].bounds.size.width) * (1 - kBBWindowToScale)));
    }
    if (pt.x < 0){
        _NmaskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
        _imgView.transform = CGAffineTransformIdentity;
    }
}

- (void)restore {
    if (_NmaskView && _imgView){
        _NmaskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:kBBMaskingAlpha];
        _imgView.transform = CGAffineTransformMakeScale(kBBWindowToScale, kBBWindowToScale);
    }
}

- (void)screenShot{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), YES, 0);
    [appDelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    self.imgView.image = sendImage;
    self.imgView.transform = CGAffineTransformMakeScale(kBBWindowToScale, kBBWindowToScale);
}

- (void)dealloc{
    [self removeObserver];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
@end
