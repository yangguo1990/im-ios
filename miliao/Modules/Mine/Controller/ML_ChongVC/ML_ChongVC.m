//
//  TTYChongVC.m
//  Tutuyue
//
//  Created by t on 2019/10/11.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "ML_ChongVC.h"
#import "ML_PayManager.h"
#import "WXApi.h"
#import "WXPayTools.h"
#import "ML_DuibiCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIButton+ML.h"
#import "WKWebViewController.h"
#import "ML_MyBillVC.h"
#import "JXCategoryIndicatorLineView.h"
#import "FYBandingController.h"
#import "MLTuijiangiftViewController.h"
#import "ML_RequestManager.h"
#import "ZMPayItemView.h"
#import "ZMAliInfos.h"
#import "ZMWithdrawalItemView.h"
#import "ZMBankCardBindViewController.h"
#import "ML_ChongCollectionViewCell.h"
#import "ML_DuiCollectionViewCell.h"
#import "ML_chongPayView.h"
@interface ML_ChongVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSDictionary *baoDic;
@property (nonatomic,strong) NSArray *listData;
@property (nonatomic,strong) NSMutableArray *btnViewArr;
@property (nonatomic,strong) UIButton *footerBtn;
@property (nonatomic,strong) UIButton *selectionBtn;
@property (nonatomic,strong) UIButton *selectionBtn2;
@property (nonatomic,strong) UILabel *jinbV;
@property (nonatomic,strong) UILabel *jifenV;
//@property (nonatomic,strong) UIScrollView *scr;
@property (nonatomic,strong) UIView *tmV1;
@property (nonatomic,strong) UIView *tmV2;
@property (nonatomic,strong) UIButton *ML_ApBtn;
@property (nonatomic,strong) UIButton *baoBtn;
@property (nonatomic,strong) UIButton *btn1_2;
//@property (nonatomic,strong)UIImageView *bgView;
@property (nonatomic,strong)UIView *bgV2;
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *pid2;
@property (nonatomic,strong) NSArray *listArr;
@property (nonatomic,assign) BOOL appleType;
@property (nonatomic,strong) NSArray *appleArr;
@property (nonatomic,strong) UIButton *btn2ji;
@property (nonatomic,strong) NSString * withdrawalCommission;
@property (nonatomic,strong)UICollectionView *middleCollectionView;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong) ZMPayItemView *aliPayItem;
@property (nonatomic,strong) ZMPayItemView *wxPayItem;
@property (nonatomic,strong) ZMPayItemView *cardPayItem;
@property (nonatomic,strong) NSMutableArray *payItems;
@property (nonatomic, assign) BOOL wxPay;              //
@property (nonatomic, assign) BOOL aliPay;              //
@property (nonatomic, assign) BOOL cardPay;              //
@property (nonatomic, assign) NSInteger payType;              //
@property (nonatomic, strong)NSArray *paylist;

@property (nonatomic, strong) ZMAliInfos *aliInfo;

@property (nonatomic, strong) ZMWithdrawalItemView *withdrawalAliItemView;
@property (nonatomic, strong) ZMWithdrawalItemView *withdrawalCardItemView;


@property (nonatomic,assign) CGFloat scrH;
@property (nonatomic,assign) CGFloat leftScrH;
@property (nonatomic,assign) CGFloat rightScrH;
@property (nonatomic, assign) NSInteger sectionType;              // 0 充值 1 提现
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)NSInteger payway;
@end

@implementation ML_ChongVC

- (NSMutableArray *)payItems{
    if(!_payItems){
        _payItems = [NSMutableArray array];
    }
    return _payItems;
}

