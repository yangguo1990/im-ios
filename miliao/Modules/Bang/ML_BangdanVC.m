//
//  ML_BangdanVC.m
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import "ML_BangdanVC.h"
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
#import "ML_BangdanVC2.h"

@interface ML_BangdanVC ()<JXCategoryViewDelegate/*,BMKGeneralDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate*/>
@property (nonatomic,strong)NSArray *titlearray;
@property (nonatomic, strong) NSArray *titleArr;// 标题数据
@property (nonatomic,strong)JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//listView
@property (nonatomic, weak) UIViewController *showingChildVc;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIImageView *bgimg;

@property (nonatomic,strong)UILabel *laNameV1;
@property (nonatomic,strong)UILabel *laJiangV1;
@property (nonatomic,strong)UIButton *LingBtn1;

@property (nonatomic,strong)UILabel *laNameV2;
@property (nonatomic,strong)UILabel *laJiangV2;
@property (nonatomic,strong)UIButton *LingBtn2;
@property (nonatomic,strong)UIButton *meiliBt;
@property (nonatomic,strong)UIButton *yaoqinBt;

@property (nonatomic,strong)UILabel *laNameV3;
@property (nonatomic,strong)UILabel *laJiangV3;
@property (nonatomic,strong)UIButton *LingBtn3;

@property (nonatomic,strong)UIImageView *cv1;
@property (nonatomic,strong)UIImageView *cv2;
@property (nonatomic,strong)UIImageView *cv3;
@property (nonatomic,strong)MLNewestVersionShowView *versionShowView;
@property (nonatomic,strong)UIView *NmaskView;
@property (nonatomic,strong)MLHomeOneZhaohuView *oneZhaohuView;
@end

@implementation ML_BangdanVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.ML_navView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


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
  
    self.bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 320*mHeightScale)];
    self.bgimg.userInteractionEnabled = YES;
