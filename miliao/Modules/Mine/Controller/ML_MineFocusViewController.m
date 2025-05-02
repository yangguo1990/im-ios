//
//  ML_MineFocusViewController.m
//  miliao
//
//  Created by apple on 2022/9/14.
//

#import "ML_MineFocusViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <Colours/Colours.h>
#import "ML_MineFocusffViewController.h"
#import "ML_MineFocusSSViewController.h"
#import <Masonry/Masonry.h>
#import "JXCategoryTitleView.h"
#import "ML_NTableViewCell.h"

@interface ML_MineFocusViewController ()<JXCategoryViewDelegate>
@property (nonatomic,strong)UILabel *dianView;
@property (nonatomic,strong)JXCategoryDotView *categoryView;
@property (nonatomic,strong)NSArray *titlearray;

@property (nonatomic, strong) NSArray *titleArr;// 标题数据
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//listView
@property (nonatomic,assign)NSInteger index;
@property (nonatomic, weak) UIViewController *showingChildVc;
@property (nonatomic,strong)UIImageView *img;


@end

@implementation ML_MineFocusViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.ML_navView.backgroundColor = UIColor.clearColor;

    self.img = [[UIImageView alloc]init];
    self.img.image = [UIImage imageNamed:@"bg_top"];
    self.img.userInteractionEnabled = YES;
    [self.view addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(141);
    }];
    
    self.categoryView = [[JXCategoryDotView alloc]init];

    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) {
        self.categoryView.titles = @[Localized(@"喜欢", nil), Localized(@"粉丝", nil)];
    }else{
        self.categoryView.titles = @[Localized(@"关注", nil), Localized(@"粉丝", nil)];
    }
    
    self.categoryView.titleColor = [UIColor colorFromHexString:@"#666666"];
//    self.categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.categoryView.titleFont = [UIFont systemFontOfSize:16];
    //self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.backgroundColor = UIColor.clearColor;
    
    self.categoryView.titleLabelStrokeWidthEnabled = YES;
    self.categoryView.titleLabelSelectedStrokeWidth = -4;
    self.categoryView.titleSelectedColor = [UIColor colorFromHexString:@"#333333"];
    self.categoryView.titleColorGradientEnabled = NO;
    //self.categoryView.titleLabelZoomScale = 1.3;
    self.categoryView.titleLabelVerticalOffset = 0;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor blackColor];
    //lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorWidth = 17;
    lineView.indicatorHeight = 5;
    self.categoryView.indicators = @[lineView];
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
    lineView.verticalMargin = 12;
    self.categoryView.delegate = self;
    [self.img addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.img.mas_right).mas_offset(0);
        make.height.mas_equalTo(68);
        make.top.mas_equalTo(self.img.mas_top).mas_offset(55*mHeightScale);
    }];
    
    
    UILabel *dianView = [[UILabel alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 + 90, 20, 10, 10)];
    dianView.hidden = !self.focusLogNum;
    dianView.backgroundColor = [UIColor redColor];
    dianView.layer.cornerRadius = 5;
    dianView.clipsToBounds = YES;
    [self.categoryView addSubview:dianView];
    self.dianView = dianView;
    


    [self setupChildVces];
    self.index = 0;
    [self switchVC:self.index];

}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setupChildVces{
    ML_MineFocusffViewController *recommendvc = [[ML_MineFocusffViewController alloc] init];
    [self addChildViewController:recommendvc];

    ML_MineFocusSSViewController *cityvc = [[ML_MineFocusSSViewController alloc]init];
    [self addChildViewController:cityvc];
 }

#pragma mark --- JXCategoryViewDelegate ------
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [self switchVC:index];
    self.index = index;
    
    if (index==1) {

        [self.dianView removeFromSuperview];
    }
}

-(void)switchVC:(NSInteger)index {
    [self.showingChildVc.view removeFromSuperview];
    UIViewController *newVc = self.childViewControllers[index];
    [self.view addSubview:newVc.view];
    self.showingChildVc = newVc;
    [newVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
    }];
}





@end