- (void)ML_rightItemClicked
{
    ML_MyBillVC *testVC = [[ML_MyBillVC alloc] init];
    JXCategoryTitleView *titleCategoryView = (JXCategoryTitleView *)testVC.categoryView;
    titleCategoryView.titleSelectedColor = kZhuColor;
    testVC.isNeedIndicatorPositionChangeItem = YES;
    titleCategoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor blackColor];
    lineView.indicatorWidth = 17;
    lineView.indicatorHeight = 5;
    titleCategoryView.indicators = @[lineView];
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < ML_ScreenWidth / 2) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
    } else {
        [scrollView setContentOffset:CGPointMake(ML_ScreenWidth, scrollView.contentOffset.y)];
    }
    
    if (scrollView.contentOffset.x / ML_ScreenWidth == 0) {
        
        self.tmV1.hidden = NO;
        self.tmV2.hidden = YES;
        CGRect frame = scrollView.frame;
        frame.size.height = self.scrH;
        scrollView.frame = frame;
        [self.footerBtn setTitle:Localized(@"购买金币", nil) forState:UIControlStateNormal];
    } else if (scrollView.contentOffset.x / ML_ScreenWidth == 1){
        self.tmV1.hidden = YES;
        self.tmV2.hidden = NO;
        CGRect frame = scrollView.frame;
        //        frame.size.height = self.scrH + ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]?0:(48 * 2));
        frame.size.height = self.scrH;
        scrollView.frame = frame;
        
        if (!self.footerBtn.hidden) {
            [self.footerBtn setTitle:Localized(@"提现", nil) forState:UIControlStateNormal];
        }
    }
    
}

