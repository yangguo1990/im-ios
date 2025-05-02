//
//  ML_BangdanVC.m
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import "ML_BangdanVC2.h"
#import "ML_MeiliYaoqingVC.h"
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
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SharetraceSDK/SharetraceSDK.h>
#import "NSString+ML_MineVersion.h"
#import "MLNewestVersionShowView.h"
#import "UIViewController+MLHud.h"
#import "MLHomeOneZhaohuView.h"
#import "MLHomeOnlineBottomView.h"
#import "ML_GetUserInfoApi.h"
#import "MLHomeOnlineViewController.h"

@interface ML_BangdanVC2 ()<JXCategoryViewDelegate/*,BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate*/>
@property (nonatomic,strong)NSArray *titlearray;
@property (nonatomic, strong) NSArray *titleArr;// 标题数据
@property (nonatomic,strong)JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//listView
@property (nonatomic, weak) UIViewController *showingChildVc;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIImageView *bgimg;

@property (nonatomic,strong)MLNewestVersionShowView *versionShowView;
@property (nonatomic,strong)UIView *NmaskView;
//@property (nonatomic,strong) BMKLocationManager *locationManager;
@property (nonatomic,strong)MLHomeOneZhaohuView *oneZhaohuView;
@end

@implementation ML_BangdanVC2

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    self.ML_navView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    self.ML_navView.hidden = YES;
    
    self.bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, ML_ScreenWidth - 44 - SSL_StatusBarHeight)];
    self.bgimg.userInteractionEnabled = YES;
//    [self.bgimg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAddTap)]];
    [self.view addSubview:self.bgimg];


    
    
    self.categoryView = [[JXCategoryDotView alloc]init];
    
//    self.categoryView.titles = @[Localized(@"魅力榜", nil), Localized(@"邀请榜", nil)];
    self.categoryView.titles = @[Localized(@"上周榜", nil), Localized(@"日榜", nil), Localized(@"周榜", nil)];
    
    self.categoryView.titleColor = [UIColor colorFromHexString:@"#000000"];
//    self.categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.categoryView.cellSpacing = 28;

    self.categoryView.titleLabelZoomEnabled = YES;
    
    self.categoryView.titleLabelStrokeWidthEnabled = YES;
    self.categoryView.titleLabelSelectedStrokeWidth = -4;
    self.categoryView.titleSelectedColor = [UIColor whiteColor];//[self.way isEqualToString:@"4"]?[UIColor colorFromHexString:@"#7143EE"]:[UIColor colorFromHexString:@"#CF4EE5"];
    self.categoryView.titleColorGradientEnabled = NO;
    self.categoryView.titleLabelZoomScale = 1.08;
    self.categoryView.titleLabelVerticalOffset = 0;
    self.categoryView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    self.categoryView.layer.cornerRadius = 16;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 32*mHeightScale;
    backgroundView.indicatorWidth = 80*mWidthScale;
    backgroundView.indicatorColor = kGetColor(@"ff63c2");
    backgroundView.indicatorCornerRadius = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[backgroundView];

    self.categoryView.delegate = self;
    [self.bgimg addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25*mWidthScale);
        make.right.mas_equalTo(-25*mWidthScale);
        make.height.mas_equalTo(38*mHeightScale);
        make.top.mas_equalTo(10*mHeightScale);
//        make.centerY.mas_equalTo(SSL_StatusBarHeight + 22);
    }];
    
    [self setupChildVces];
    self.index = 0;
    [self switchVC:self.index];
    
    [self.categoryView setDefaultSelectedIndex:1];

    
    
    
}




- (void)setupChildVces{
    

    ML_MeiliYaoqingVC *vc1 = [[ML_MeiliYaoqingVC alloc] init];
    [self addChildViewController:vc1];
    vc1.way = self.way;
    vc1.type = @"3";
    
    ML_MeiliYaoqingVC *vc2 = [[ML_MeiliYaoqingVC alloc]init];
    [self addChildViewController:vc2];
    vc2.way = self.way;
    vc2.type = @"0";
    
    ML_MeiliYaoqingVC *vc3 = [[ML_MeiliYaoqingVC alloc]init];
    [self addChildViewController:vc3];
    vc3.way = self.way;
    vc3.type = @"1";
    
    
 }

#pragma mark --- JXCategoryViewDelegate ------
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    
    
    [self switchVC:index];
    self.index = index;
}

-(void)switchVC:(NSInteger)index {
    [self.showingChildVc.view removeFromSuperview];
    UIViewController *newVc = self.childViewControllers[index];
    [self.view addSubview:newVc.view];
    self.showingChildVc = newVc;
    [newVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}


-(void)searchClick{
    
    MLSearchViewController *searchvc = [[MLSearchViewController alloc]init];
    [searchvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchvc animated:YES];
}

@end
