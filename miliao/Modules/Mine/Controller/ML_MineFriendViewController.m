//
//  ML_MineFriendViewController.m
//  miliao
//
//  Created by apple on 2022/9/14.
//

#import "ML_MineFriendViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "ML_FriendToViewController.h"
#import "ML_FriendFromViewController.h"
#import <Colours/Colours.h>
#import <Masonry/Masonry.h>
#import "ML_NTableViewCell.h"

@interface ML_MineFriendViewController ()<JXCategoryViewDelegate>
@property (nonatomic,strong)UILabel *dianView;
@property (nonatomic,strong)JXCategoryDotView *categoryView;
@property (nonatomic,strong)NSArray *titlearray;

@property (nonatomic, strong) NSArray *titleArr;// 标题数据
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//listView
@property (nonatomic,assign)NSInteger index;
@property (nonatomic, weak) UIViewController *showingChildVc;
@property (nonatomic,strong)UIImageView *img;


@end

@implementation ML_MineFriendViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    self.img = [[UIImageView alloc]init];
    self.img.image = [UIImage imageNamed:@"bg_top"];
    self.img.userInteractionEnabled = YES;
    [self.view addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(141);
    }];
    

    self.ML_navView.backgroundColor = UIColor.clearColor;

    
    self.categoryView = [[JXCategoryDotView alloc]init];
    self.categoryView.titles = @[Localized(@"谁看过我", nil)];
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
    lineView.verticalMargin = 40;
    self.categoryView.delegate = self;
    [self.img addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.img.mas_right).mas_offset(0);
        make.height.mas_equalTo(30*mHeightScale);
        make.top.mas_equalTo(self.img.mas_top).mas_offset(55*mHeightScale);
    }];
    
    
    [self setupChildVces];
    self.index = 0;
    [self switchVC:self.index];

}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setupChildVces{


    ML_FriendFromViewController *cityvc = [[ML_FriendFromViewController alloc]init];
    [self addChildViewController:cityvc];
 }

#pragma mark --- JXCategoryViewDelegate ------
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [self switchVC:index];
    self.index = index;
    if (index == 1) {
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