- (void)ML_ScrHeadBtnClick:(UIButton *)btn
{
    self.btn1_2.selected = NO;
    self.btn1_2.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.selectedIndex = 0;
    [self.middleCollectionView reloadData];
    btn.selected = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.btn1_2 = btn;
//    CGSize size = self.scr.contentSize;
    
    
    if (btn.tag == 0) {//充值金额
        self.sectionType = 0;
        self.footerBtn.hidden = NO;
        self.tmV1.hidden = NO;
        self.tmV2.hidden = YES;
        self.typeLabel.text = @"选择支付金额";
        [self.footerBtn setTitle:@"购买金币" forState:UIControlStateNormal];
//        self.scr.contentSize = CGSizeMake(size.width, self.leftScrH);
    } else {//积分提现
        //        self.footerBtn.hidden = ![[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue];
        self.sectionType = 1;
        self.footerBtn.hidden = NO;
        self.tmV1.hidden = YES;
        self.tmV2.hidden = NO;
        self.typeLabel.text = @"选择兑换金额";
        [self.footerBtn setTitle:@"兑换金币" forState:UIControlStateNormal];
//        self.scr.contentSize = CGSizeMake(size.width, self.rightScrH);
    }
   
    
//    [self.scr setContentOffset:CGPointMake(([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]?1:btn.tag) * ML_ScreenWidth, 0) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updataJinJi];
    [self getRechargePackages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataJinJi)
                                                 name:@"updataJinJiNoti"
                                               object:nil];
    self.selectedIndex = 0;
    UIImageView *bgimg = [[UIImageView alloc]init];
    bgimg.userInteractionEnabled = YES;
    //    self.bgimg.image = [UIImage imageNamed:@"bg"];
    bgimg.image = [UIImage imageNamed:@"029abg"];
    [self.view addSubview:bgimg];
    CGSize csi = bgimg.image.size;
    CGFloat bH = ML_ScreenWidth * csi.height / csi.width;
    [bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        //        make.height.mas_equalTo(112);
        make.height.mas_equalTo(bH);
    }];

    self.ML_navView.backgroundColor = [UIColor clearColor];
    self.ML_titleLabel.text = Localized(@"我的钱包", nil);
    self.ML_titleLabel.textColor = kGetColor(@"000000");
    [self.ML_backBtn setImage:kGetImage(@"icon_back_24_FFF_nor_1") forState:UIControlStateNormal];
    self.ML_rightBtn.frame = CGRectMake(ML_ScreenWidth - 100, ML_NavViewHeight - 44, 80, 44);
    [self ML_addNavRightBtnWithTitle:Localized(@"我的账单", nil) image:nil];
    self.ML_rightBtn.titleLabel.font = kGetFont(16);
    [self.ML_rightBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 98*mHeightScale, 200, 50)];
    label.text = [[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]?Localized(@"当前可提现积分", nil): Localized(@"金币余额", nil);
    //    label.text = Localized(@"当前可提现积分", nil);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithHexString:@"#000000"];
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]; // 字重;
    [self.view addSubview:label];
    
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = kGetColor(@"#000000");
    label2.frame = CGRectMake(label.x, CGRectGetMaxY(label.frame)-5, 250, 45);
    label2.font = [UIFont boldSystemFontOfSize:38];
    label2.text = [ML_AppUserInfoManager sharedManager].currentLoginUserData.coin;
    [self.view addSubview:label2];
    self.jinbV = label2;
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.textColor = kGetColor(@"#666666");
    label3.frame = CGRectMake(label.x, CGRectGetMaxY(label2.frame)+ 20, 250, 30);
    label3.font = [UIFont systemFontOfSize:16];
    //    label3.text = @"我的积分：0";
    [self.view addSubview:label3];
    self.jifenV = label3;
    
    UIImage *img = kGetImage(@"Slice 48");
    UIButton *yaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - img.size.width, label2.y - 10, img.size.width, img.size.height)];
    if (kisCH) {
        [yaoBtn setBackgroundImage:img forState:UIControlStateNormal];
    } else {
        yaoBtn.frame = CGRectMake(ML_ScreenWidth - img.size.width + 20, label2.y - 10, img.size.width, img.size.height);
        [yaoBtn setTitle:Localized(@"邀请", nil) forState:UIControlStateNormal];
        [yaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        yaoBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        yaoBtn.layer.cornerRadius = img.size.height / 2;
    }
    
    [yaoBtn addTarget:self action:@selector(yaoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yaoBtn];
    
    UIView *bgV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 261*mHeightScale, ML_ScreenWidth, 50)];
    bgV2.backgroundColor = [UIColor whiteColor];
    bgV2.layer.cornerRadius = 16;
    bgV2.layer.masksToBounds = YES;
    [self.view addSubview:bgV2];
    self.bgV2 = bgV2;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 130, 261*mHeightScale, 130, bgV2.height)];
    [btn1 addTarget:self action:@selector(ML_ScrHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:Localized(@"充值金额", nil) forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"#999999"]  forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"#000000"]  forState:UIControlStateSelected];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    btn1.tag = 0;
    [self.view addSubview:btn1];
    self.btn1_2 = btn1;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(btn1.width / 2 - 10, btn1.height - 10, 20, 5)];
    line1.layer.cornerRadius = 2.5;
    line1.tag = 10;
    line1.backgroundColor = kGetColor(@"ff6fb3");
    [btn1 addSubview:line1];
    self.tmV1 = line1;
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2, 261*mHeightScale, 130, bgV2.height)];
    [btn2 addTarget:self action:@selector(ML_ScrHeadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [btn2 setTitle:[[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]?Localized(@"积分提现", nil):Localized(@"兑换金币", nil) forState:UIControlStateNormal];
    [btn2 setTitle:Localized(@"兑换金币", nil) forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"#999999"]  forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"#000000"]  forState:UIControlStateSelected];
    btn2.titleLabel.font =  [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    btn2.tag = 1;
    [self.view addSubview:btn2];
    btn2.hidden = ![ML_AppUtil isCensor];
    self.btn2ji = btn2;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(line1.x, btn1.height - 10, 20, 5)];
    line2.layer.cornerRadius = 2.5;
    line2.tag = 10;
    line2.hidden = YES;
    line2.backgroundColor = [UIColor colorWithHexString:@"#ff6fb3"];
    [btn2 addSubview:line2];
    self.tmV2 = line2;
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    typeLabel.text = @"选择支付金额";
    typeLabel.textColor = kGetColor(@"000000");
    typeLabel.font = [UIFont boldSystemFontOfSize:16];
    self.typeLabel = typeLabel;
    [self.view addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(btn2.mas_bottom).offset(5*mHeightScale);
        make.height.mas_equalTo(22*mHeightScale);
    }];
    
    
    UIButton *footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(16*mWidthScale, 730*mHeightScale, 343*mWidthScale, 48*mHeightScale)];
    footerBtn.titleLabel.font = kGetFont(16);
    [footerBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [footerBtn setTitle:Localized(@"购买金币", nil) forState:UIControlStateNormal];
    footerBtn.tag = 2;
    [footerBtn setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(footerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    footerBtn.layer.cornerRadius = footerBtn.height / 2;
    [self.view addSubview:footerBtn];
    [footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(UIScreenWidth - 32);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    self.footerBtn = footerBtn;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10*mHeightScale;
    layout.minimumInteritemSpacing = 10*mWidthScale;
    layout.sectionInset = UIEdgeInsetsMake(0, 10*mWidthScale, 0, 10*mWidthScale);
    self.middleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.middleCollectionView.delegate = self;
    self.middleCollectionView.dataSource = self;
    [self.view addSubview:self.middleCollectionView];
    [self.middleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.footerBtn.mas_top);
    }];
    [self.middleCollectionView registerClass:[ML_ChongCollectionViewCell class] forCellWithReuseIdentifier:@"chongCell"];
    [self.middleCollectionView registerClass:[ML_DuiCollectionViewCell class] forCellWithReuseIdentifier:@"duiCell"];
    
    
    
//    self.scr.frame = CGRectMake(0, CGRectGetMaxY(bgView.frame) - 20, ML_ScreenWidth, footerBtn.y - CGRectGetMaxY(bgView.frame));
//    self.scrH = scr.height;
    self.btnViewArr = [NSMutableArray array];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.sectionType == 0){
        return self.listData.count;
    }else{
        return self.listArr.count;
    }
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sectionType == 0) {
        ML_ChongCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"chongCell" forIndexPath:indexPath];
        cell.dataDic = self.listData[indexPath.row];
        cell.isSelected = (self.selectedIndex == indexPath.row);
        return cell;
    }else{
        ML_DuiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"duiCell" forIndexPath:indexPath];
        cell.dataDic = self.listArr[indexPath.row];
        cell.isSelected = (self.selectedIndex == indexPath.row);
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sectionType == 0) {
        return CGSizeMake(106*mWidthScale, 106*mWidthScale);
    }else{
        return CGSizeMake(166*mWidthScale, 66*mWidthScale);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    [self.middleCollectionView reloadData];
    
    if (!self.sectionType) {
        NSDictionary *data = self.listData[indexPath.row];
        self.ID = [NSString stringWithFormat:@"%@", data[@"id"]];
    }else{
        NSDictionary *data = self.listArr[indexPath.row];
        self.pid2 = [NSString stringWithFormat:@"%@", data[@"id"]];
    }
   
}