//    [self.bgimg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAddTap)]];
    self.bgimg.image = [UIImage imageNamed:@"list_charm_background"];
    [self.view addSubview:self.bgimg];
    
    UIButton *backBt = [[UIButton alloc]initWithFrame:CGRectMake(16*mWidthScale, 54*mHeightScale, 24*mWidthScale, 24*mWidthScale)];
    [backBt setBackgroundImage:kGetImage(@"kaitongBG") forState:UIControlStateNormal];
    [backBt addTarget:self action:@selector(backlast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBt];
    UIImageView *pIV = [[UIImageView alloc]initWithFrame:CGRectMake(150*mWidthScale, 56*mHeightScale, 82*mWidthScale, 20*mHeightScale)];
    pIV.image = kGetImage(@"pIV");
    [self.view addSubview:pIV];
        UIButton *meiliBt = [[UIButton alloc]initWithFrame:CGRectZero];
        self.meiliBt = meiliBt;
        meiliBt.tag = 1000;
        [meiliBt addTarget:self action:@selector(bangdanChange:) forControlEvents:UIControlEventTouchUpInside];
        
        [meiliBt setBackgroundImage:kGetImage(@"meiliBTs") forState:UIControlStateSelected];
        [meiliBt setBackgroundImage:kGetImage(@"meiliBT") forState:UIControlStateNormal];
        meiliBt.selected = YES;
        [self.bgimg addSubview:meiliBt];
        [meiliBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16*mWidthScale);
            make.top.mas_equalTo(156*mHeightScale);
            make.width.mas_equalTo(160*mWidthScale);
            make.height.mas_equalTo(40*mHeightScale);
        }];
        
        
        UIButton *yaoqingBt = [[UIButton alloc]initWithFrame:CGRectZero];
        self.yaoqinBt = yaoqingBt;
    [yaoqingBt setBackgroundImage:kGetImage(@"yaoqingBTs") forState:UIControlStateSelected];
    [yaoqingBt setBackgroundImage:kGetImage(@"yaoqingBT") forState:UIControlStateNormal];
        yaoqingBt.tag = 1001;
        [yaoqingBt addTarget:self action:@selector(bangdanChange:) forControlEvents:UIControlEventTouchUpInside];
        yaoqingBt.selected = NO;
        [self.bgimg addSubview:yaoqingBt];
        [yaoqingBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(199*mWidthScale);
            make.top.mas_equalTo(156*mHeightScale);
            make.width.mas_equalTo(160*mWidthScale);
            make.height.mas_equalTo(40*mHeightScale);
        }];
    UIButton *Rbtn = [[UIButton alloc] initWithFrame:CGRectZero];
    Rbtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    [Rbtn setTitle:@"榜单说明" forState:UIControlStateNormal];
    Rbtn.titleLabel.numberOfLines = 0;
    [Rbtn addTarget:self action:@selector(rBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [Rbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Rbtn.layer.cornerRadius = 10*mHeightScale;
    Rbtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    [self.view addSubview:Rbtn];
    [Rbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(304*mWidthScale);
        make.top.mas_equalTo(56*mHeightScale);
        make.width.mas_equalTo(55*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    [self setupChildVces];
    self.index = 0;
    [self switchVC:self.index];
    
}


- (void)backlast{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rBtnClick
{
    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"top/rewardList"];
     kSelf;
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

         
         UIView *view3 = [[UIView alloc] initWithFrame:weakself.view.window.bounds];
         view3.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
         [weakself.view.window addSubview:view3];
         view3.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2);
         
         
         UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 311, 458*mHeightScale)];
         view2.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
         view2.layer.cornerRadius = 20*mHeightScale;
//         view2.layer.masksToBounds = YES;
         [view3 addSubview:view2];
         
         UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -60, 311, 134*mHeightScale)];
         imgV.userInteractionEnabled = YES;
         [view2 addSubview:imgV];
         imgV.image = kGetImage(@"user_behaviorbd_background");
         
         UIButton *view = [[UIButton alloc] init];
         view.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
         [view setImage:kGetImage(@"icon_note_12") forState:UIControlStateNormal];
         [view setTitle:[NSString stringWithFormat:@" %@", response.data[@"content"]] forState:UIControlStateNormal];
         [view setTitleColor:[UIColor colorWithHexString:@"#FF63c2"] forState:UIControlStateNormal];
         view.frame = CGRectMake(20,90,view2.width - 40, 20);
         view.backgroundColor = kGetColor(@"fee4f1");
         view.layer.cornerRadius = 10;
         [view2 addSubview:view];
      
         UILabel *laJiangV = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(view.frame) + 20, view.width, 20)];
         laJiangV.textAlignment = NSTextAlignmentLeft;
         laJiangV.text = response.data[@"invites"][@"title"];
         laJiangV.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
         laJiangV.textColor = [UIColor colorWithHexString:@"#ff63c2"];
         [view2 addSubview:laJiangV];
         NSArray *arr1 = response.data[@"invites"][@"list"];
         
        CGFloat W = view.width / 2;
            
         CGFloat maxY = 0;
         for(int i = 0; i < arr1.count; i++) {
             NSDictionary *aDic = arr1[i];
             int row = i / 2;
             UILabel *tv = [[UILabel alloc]initWithFrame:CGRectMake(i % 2 == 0 ? 20 : (20 + W), CGRectGetMaxY(laJiangV.frame) + 3 +  row * (3+20), W, 20)];
             tv.textAlignment = NSTextAlignmentLeft;
             tv.text = [NSString stringWithFormat:@"%@  %@", aDic[@"ranking"], aDic[@"num"]];
             tv.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
             tv.textColor = [UIColor colorWithHexString:@"#000000"];
             [view2 addSubview:tv];
             if (i == arr1.count - 1) {
                 maxY = CGRectGetMaxY(tv.frame);
             }
         }
         
         UILabel *laJiangV2 = [[UILabel alloc]initWithFrame:CGRectMake(20, maxY + 12, laJiangV.width, 20)];
         laJiangV2.textAlignment = NSTextAlignmentLeft;
         NSString *title2 = response.data[@"charms"][@"title"];
         laJiangV2.text = title2;
         laJiangV2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
         laJiangV2.textColor = [UIColor colorWithHexString:@"#ff63c2"];
         [view2 addSubview:laJiangV2];
         NSArray *arr2 = response.data[@"charms"][@"list"];
         for(int i = 0; i < arr2.count; i++) {
             NSDictionary *aDic = arr2[i];
             int row = i / 2;
             UILabel *tv = [[UILabel alloc]initWithFrame:CGRectMake(i % 2 == 0 ? 20 : (20 + W), CGRectGetMaxY(laJiangV2.frame) + 3 +  row * (3+20), W, 20)];
             tv.textAlignment = NSTextAlignmentLeft;
             tv.text = [NSString stringWithFormat:@"%@  %@", aDic[@"ranking"], aDic[@"num"]];
             tv.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
             tv.textColor = [UIColor colorWithHexString:@"#000000"];
             [view2 addSubview:tv];
             if (i == arr2.count - 1) {
                 maxY = CGRectGetMaxY(tv.frame);
             }
         }
         view2.frame = CGRectMake(0, 0, 311, maxY+80);
         view2.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2);
         
         UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 271, 44)];
         [btn3 setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
         btn3.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
         [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//         [btn3 setBackgroundImage:kGetImage(@"button_know_128") forState:UIControlStateNormal];
//         btn3.backgroundColor = kGetColor(@"#ffe962");
         [btn3 setTitle:Localized(@"知道了", nil) forState:UIControlStateNormal];
         [btn3 addTarget:weakself action:@selector(chaView3:) forControlEvents:UIControlEventTouchUpInside];
         btn3.center = CGPointMake(view2.width / 2, view2.height - 34);
         [view2 addSubview:btn3];

        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)chaView3:(UIButton *)btn
{

    [btn.superview.superview removeFromSuperview];

}

- (void)bangdanChange:(UIButton *)sender{
    switch (sender.tag) {
        case 1000:
        {
            if (self.meiliBt.selected) {
                
            }else{
                self.meiliBt.selected = YES;
                self.yaoqinBt.selected = NO;
                self.index = 0;
                [self switchVC:self.index];
            }
        }
            break;
        case 1001:
        {
            if (self.yaoqinBt.selected) {
                
            }else{
                self.meiliBt.selected = NO;
                self.yaoqinBt.selected = YES;
                self.index = 1;
                [self switchVC:self.index];
            }
        }
            break;
        default:
            break;
    }
}


- (void)LingBtnClick:(UIButton *)btn
{
   
}

- (void)setupChildVces{
    

    ML_BangdanVC2 *vc1 = [[ML_BangdanVC2 alloc] init];
    vc1.way = @"1";
    [self addChildViewController:vc1];
    
    ML_BangdanVC2 *vc2 = [[ML_BangdanVC2 alloc]init];
    vc2.way = @"4";
    [self addChildViewController:vc2];
    
    
 }

#pragma mark --- JXCategoryViewDelegate ------
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    
    if (index == 0) {
        
        self.bgimg.image = [UIImage imageNamed:@"list_charm_background"];
        
    } else {
        
        self.bgimg.image = [UIImage imageNamed:@"list_invitation_background"];
    }
    
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
        make.top.mas_equalTo(self.meiliBt.mas_bottom);
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
