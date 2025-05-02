//
//  MLCommunityViewController.m
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import "MLCommunityViewController.h"
#import "MLRecommendViewController.h"
#import "MLCityViewController.h"
#import "MLOnlineViewController.h"
#import "MLNewpersonViewController.h"
#import "MLFocusViewController.h"
#import "MLSearchViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_NearbyRecommendVC.h"
#import "TZLocationManager.h"
#import "MLFabuDynamicViewController.h"
#import "MLMineDynameicViewController.h"
@interface MLCommunityViewController ()<JXCategoryViewDelegate, CLLocationManagerDelegate>
@property (nonatomic,strong)JXCategoryTitleView *categoryView;
@property (nonatomic,strong)NSArray *titlearray;

@property (nonatomic, strong) NSArray *titleArr;// 标题数据
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//listView

@property (nonatomic, weak) UIViewController *showingChildVc;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIImageView *bgimg;

@property (nonatomic ,strong) CLLocationManager *LocationManager;


@end

@implementation MLCommunityViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    self.ML_navView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
//    self.navigationItem.title = @"";
    self.bgimg = [[UIImageView alloc]init];
    self.bgimg.userInteractionEnabled = YES;
    self.bgimg.image = [UIImage imageNamed:@"bg_top"];
    [self.view addSubview:self.bgimg];
    [self.bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
//        make.height.mas_equalTo(112);
        make.height.mas_equalTo(ML_NavViewHeight + 110);
    }];

    
    self.ML_navView.hidden = YES;
    self.categoryView = [[JXCategoryDotView alloc]init];
    self.categoryView.titles = @[Localized(@"推荐", nil), Localized(@"同城", nil)];
    self.categoryView.titleColor = [UIColor colorFromHexString:@"#666666"];
//    self.categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.categoryView.titleFont = [UIFont systemFontOfSize:14];

    self.categoryView.titleLabelZoomEnabled = YES;
    
    self.categoryView.titleLabelStrokeWidthEnabled = YES;
    self.categoryView.titleLabelSelectedStrokeWidth = -4;
    self.categoryView.titleSelectedColor = [UIColor colorFromHexString:@"#000000"];
    self.categoryView.titleColorGradientEnabled = NO;
    self.categoryView.titleLabelZoomScale = 1.3;
    self.categoryView.titleLabelVerticalOffset = 0;
    
    JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
    lineView.indicatorImageView.image = kGetImage(@"home_icon_tags");
//    lineView.indicatorColor = kZhuColor;
//    //lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorWidth = 20*mWidthScale;
    lineView.indicatorHeight = 30*mHeightScale;
    self.categoryView.indicators = @[lineView];
    lineView.indicatorImageView.frame = CGRectMake(0, 0, 30*mWidthScale, 10*mHeightScale);
//    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
//    lineView.verticalMargin = 12;
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(68);
        make.top.mas_equalTo(52*mHeightScale);
    }];
    
    [self setupChildVces];
    self.index = 0;
    [self switchVC:self.index];
    
//    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) {
        UIButton *myDongBT = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.view addSubview:myDongBT];
        [myDongBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.categoryView.mas_centerY);
            make.right.mas_equalTo(-16*mWidthScale);
            make.width.mas_equalTo(55*mWidthScale);
            make.height.mas_equalTo(20*mHeightScale);
        }];
        myDongBT.backgroundColor = kGetColor(@"666666");
        [myDongBT setTitle:@"我的动态" forState:UIControlStateNormal];
        myDongBT.titleLabel.font = [UIFont systemFontOfSize:10];
        [myDongBT setTitleColor:kGetColor(@"ffffff") forState:UIControlStateNormal];
        myDongBT.layer.cornerRadius = 10*mHeightScale;
        myDongBT.layer.masksToBounds = YES;
        [myDongBT addTarget:self action:@selector(myDong) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *fabuBt = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.view addSubview:fabuBt];
        [fabuBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(46*mWidthScale);
            make.left.mas_equalTo(313*mWidthScale);
            make.top.mas_equalTo(664*mHeightScale);
        }];
        [fabuBt setBackgroundImage:kGetImage(@"fabuBG") forState:UIControlStateNormal];
        
        [fabuBt addTarget:self action:@selector(fabuDongTai) forControlEvents:UIControlEventTouchUpInside];
//    }
}

- (void)myDong{
    MLMineDynameicViewController *vc = [[MLMineDynameicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fabuDongTai{
    MLFabuDynamicViewController *vc = [[MLFabuDynamicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupChildVces{

    ML_NearbyRecommendVC *recommendvVC = [[ML_NearbyRecommendVC alloc] initDataType:ML_Recommend];
    [self addChildViewController:recommendvVC];

    ML_NearbyRecommendVC *nearbyVC = [[ML_NearbyRecommendVC alloc] initDataType:ML_Nearby];
    [self addChildViewController:nearbyVC];
 }

#pragma mark --- JXCategoryViewDelegate ------
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [self switchVC:index];
    self.index = index;
}




#pragma mark---------定位失败-----------

-(void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error{
    if([error code] ==kCLErrorDenied){

    } else if([error code] ==kCLErrorDenied){
        //访问被拒绝
        kplaceToast(@"位置访问被拒绝")
    } else if ([error code] == kCLErrorLocationUnknown) {

       kplaceToast(@"无法获取位置信息")
    } else {
        NSLog(@"定位error-----%@", error);
    }
    // Privacy - Location Always and When In Use Usage Description和Privacy - Location When In Use Usage Description

}


-(void)switchVC:(NSInteger)index {
    [self.showingChildVc.view removeFromSuperview];
    UIViewController *newVc = self.childViewControllers[index];
    [self.view addSubview:newVc.view];
    self.showingChildVc = newVc;
    [newVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarHeight);
    }];
}


@end