- (void)getRechargePackages{
    [SVProgressHUD show];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"type" : @"1"} urlStr:@"wallet/getRechargePackages"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        UserInfoData *user = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        user.wxPay = [NSString stringWithFormat:@"%@", response.data[@"wxPay"]];
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = user;
        weakself.listData = response.data[@"recharges"];
        //        NSLog(@"asdfasd===adsf==sdf==%d", [[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]);
        weakself.ID = [NSString stringWithFormat:@"%@",weakself.listData[0][@"id"]];
        weakself.wxPay = [response.data[@"wxPay"] boolValue];
        weakself.aliPay = [response.data[@"aliPay"] boolValue];
        weakself.cardPay = [response.data[@"cardPay"] boolValue];
        weakself.paylist = response.data[@"payList"];
        
        
        weakself.appleType = [response.data[@"iosPurchasing"] boolValue];
        weakself.appleArr = response.data[@"apple"];
        NSString *pathStr = @"wallet/getExchangePackages";
        if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
        pathStr = @"wallet/getWithdrawPackages";
        }
        [SVProgressHUD show];
        ML_CommonApi *api3 = [[ML_CommonApi alloc] initWithPDic:nil urlStr:pathStr];
        [api3 networkWithCompletionSuccess:^(MLNetworkResponse *response2) {
            
            weakself.withdrawalCommission = response2.data[@"withdrawalCommission"];
            
            [SVProgressHUD dismiss];
            //            if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
            
            weakself.listArr = response2.data[@"exchanges"];
            weakself.aliInfo = [ZMAliInfos mj_objectWithKeyValues:response2.data[@"aliInfos"]]; //
            weakself.pid2 = [NSString stringWithFormat:@"%@",weakself.listArr[0][@"id"]];
            //            } else {
            //
            //                weakself.listArr = response2.data[@"exchanges"];
            //            }
            
            [weakself.middleCollectionView reloadData];
//            [weakself settingUIWithTag:0];
            //            [weakself.ML_TableView reloadData];
            [weakself ML_ScrHeadBtnClick:weakself.sectionType ? weakself.btn2ji : weakself.btn1_2];
            
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)yaoClick
{
    MLTuijiangiftViewController *vc = [[MLTuijiangiftViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updataJinJi
{
    
    [SVProgressHUD show];
    ML_CommonApi *api2 = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"wallet/getMyWallet"];
    kSelf;
    [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dic = response.data;
        weakself.baoDic = dic;
        
        
        UserInfoData *jinJi = [UserInfoData mj_objectWithKeyValues:response.data]; // 为了判断返回奇怪现象，用这个来接收币和积分
        
        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        currentData.coin = jinJi.coin;
        currentData.credit = jinJi.credit;
        
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
        
        if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) {
            weakself.jinbV.text = currentData.credit;
            weakself.jifenV.text = [NSString stringWithFormat:@"%@：%@",Localized(@"金币余额", nil), currentData.coin];
        } else {
            weakself.jinbV.text = currentData.coin;
            weakself.jifenV.text = [NSString stringWithFormat:@"%@：%@", Localized(@"我的积分", nil), currentData.credit];
        }
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)tibaoClick:(UIButton *)btn
{
    //    if (btn.tag == 10) { // 已经绑定
    //
    //    } else if (btn.tag == 1) { // 未绑定
    FYBandingController *vc = [FYBandingController new];
    vc.baoDic = self.baoDic;
    [self.navigationController pushViewController:vc animated:YES];
    //    }
}

- (void)ML_apClick:(UIButton *)btn
{
    self.ML_ApBtn = btn;
    for (ZMPayItemView *item in self.payItems) {
        [item setSelected:NO];
    }
    ZMPayItemView *zmpay = btn.superview;
    [zmpay setSelected:YES];
    
}

- (void)tiBtnClick:(UIButton *)btn
{
    self.selectionBtn2.selected = NO;
    self.selectionBtn2.backgroundColor = kGetColor(@"ffffff");
    [self.selectionBtn2 setTitleColor:kGetColor(@"333333") forState:UIControlStateNormal];
    NSArray *arr2 = self.selectionBtn2.subviews;
    for (UILabel *view in arr2) {
            view.textColor = kGetColor(@"#666666");
    }
    
    self.selectionBtn2 = btn;
    
    btn.selected = YES;
    btn.backgroundColor = kGetColor(@"954dff");
    [btn setTitleColor:kGetColor(@"ffffff") forState:UIControlStateNormal];
    NSArray *arr = btn.subviews;
    for (UILabel *view in arr) {
        view.textColor  = kGetColor(@"ffffff");
    }
    
    
    NSDictionary *dic = self.listArr[btn.tag-100];
    self.pid2 = [NSString stringWithFormat:@"%@", dic[@"id"]];
    
}

- (void)btnClick:(UIButton *)btn
{
    
    self.selectionBtn.selected = NO;
    self.selectionBtn.backgroundColor = UIColor.whiteColor;
    NSArray *arr2 = self.selectionBtn.subviews;
    for (UIView *view in arr2) {
        if (view.tag == self.selectionBtn.tag+1) {
            [(UIButton *)view setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        }
        
        if (view.tag == self.selectionBtn.tag+2) {
            ((UILabel *)view).textColor = kGetColor(@"666666");
        }
        
        if (view.tag == self.selectionBtn.tag+3) {
            ((UILabel *)view).textColor = kGetColor(@"ffffff");
            ((UILabel *)view).backgroundColor = kGetColor(@"cccccc");
        }
    }
    
    self.selectionBtn = btn;
    
    btn.selected = YES;
    btn.backgroundColor = kGetColor(@"954dff");
    NSArray *arr = btn.subviews;
    for (UIView *view in arr) {
        if (view.tag == self.selectionBtn.tag+1) {
            [(UIButton *)view setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }
        
        if (view.tag == self.selectionBtn.tag+2) {
            ((UILabel *)view).textColor = kGetColor(@"ffffff");
        }
        
        if (view.tag == self.selectionBtn.tag+3) {
            ((UILabel *)view).textColor = kGetColor(@"ae68ff");
            ((UILabel *)view).backgroundColor = kGetColor(@"ffffff");
        }
    }
    
    
    
    NSDictionary *dic = self.listData[btn.tag];
    self.ID = [NSString stringWithFormat:@"%@", dic[@"id"]];
    if (self.appleType) {
        self.pid = [NSString stringWithFormat:@"%@", dic[@"pid"]];
    }
    
}


- (void)footerBtnClick
{

    if (!self.sectionType) {
        //充值
        if (!self.listData.count) return;
        [ML_chongPayView showWithPaylist:self.paylist payCallBack:^(NSInteger payWay) {
            self.payway = payWay;
            [self appleWxAliPay];
        } type:0 zmaliinfo:self.aliInfo];

    }else{
        //金币兑换
        kSelf;
        ML_CommonApi *api3 = [[ML_CommonApi alloc] initWithPDic:@{@"packageId" : self.pid2} urlStr:@"wallet/exchangePackage"];
        [api3 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
      
            kplaceToast(@"兑换中，正在审核！");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
           
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
           
        }];
    }
}
- (void)appleWxAliPay {
    
    if (kisCH) {
        
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"payWay" : self.appleType?@(2):@(self.payway), @"packageId" : self.ID?:@""} urlStr:@"wallet/affirmRecharge"];
        kSelf;
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            
            NSDictionary *dic = response.data[@"order"];
            // wx47ed39b0ce916f97
            
            if (weakself.appleType) {
                
                NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
                [muDic setObject:self.pid?:@"" forKey:@"pid"];
                [muDic setObject:dic[@"orderNumber"]?:@"" forKey:@"orderNumber"];
                [[ML_PayManager sharedPayManager] goChongWithProduct:muDic];
                
                return;
            } else if ([response.data[@"payPattern"] intValue] == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response.data[@"order"]] options:nil completionHandler:^(BOOL success) {
                    
                }];
                //                   WKWebViewController *rechargeVC = [WKWebViewController new];
                //                   rechargeVC.Rob_euCvar_Url = response.data[@"order"];
                //                   [weakself.navigationController pushViewController:rechargeVC animated:YES];
                
                return;
            } else if (self.payway == 0) {
                
                [WXApi registerApp:dic[@"appid"] universalLink:@"https://your_domain/app/"];
                
                PayReq *request = [[PayReq alloc] init];
                request.openID = [dic objectForKey:@"appid"];
                request.partnerId = [dic objectForKey:@"partnerid"];
                request.prepayId= [dic objectForKey:@"prepayid"];
                request.package = [dic objectForKey:@"package"];
                request.nonceStr= [dic objectForKey:@"noncestr"];
                
                request.timeStamp= (UInt32)[[dic objectForKey:@"timestamp"] integerValue];
                
                request.sign = [dic objectForKey:@"sign"];
                
                NSDictionary *data = @{
                    @"appId"    : [dic objectForKey:@"appid"],
                    @"nonceStr" : [dic objectForKey:@"noncestr"],
                    @"partnerId": [dic objectForKey:@"partnerid"],
                    @"prepayId" : [dic objectForKey:@"prepayid"],
                    @"sign"     : [dic objectForKey:@"sign"],
                    @"timeStamp": [dic objectForKey:@"timestamp"],
                };
                
                [WXTools doWXPay:data paySuccess:^{
                    NSLog(@"success！");
                    [ML_AppUserInfoManager shuaWithCoin:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
                } payFailed:^{
                    NSLog(@"支付失败");
                }];
                
            } else if (self.payway == 1){
                NSLog(@"asdfasdf====adsf=asdf===");
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:response.data[@"order"]?:@"" fromScheme:@"alisdk" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    [ML_AppUserInfoManager shuaWithCoin:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
                }];
            } else if (self.payway == 2){
                NSLog(@"card====");
                // NOTE: 调用支付结果开始支付
                
                WKWebViewController *rechargeVC = [WKWebViewController new];
                rechargeVC.Rob_euCvar_Url = response.data[@"order"];
                [weakself.navigationController pushViewController:rechargeVC animated:YES];
                
            }
            
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        NSString *payWay = [NSString stringWithFormat:@"%ld", self.payway];
        if (self.appleArr.count && self.appleType) {
            NSDictionary *dic = [self.appleArr lastObject];
            payWay = [NSString stringWithFormat:@"%@",  dic[@"id"]];
            if (![payWay length]) {
                kplaceToast(@"Request exception");
                return;
            }
        }
        // payWay="52"&packageId=10&token
        kSelf;
        [ML_RequestManager requestPath2:[NSString stringWithFormat:@"%@?token=%@&payWay=%@&packageId=%@", @"wallet/affirmRecharge", [ML_AppUserInfoManager sharedManager].currentLoginUserData.token, payWay, self.ID?:@""] parameters:@{@"overseasPayDto" : @""} doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
            
            if ([responseObject[@"code"] intValue] == 0) {
                NSDictionary *dic = responseObject[@"data"][@"data"];
                if (weakself.appleType) {
                    
                    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
                    [muDic setObject:self.pid?:@"" forKey:@"pid"];
                    [muDic setObject:responseObject[@"data"][@"data"]?:@"" forKey:@"orderNumber"];
                    [[ML_PayManager sharedPayManager] goChongWithProduct:muDic];
                    
                    return;
                }
                
                if ([responseObject[@"data"][@"payPattern"] intValue] == 1) {
                    WKWebViewController *rechargeVC = [WKWebViewController new];
                    rechargeVC.Rob_euCvar_Url = responseObject[@"data"][@"order"];
                    [weakself.navigationController pushViewController:rechargeVC animated:YES];
                    
                    return;
                }
                
                
                if (weakself.payway == 0) {
                    
                    if ([dic[@"payPattern"] intValue] == 1) {
                        
                        return;
                    }
                    PayReq *request = [[PayReq alloc] init];
                    request.openID = [dic objectForKey:@"appid"];
                    request.partnerId = [dic objectForKey:@"partnerid"];
                    request.prepayId= [dic objectForKey:@"prepayid"];
                    request.package = [dic objectForKey:@"package"];
                    request.nonceStr= [dic objectForKey:@"noncestr"];
                    
                    request.timeStamp= (UInt32)[[dic objectForKey:@"timestamp"] integerValue];
                    
                    request.sign = [dic objectForKey:@"sign"];
                    
                    NSDictionary *data = @{
                        @"appId"    : [dic objectForKey:@"appid"],
                        @"nonceStr" : [dic objectForKey:@"noncestr"],
                        @"partnerId": [dic objectForKey:@"partnerid"],
                        @"prepayId" : [dic objectForKey:@"prepayid"],
                        @"sign"     : [dic objectForKey:@"sign"],
                        @"timeStamp": [dic objectForKey:@"timestamp"],
                    };
                    
                    [WXTools doWXPay:data paySuccess:^{
                        NSLog(@"success！");
                        [ML_AppUserInfoManager shuaWithCoin:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
                    } payFailed:^{
                        NSLog(@"支付失败");
                    }];
                    
                } else if (weakself.payway == 1){
                    
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"order"]?:@"" fromScheme:@"alisdk" callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        [ML_AppUserInfoManager shuaWithCoin:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataJinJiNoti" object:nil];
                    }];
                } else if (weakself.payway == 2){
                    WKWebViewController *rechargeVC = [WKWebViewController new];
                    rechargeVC.Rob_euCvar_Url = responseObject[@"data"][@"order"];
                    [weakself.navigationController pushViewController:rechargeVC animated:YES];
                }
                
            } else {
                
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];;
        
    }
    
}

