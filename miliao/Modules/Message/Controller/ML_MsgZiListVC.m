//
//  ML_MsgListVC.m
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import "ML_MsgZiListVC.h"
#import "MLRecommendViewController.h"
#import "MLCityViewController.h"
#import "MLOnlineViewController.h"
#import "MLNewpersonViewController.h"
#import "MLFocusViewController.h"
#import "MLSearchViewController.h"
#import "ML_dynamicViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "UIImage+ML.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESSessionListViewController.h"
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>
//#import <BaiduMapAPI_Search/BMKGeocodeSearchResult.h>
//#import <BMKLocationkit/BMKLocationComponent.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ML_HaoyouListVC.h"
#import <SharetraceSDK/SharetraceSDK.h>
#import "NSString+ML_MineVersion.h"
#import "MLNewestVersionShowView.h"
#import "UIViewController+MLHud.h"
#import "MLHomeOneZhaohuView.h"
#import "MLHomeOnlineBottomView.h"
#import "ML_GetUserInfoApi.h"
#import "MLHomeOnlineViewController.h"
#import "WKWebViewController.h"
#import <AFNetworking/AFNetworking-umbrella.h>

@interface ML_MsgZiListVC ()<JXCategoryViewDelegate/*,BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate*/>
@property (nonatomic,strong)NSArray *titlearray;
@property (nonatomic, strong) NSArray *titleArr;// 标题数据
@property (nonatomic,strong)JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//listView
@property (nonatomic, weak) UIViewController *showingChildVc;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIImageView *bgimg;
@property (nonatomic,strong)MLNewestVersionShowView *versionShowView;
@property (nonatomic,strong)UIView *maskView;
//@property (nonatomic,strong) BMKLocationManager *locationManager;
@property (nonatomic,strong)MLHomeOneZhaohuView *oneZhaohuView;
@end

@implementation ML_MsgZiListVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    self.ML_navView.hidden = YES;
    
    POST_NOTIFICATION(@"showMoreBtn", @(self.index), nil);
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}


//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    self.ML_navView.hidden = YES;
//    self.bgimg = [[UIImageView alloc]init];
//    self.bgimg.userInteractionEnabled = YES;
////    self.bgimg.image = [UIImage imageNamed:@"bg"];
//    self.bgimg.image = [UIImage imageNamed:@"029abg"];
//    [self.view addSubview:self.bgimg];
//    CGSize csi = self.bgimg.image.size;
//    CGFloat bH = ML_ScreenWidth * csi.height / csi.width;
//    [self.bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.mas_equalTo(0);
////        make.height.mas_equalTo(112);
//        make.height.mas_equalTo(bH);
//    }];
    
    
//    UIButton *searchImg = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchImg.hidden = YES;
//    [searchImg setImage:[UIImage imageNamed:@"icon_sessionlist_more_normal"] forState:UIControlStateNormal];
//    [searchImg addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgimg addSubview:searchImg];
//    [searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.bgimg.mas_right).mas_offset(-12);
////        make.top.mas_equalTo(self.bgimg.mas_bottom).mas_offset(-21);
//        make.top.mas_equalTo(self.bgimg.mas_top).mas_offset(68);
//
//        make.width.height.mas_equalTo(24);
//    }];
    
    self.categoryView = [[JXCategoryDotView alloc]init];

    
    self.categoryView.titles = @[Localized(@"聊天", nil), Localized(@"好友", nil)];
    
    self.categoryView.titleColor = [UIColor colorFromHexString:@"#333333"];
//    self.categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.categoryView.titleFont = [UIFont systemFontOfSize:16];
    self.categoryView.cellSpacing = 28;

    self.categoryView.titleLabelZoomEnabled = YES;
    
    self.categoryView.titleLabelStrokeWidthEnabled = YES;
    self.categoryView.titleLabelSelectedStrokeWidth = -4;
    self.categoryView.titleSelectedColor = [UIColor colorFromHexString:@"#333333"];
    self.categoryView.titleColorGradientEnabled = NO;
    self.categoryView.titleLabelZoomScale = 1.3;
    self.categoryView.titleLabelVerticalOffset = 0;
    
    JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
    lineView.indicatorImageView.image = kGetImage(@"icon_pagination_4");
//    lineView.indicatorColor = kZhuColor;
//    //lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorWidth = 17;
    lineView.indicatorHeight = 5;
    self.categoryView.indicators = @[lineView];
    lineView.indicatorImageView.frame = CGRectMake(10, 10, 12, 4);
//    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
//    lineView.verticalMargin = 12;
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20).mas_offset(0);
//        make.right.mas_equalTo(searchImg.mas_left).mas_offset(-32);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(0);
    }];
    
    [self setupChildVces];
    self.index = 0;
    [self switchVC:self.index];
    
}
- (void)setupChildVces{
    
    NTESSessionListViewController *cityvc = [[NTESSessionListViewController alloc]init];
    [self addChildViewController:cityvc];
    
    ML_HaoyouListVC *recommendvc = [[ML_HaoyouListVC alloc] init];
    [self addChildViewController:recommendvc];
    
 }

#pragma mark --- JXCategoryViewDelegate ------
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [self switchVC:index];
    self.index = index;
    
    
    POST_NOTIFICATION(@"showMoreBtn", @(self.index), nil);
}

-(void)switchVC:(NSInteger)index {
    [self.showingChildVc.view removeFromSuperview];
    UIViewController *newVc = self.childViewControllers[index];
    [self.view addSubview:newVc.view];
    self.showingChildVc = newVc;
//    newVc.view.frame = CGRectMake(0, ML_NavViewHeight + 20, ML_ScreenWidth, ML_ScreenHeight - ML_NavViewHeight - ML_TabbarHeight - 20);
    newVc.view.backgroundColor = [UIColor whiteColor];
    [newVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset;
    }];
}



@end
