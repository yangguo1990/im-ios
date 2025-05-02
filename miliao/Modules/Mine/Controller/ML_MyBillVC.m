//
//  TestViewController.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ML_MyBillVC.h"
#import "JXCategoryTitleView.h"
#import "ML_MyBillListVC.h"

@interface ML_MyBillVC ()

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@end

@implementation ML_MyBillVC


- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldHandleScreenEdgeGesture = YES;
    }
    return self;
}

- (void)viewDidLoad {
    //
    if (self.titles == nil) {
        BOOL ismale = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender.boolValue;
        if (ismale) {
            self.titles = @[Localized(@"充值记录", nil), Localized(@"消费记录", nil), Localized(@"积分明细", nil), Localized(@"提现记录", nil)];
        }else{
            self.titles = @[Localized(@"积分明细", nil), Localized(@"提现记录", nil)];
        }
        
    }

    [super viewDidLoad];
    UIImageView *topBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 88*mHeightScale)];
    topBack.image = kGetImage(@"bg_top");
//    [self ML_setUpCustomNavklb_la];
    self.ML_titleLabel.text = Localized(@"我的账单", nil);
    self.view.backgroundColor = [UIColor whiteColor];

    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    [self.view addSubview:self.categoryView];

    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.initListPercent = 0.01; //滚动一点就触发加载
    
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];

    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.titleSelectedColor = kGetColor(@"ff6fb3");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.categoryView.frame = CGRectMake(0, ML_NavViewHeight, self.view.bounds.size.width, [self preferredCategoryViewHeight]);
    self.listContainerView.frame = CGRectMake(0, [self preferredCategoryViewHeight] + ML_NavViewHeight, self.view.bounds.size.width, self.view.bounds.size.height - [self preferredCategoryViewHeight] - ML_NavViewHeight);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (CGFloat)preferredCategoryViewHeight {
    return 50;
}

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    ML_MyBillListVC *vc = [[ML_MyBillListVC alloc] init];
    BOOL ismale = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender.boolValue;
    if (ismale) {
        vc.type = index;
    }else{
        vc.type = index+2;
    }
    
    return vc;
}

- (JXCategoryBaseView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [self preferredCategoryView];
    }
    return _categoryView;
}

- (void)rightItemClicked {
    JXCategoryIndicatorView *componentView = (JXCategoryIndicatorView *)self.categoryView;
    for (JXCategoryIndicatorComponentView *view in componentView.indicators) {
        if (view.componentPosition == JXCategoryComponentPosition_Top) {
            view.componentPosition = JXCategoryComponentPosition_Bottom;
        }else {
            view.componentPosition = JXCategoryComponentPosition_Top;
        }
    }
    [componentView reloadData];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    if (_shouldHandleScreenEdgeGesture) {
        self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    }
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.listContainerView didClickSelectedItemAtIndex:index];
}



#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex:index];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}


@end