- (ZMWithdrawalItemView *)withdrawalAliItemView{
    if (_withdrawalAliItemView) return _withdrawalAliItemView;
    _withdrawalAliItemView = [ZMWithdrawalItemView new];
    [_withdrawalAliItemView refreshViewWithIcon:@"icon_zhifubao_26_nor" title:@"支付宝信息" bind:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawalItemAliClicked)];
    [_withdrawalAliItemView addGestureRecognizer:tap];
    return _withdrawalAliItemView;
}

- (ZMWithdrawalItemView *)withdrawalCardItemView{
    if (_withdrawalCardItemView) return _withdrawalCardItemView;
    _withdrawalCardItemView = [ZMWithdrawalItemView new];
    [_withdrawalCardItemView refreshViewWithIcon:@"bank_card" title:@"银行卡信息" bind:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawalItemCardClicked)];
    [_withdrawalCardItemView addGestureRecognizer:tap];
    return _withdrawalCardItemView;
}

- (ZMAliInfos *)aliInfo{
    if (_aliInfo) return _aliInfo;
    _aliInfo = [ZMAliInfos new];
    
    return _aliInfo;
}


- (void)withdrawalItemAliClicked{
    FYBandingController *vc = [FYBandingController new];
    vc.baoDic = self.baoDic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)withdrawalItemCardClicked{
    ZMBankCardBindViewController *vc = [ZMBankCardBindViewController new];
    vc.aliInfos = self.aliInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (ZMPayItemView *)wxPayItem{
    if (_wxPayItem) return _wxPayItem;
    _wxPayItem = [[ZMPayItemView alloc] init];
    [_wxPayItem refreshViewWithIcon:@"icon_weixin_26_nor" title:@"微信支付" tag:0];
    kSelf;
    _wxPayItem.selectBlock = ^(NSInteger index) {
        [weakself ML_apClick:weakself.wxPayItem.selectBtn];
    };
    return _wxPayItem;
}

- (ZMPayItemView *)aliPayItem{
    if (_aliPayItem) return _aliPayItem;
    _aliPayItem = [ZMPayItemView new];
    [_aliPayItem refreshViewWithIcon:@"icon_zhifubao_26_nor" title:@"支付宝支付" tag:1];
    kSelf;
    _aliPayItem.selectBlock = ^(NSInteger index) {
        [weakself ML_apClick:weakself.aliPayItem.selectBtn];
    };
    
    return _aliPayItem;
}

- (ZMPayItemView *)cardPayItem{
    if (_cardPayItem) return _cardPayItem;
    _cardPayItem = [ZMPayItemView new];
    [_cardPayItem refreshViewWithIcon:@"bank_card" title:@"银行卡支付" tag:3];
    kSelf;
    _cardPayItem.selectBlock = ^(NSInteger index) {
        [weakself ML_apClick:weakself.cardPayItem.selectBtn];
    };
    
    return _cardPayItem;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updataJinJiNoti" object:nil];
}

@end
