//
//  MLKaitongViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLKaitongViewController.h"
#import "ML_kaitongTopCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "MLMineHuiyuanCollectionViewCell.h"
#import "MLMineHuiyuanLastCollectionViewCell.h"
#import "ML_headCollectionViewCell.h"
#import <Colours/Colours.h>
#import "MLMineFootCollectionViewCell.h"

#import "ML_getTypeHostsApi.h"
#import "ML_getRandomHostsOneApi.h"
#import <JXCategoryView/JXCategoryView.h>
#import "MLKaitongPayViewController.h"
#import "MLGetVipPackagesApi.h"

@interface MLKaitongViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,JXCategoryViewDelegate>

@property (nonatomic,strong)NSMutableArray *nmarray;
@property (nonatomic, strong)NSMutableArray *selectedArray;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,assign)bool isOpen;
@property (nonatomic,assign)NSInteger tegle;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIView *ML_headVeiw;
@property (nonatomic,strong)UIView *ML_footVeiw;

@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)UICollectionView *ML_footCollectionView;

@property (nonatomic,strong)NSArray *bannersArray;
@property (nonatomic,strong)NSArray *itemimgArray;
//@property (nonatomic,strong)NSArray *itemtitleArray;
//@property (nonatomic,strong)NSArray *itemsubtitleArray;

@property (nonatomic,strong)NSMutableDictionary *nnndict;

@property (nonatomic,strong)JXCategoryTitleView *categoryView;
@property (nonatomic,strong)NSArray *titlearray;

@property (nonatomic, strong) NSArray *titleArr;// 标题数据
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;//listView
@property (nonatomic,strong)JXCategoryIndicatorLineView *lineView;

@property (nonatomic, weak) UIViewController *showingChildVc;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic,strong)UIImageView *huirangImg;
@property (nonatomic,strong)NSMutableArray *arraynumber;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *subnameLabeltitle;
@property (nonatomic,strong)UILabel *personLabel;
@property (nonatomic,strong)UILabel *timerLabel;
@property (nonatomic,strong)NSMutableArray *dddddarray;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)NSMutableArray *dddddarrayimg;

@property (nonatomic,strong)UIImageView *headbgImg;
@property (nonatomic,strong)NSMutableArray *coinarry;
@property (nonatomic,strong)NSMutableArray *amountarry;
@property (nonatomic,strong)NSMutableArray *alldataArray;
@property (nonatomic,strong)UIImageView *huiyuanImg;
@property (nonatomic,assign)NSInteger selectindex;
@property (nonatomic,strong)UIView *viewfootview;
@property (nonatomic,assign)BOOL appleType;
@property (nonatomic,strong) NSArray *appleArr;
@property (nonatomic, assign) BOOL wxPay;              //
@property (nonatomic, assign) BOOL aliPay;              //
@property (nonatomic, assign) BOOL cardPay;              //
@property (nonatomic,strong)NSArray *payList;
@property (nonatomic,strong)NSArray *headBackImages;
@property (nonatomic,strong)UICollectionView *topCollectionView;
@end

@implementation MLKaitongViewController

static NSString *ident = @"cell";

- (NSArray *)headBackImages{
    if (_headBackImages == nil) {
        _headBackImages = @[@"TopBackBaiying", @"TopBackHuangjin", @"TopBackZuanshi"];
    }
    return _headBackImages;
}

-(NSMutableArray *)alldataArray{
    if (_alldataArray == nil) {
        _alldataArray = [NSMutableArray array];
    }
    return _alldataArray;
}

-(NSMutableArray *)coinarry{
    if (_coinarry == nil) {
        _coinarry = [NSMutableArray array];
    }
    return _coinarry;
}

-(NSMutableArray *)amountarry{
    if (_amountarry == nil) {
        _amountarry = [NSMutableArray array];
    }
    return _amountarry;
}

-(NSMutableArray *)dddddarray{
    if (_dddddarray == nil) {
        _dddddarray = [NSMutableArray array];
    }
    return _dddddarray;
}

-(NSMutableArray *)dddddarrayimg{
    if (_dddddarrayimg == nil) {
        _dddddarrayimg = [NSMutableArray arrayWithArray:@[@"icon_gold_160", @"icon_bojin_160", @"icon_zuanshi_160"]];
    }
    return _dddddarrayimg;
}

-(NSMutableArray *)arraynumber{
    if (_arraynumber == nil) {
        _arraynumber = [NSMutableArray arrayWithArray:@[@"1",@"0",@"0"]];
    }
    return _arraynumber;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
    if (self.appleArr.count) {
        [SVProgressHUD show];
        kSelf;
        MLGetVipPackagesApi *api = [[MLGetVipPackagesApi alloc] initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token type:@"1" extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            [SVProgressHUD dismiss];
            NSLog(@"我的data-----%@",response.data);
            
            [SVProgressHUD dismiss];
            
            self.dict = response.data;
            
            weakself.appleType = [response.data[@"iosPurchasing"] boolValue];
            weakself.appleArr = response.data[@"apple"];
            
            weakself.wxPay = self.dict[@"vip"][@"wxPay"];
            weakself.aliPay = self.dict[@"vip"][@"aliPay"];
            weakself.cardPay = self.dict[@"vip"][@"cardPay"];
            weakself.payList = self.dict[@"payList"];
            //0-非会员 10-黄金vip 20-铂金vip 30-钻石vip
            if ([self.dict[@"vip"][@"identity"] integerValue] == 0) {
                self.subnameLabeltitle.text = Localized(@"暂未开通会员", nil);
                //self.timerLabel.hidden = YES;
                //self.personLabel.hidden = YES;
                self.timerLabel.text = Localized(@"立即升级", nil);
                self.personLabel.text = Localized(@"您目前还是普通用户", nil);
            }else{
                self.subnameLabeltitle.text = Localized(@"已开通会员", nil);
                //self.timerLabel.hidden = NO;
                //self.personLabel.hidden = NO;
                NSString *dateStr = self.dict[@"vip"][@"endTime"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *newDate = [formatter dateFromString:dateStr];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [formatter stringFromDate:newDate];
                self.timerLabel.text = [NSString stringWithFormat:@"%@%@", dateStr, Localized(@"到期", nil)];
                self.personLabel.text = self.dict[@"vip"][@"name"];
                
            }
            
            [self.ML_homeCollectionView reloadData];
            [self.ML_footCollectionView reloadData];
            
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}


-(void)giveMLGetVipPackagesApi{
/**************************/
//    [self ML_setupHeadUI];//删除代码
    self.appleType = NO;
    self.appleArr = nil;
    self.wxPay = self.dict[@"vip"][@"wxPay"];
    self.aliPay = self.dict[@"vip"][@"aliPay"];
    self.cardPay = self.dict[@"vip"][@"cardPay"];
    self.payList = self.dict[@"payList"];
    //0-非会员 10-黄金vip 20-铂金vip 30-钻石vip
    if ([self.dict[@"vip"][@"identity"] integerValue] == 0) {
        self.subnameLabeltitle.text = Localized(@"暂未开通会员", nil);
        //self.timerLabel.hidden = YES;
        //self.personLabel.hidden = YES;
        self.timerLabel.text = Localized(@"立即升级", nil);
        self.personLabel.text = Localized(@"您目前还是普通用户", nil);
    }else{
        int identity = [self.dict[@"vip"][@"identity"] integerValue];
        switch (identity){
            case 10:
                self.huirangImg.image = kGetImage(@"card_vip_gold_160");
                break;
            case 20:
                self.huirangImg.image = kGetImage(@"card_vip_baijin_160");
                break;
            case 30:
                self.huirangImg.image = kGetImage(@"Group 43238");
                break;
        }
        
        
        
        
        self.subnameLabeltitle.text = Localized(@"已开通会员", nil);
        //self.timerLabel.hidden = NO;
        //self.personLabel.hidden = NO;
        NSString *dateStr = self.dict[@"vip"][@"endTime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
       [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
       NSDate *newDate = [formatter dateFromString:dateStr];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        dateStr = [formatter stringFromDate:newDate];
        self.timerLabel.text = [NSString stringWithFormat:@"%@%@", dateStr, Localized(@"到期", nil)];
        self.personLabel.text = self.dict[@"vip"][@"name"];
        
    }
    [self.dddddarray removeAllObjects];
    [self.dict[@"vips"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dddddarray addObject:dict[@"name"]];
    }];


    self.array = self.dict[@"vips"][self.index][@"details"];
    if (!self.array.count)
    {
        self.array = [NSArray array];
    }
    [self.dict[@"vips"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.alldataArray addObject:dict];
    }];

//        if (self.dddddarrayimg.count != 0) {
//            [self.huirangImg sd_setImageWithURL:[NSURL URLWithString:self.dddddarrayimg[self.index]]];
//        }
    [self.huirangImg setImage:kGetImage(self.dddddarrayimg[self.index])];
    
    [self.headImg layoutIfNeeded];
    [self.huirangImg layoutIfNeeded];
    [self.huiyuanImg layoutIfNeeded];
    //[self.categoryView reloadData];
    [self.ML_homeCollectionView reloadData];
    [self.ML_footCollectionView reloadData];
/***********************************/
    [SVProgressHUD show];
    kSelf;
    MLGetVipPackagesApi *api = [[MLGetVipPackagesApi alloc] initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token type:@"1" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        NSLog(@"我的data-----%@",response.data);
        [self ML_setupHeadUI];
        self.dict = response.data;
        
        weakself.appleType = [response.data[@"iosPurchasing"] boolValue];
        weakself.appleArr = response.data[@"apple"];
        weakself.wxPay = self.dict[@"vip"][@"wxPay"];
        weakself.aliPay = self.dict[@"vip"][@"aliPay"];
        weakself.cardPay = self.dict[@"vip"][@"cardPay"];
        weakself.payList = self.dict[@"payList"];
        //0-非会员 10-黄金vip 20-铂金vip 30-钻石vip
        if ([self.dict[@"vip"][@"identity"] integerValue] == 0) {
            self.subnameLabeltitle.text = Localized(@"暂未开通会员", nil);
            //self.timerLabel.hidden = YES;
            //self.personLabel.hidden = YES;
            self.timerLabel.text = Localized(@"立即升级", nil);
            self.personLabel.text = Localized(@"您目前还是普通用户", nil);
        }else{
            int identity = [self.dict[@"vip"][@"identity"] integerValue];
            switch (identity){
                case 10:
                    self.huirangImg.image = kGetImage(@"card_vip_gold_160");
                    break;
                case 20:
                    self.huirangImg.image = kGetImage(@"card_vip_baijin_160");
                    break;
                case 30:
                    self.huirangImg.image = kGetImage(@"Group 43238");
                    break;
            }
            
            
            
            
            self.subnameLabeltitle.text = Localized(@"已开通会员", nil);
            //self.timerLabel.hidden = NO;
            //self.personLabel.hidden = NO;
            NSString *dateStr = self.dict[@"vip"][@"endTime"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
           [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
           NSDate *newDate = [formatter dateFromString:dateStr];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            dateStr = [formatter stringFromDate:newDate];
            self.timerLabel.text = [NSString stringWithFormat:@"%@%@", dateStr, Localized(@"到期", nil)];
            self.personLabel.text = self.dict[@"vip"][@"name"];
            
        }
        [self.dddddarray removeAllObjects];
        [self.dict[@"vips"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dddddarray addObject:dict[@"name"]];
        }];


        self.array = self.dict[@"vips"][self.index][@"details"];
        if (!self.array.count)
        {
            self.array = [NSArray array];
        }
        [self.dict[@"vips"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.alldataArray addObject:dict];
        }];


        [self.huirangImg setImage:kGetImage(self.dddddarrayimg[self.index])];
        
        [self.headImg layoutIfNeeded];
        [self.huirangImg layoutIfNeeded];
        [self.huiyuanImg layoutIfNeeded];
        //[self.categoryView reloadData];
        [self.ML_homeCollectionView reloadData];
        [self.ML_footCollectionView reloadData];
        
    } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}


-(NSArray *)bannersArray{
    if (_bannersArray == nil) {
        _bannersArray = @[Localized(@"黄金", nil),Localized(@"铂金", nil),Localized(@"钻石", nil)];
    }
    return _bannersArray;
}

-(NSArray *)itemimgArray{
    if (_itemimgArray == nil) {
        _itemimgArray = @[@"icon_huiyuanxunzhang_30_nor",@"icon_chakanfangke_28_nor",@"icon_tongzhi_30_nor",@"icon_zhuanxiangfuli_30_nor",@"icon_chongzhizengsong_32_nor",@"icon_yinsimoshi_32_nor",@"icon_mianfeiliaotian_30_nor", @""];
    }
    return _itemimgArray;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithArray:@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)]];
    }
    return _data;
}

-(NSMutableArray *)selectedArray{
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    //[self ML_setupFooterUI];
    self.index = 0;
    [self giveMLGetVipPackagesApi];
  }

-(void)setupUI{

        self.viewfootview = [[UIView alloc]init];
        self.viewfootview.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:self.viewfootview];
        [self.viewfootview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(221*mHeightScale);
        }];
    
        UICollectionViewFlowLayout *headflowLayout = [[UICollectionViewFlowLayout alloc]init];
        //1-1、设置Cell大小
        headflowLayout.itemSize= CGSizeMake(108*mWidthScale, 86*mHeightScale);
        //1-2、设置四周边距
//        headflowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 8);
        headflowLayout.minimumInteritemSpacing = 10*mWidthScale;
    headflowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //headflowLayout.itemSize= CGSizeMake((self.view.frame.size.width-21)/2, 180);
        // 设置滚动的方向
        [headflowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.ML_footCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:headflowLayout];
        //3、设置背景为白色
        self.ML_footCollectionView.backgroundColor = [UIColor whiteColor];
        //4、设置数据源代理
        self.ML_footCollectionView.dataSource = self;
        self.ML_footCollectionView.delegate = self;
        [self.ML_footCollectionView registerClass:[MLMineFootCollectionViewCell class] forCellWithReuseIdentifier:@"footcell"];
        //添加到视图中
        [self.viewfootview addSubview:self.ML_footCollectionView];
        //注册Cell视图
        [self.ML_footCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.viewfootview.mas_left).mas_offset(0);
            make.right.mas_equalTo(self.viewfootview.mas_right).mas_offset(0);
            make.height.mas_equalTo(86);
            make.top.mas_equalTo(self.viewfootview.mas_top).mas_offset(10);
     }];
    
    UIButton *kaitongBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.viewfootview addSubview:kaitongBt];
    [kaitongBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.viewfootview.mas_centerX);
        make.top.mas_equalTo(self.ML_footCollectionView.mas_bottom).offset(20*mHeightScale);
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(48*mHeightScale);
    }];
    
    [kaitongBt setTitle:@"开通会员" forState:UIControlStateNormal];
    kaitongBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [kaitongBt setTitleColor:kGetColor(@"ffffff") forState:UIControlStateNormal];
    [kaitongBt addTarget:self action:@selector(kaitong:) forControlEvents:UIControlEventTouchUpInside];
    [kaitongBt setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
        CGFloat statusBarHeight = 0;
        if (@available(iOS 13.0, *)) {
        statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
        } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }

        //1、实例化一个流水布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //1-1、设置Cell
        flowLayout.itemSize= CGSizeMake(([UIScreen mainScreen].bounds.size.width - 56)/3, 105);
        //1-2、设置四周边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 14, 0, 14);
        flowLayout.minimumInteritemSpacing = 14;
        flowLayout.minimumLineSpacing = 10;

        self.ML_homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //3、设置背景为白色
    self.ML_homeCollectionView.backgroundColor = UIColor.whiteColor;
        //4、设置数据源代理
        self.ML_homeCollectionView.dataSource = self;
        self.ML_homeCollectionView.delegate = self;
        self.ML_homeCollectionView.userInteractionEnabled = YES;
        //添加到视图中
        //注册Cell视图
        [self.ML_homeCollectionView registerClass:[MLMineHuiyuanCollectionViewCell class] forCellWithReuseIdentifier:ident];
        //[self.ML_homeCollectionView registerClass:[MLMineHuiyuanLastCollectionViewCell class] forCellWithReuseIdentifier:@"lastcell"];
        [self.ML_homeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReusableView"];
//        [self.ML_homeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReusableView"];
        [self.view addSubview:self.ML_homeCollectionView];
        [self.ML_homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
            make.top.mas_equalTo(307*mHeightScale);
        //make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(self.viewfootview.mas_top);
        }];
}

- (void)kaitong:(UIButton*)sender{
    MLKaitongPayViewController *vc = [[MLKaitongPayViewController alloc]init];
    vc.dict = self.alldataArray[self.index];
    vc.paylist = self.payList;
    vc.appleType = self.appleType;
    vc.appleArr = self.appleArr;
    vc.page = self.index;
    vc.wxPay = self.wxPay;
    vc.aliPay = self.aliPay;
    vc.cardPay = self.cardPay;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark headView大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        return CGSizeMake(ML_ScreenWidth,50*mHeightScale);
    }else{
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 70)/4, 105);
    }else if ([collectionView isEqual:self.topCollectionView]){
        return CGSizeMake(ML_ScreenWidth, 144*mHeightScale);
    }else{
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 40)/3, 83);
    }
}


//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]&&[collectionView isEqual:self.ML_homeCollectionView]) {
       
            UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headReusableView" forIndexPath:indexPath];
           //添加头视图的内容
            for (UIView *view in header.subviews){
                [view removeFromSuperview];
            }
           UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(16*mWidthScale, 24*mHeightScale, 71*mWidthScale, 14*mHeightScale)];
           iv.image = kGetImage(@"quanyi");
           [header addSubview:iv];
           return header;
    }
    return nil;
}


-(void)ML_setupHeadUI{
    self.ML_headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 320*mHeightScale)];
    self.ML_headVeiw.userInteractionEnabled = YES;
    UIImageView *headbgImg =[[UIImageView alloc]init];
    headbgImg.image = [UIImage imageNamed:@"TopBackZuanshi"];
    headbgImg.userInteractionEnabled = YES;
    [self.ML_headVeiw addSubview:headbgImg];
    self.headbgImg = headbgImg;
    [headbgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(320*mHeightScale);
    }];
    
    self.ML_navView.hidden = YES;
//    self.ML_navAlphaView.backgroundColor = [UIColor whiteColor];
//    self.ML_navAlphaView.alpha = 0;
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = Localized(@"会员中心", nil);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [headbgImg addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headbgImg.mas_top).mas_offset(55);
        make.centerX.mas_equalTo(headbgImg.mas_centerX);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-1"] forState:UIControlStateNormal];
    [headbgImg addSubview:backBtn];
    [backBtn setBackgroundImage:kGetImage(@"kaitongBG") forState:UIControlStateNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.left.mas_equalTo(headbgImg.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
    }];
  /**顶部collectionView**/
    //1、实例化一个流水布局
    UICollectionViewFlowLayout *topflowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    topflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.topCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:topflowLayout];
    self.topCollectionView.delegate = self;
    self.topCollectionView.dataSource = self;
    [self.topCollectionView registerClass:[ML_kaitongTopCollectionViewCell class] forCellWithReuseIdentifier:@"TopCell"];
    [headbgImg addSubview:self.topCollectionView];
    [self.topCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(101*mHeightScale);
        make.height.mas_equalTo(144*mHeightScale);
    }];
    self.topCollectionView.backgroundColor = UIColor.clearColor;
    self.topCollectionView.pagingEnabled = YES;
    self.topCollectionView.showsHorizontalScrollIndicator = NO;
    self.topCollectionView.scrollEnabled = NO;

    
    self.categoryView = [[JXCategoryTitleView alloc]init];
    //self.categoryView.titles = @[@"黄金VIP", @"铂金VIP",@"钻石VIP"];
    self.categoryView.titles = self.dddddarray;
    self.categoryView.titleColor = [UIColor colorFromHexString:@"#666666"];
    self.categoryView.titleFont = [UIFont systemFontOfSize:14];
    //self.categoryView.userInteractionEnabled = YES;
    //self.categoryView.cellSpacing = 28;
    self.categoryView.titleSelectedColor = [UIColor colorFromHexString:@"#000000"];
    self.categoryView.defaultSelectedIndex = self.index;
    //self.categoryView.titleColorGradientEnabled = NO;
    //self.categoryView.titleLabelZoomScale = 1.3;
    self.categoryView.titleLabelVerticalOffset = 0;
    //self.categoryView.contentScrollView = self.listContainerView.scrollView;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorFromHexString:@"#333333"];
    //lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorWidth = 20;
    lineView.indicatorHeight = 5;
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
    
    JXCategoryIndicatorImageView *imageLineView = [[JXCategoryIndicatorImageView alloc] init];
    imageLineView.indicatorImageView.image = kGetImage(@"CategoryBack");
    imageLineView.indicatorImageViewSize = CGSizeMake(148*mWidthScale, 46*mHeightScale);

    self.categoryView.indicators = @[lineView,imageLineView];
    self.categoryView.delegate = self;
    [self.ML_headVeiw addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(261*mHeightScale);
        make.left.mas_equalTo(-50);
        make.right.mas_equalTo(50);
        make.height.mas_equalTo(46*mHeightScale);
    }];
    [self.view addSubview:self.ML_headVeiw];
    [self.view bringSubviewToFront:self.ML_homeCollectionView];
}

-(void)timerclick{
    //[self.collectionView setContentOffset:CGPointMake(0, self.ML_homeCollectionView.contentSize.height - self.ML_homeCollectionView.frame.size.height) animated:YES];
    CGPoint off = self.ML_homeCollectionView.contentOffset;
    off.y = self.ML_homeCollectionView.contentSize.height - self.ML_homeCollectionView.bounds.size.height + self.ML_homeCollectionView.contentInset.bottom;
    [self.ML_homeCollectionView setContentOffset:off animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.headImg.layer.cornerRadius = self.headImg.frame.size.width / 2;
    self.headImg.layer.masksToBounds = YES;
    [self.headImg layoutIfNeeded];
    //[self.ML_headVeiw layoutIfNeeded];
}


#pragma mark --- JXCategoryViewDelegate ------
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    self.index = index;
    self.headbgImg.image = kGetImage(self.headBackImages[self.index]);
    switch (self.index) {
        case 0:
            self.categoryView.titleSelectedColor = kGetColor(@"42777e");
            break;
        case 1:
            self.categoryView.titleSelectedColor = kGetColor(@"936624");
            break;
        case 2:
            self.categoryView.titleSelectedColor = kGetColor(@"5e4884");
            break;
        default:
            break;
    }
    
    if (self.dddddarray.count<3) {
        self.headbgImg.image = kGetImage(self.headBackImages[2]);
        self.categoryView.titleSelectedColor = kGetColor(@"5e4884");
    }
    
    self.array = self.dict[@"vips"][self.index][@"details"];
    [self.ML_homeCollectionView reloadData];
    [self.ML_footCollectionView reloadData];
    [self.topCollectionView setContentOffset:CGPointMake(index*ML_ScreenWidth, 0) animated:YES];
}

-(void)backclick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minAlphaOffset = -(ML_NavViewHeight);
    CGFloat maxAlphaOffset = 300;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    self.ML_navAlphaView.alpha = alpha<0.25?0:alpha;
}


//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.ML_footCollectionView]||[collectionView isEqual:self.topCollectionView]) {
        //return self.amountarry.count;
        return self.alldataArray.count;
    }else{
        return self.array.count;
    }
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([collectionView isEqual:self.ML_footCollectionView]) {
        MLMineFootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"footcell" forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[MLMineFootCollectionViewCell alloc]init];
            }
        
//        if (self.alldataArray.count != 0 && indexPath.row == 0) {
            NSDictionary *dict = self.alldataArray[indexPath.row];
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%@", kisCH?@"￥":@"$", dict[@"amount"]];
        cell.subtitleLabel.font = [UIFont systemFontOfSize:24];
            cell.subtitleLabel.textColor = [UIColor colorFromHexString:@"#999999"];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@%@%@",Localized(@"送", nil), dict[@"coin"], Localized(@"金币", nil)];
            cell.nameLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
            if ([dict[@"validMonth"] intValue] >= 100) {
                cell.titleLabel.text = Localized(@"永久", nil);
            } else {
                cell.titleLabel.text = [NSString stringWithFormat:@"%@%@",dict[@"validMonth"], Localized(@"个月", nil)];
            }
            cell.titleLabel.textColor= [UIColor colorFromHexString:@"#000000"];
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        
            BOOL mag = !(indexPath.row == self.index);
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 8;
        cell.topimgView.image = mag?[UIImage imageNamed:@"Slice 20"]:[UIImage imageNamed:@"Slice 20"];
        if(!mag){
            cell.imageView.image = kGetImage(@"kaitongBottomS");
        }else{
            cell.imageView.image = kGetImage(@"kaitongBottom");
        }
        if (!mag) {
            
            cell.subtitleLabel.textColor = [UIColor colorFromHexString:@"#ffffff"];
            cell.titleLabel.textColor= [UIColor colorFromHexString:@"#ffffff"];
        }
     
            return cell;
        
    }else if ([collectionView isEqual:self.topCollectionView]){
        ML_kaitongTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopCell" forIndexPath:indexPath];
        cell.backIV.image = kGetImage(@"icon_zuanshi_160");
        return cell;
    }else{
        MLMineHuiyuanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[MLMineHuiyuanCollectionViewCell alloc]init];
            }
        NSDictionary *dictt = [self dictionaryWithJsonString:self.array[indexPath.row]];
        NSLog(@"%@",dictt);
//        [cell.imageView sd_setImageWithURL:kGetUrlPath(dictt[@"icon"]) placeholderImage:nil];
        cell.imageView.image = kGetImage(self.itemimgArray[indexPath.row]);
        cell.nameLabel.text = dictt[@"title"];
        cell.titleLabel.text = dictt[@"desc"];
            return cell;

    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([collectionView isEqual:self.ML_footCollectionView] && indexPath.row == self.index) {
        MLKaitongPayViewController *vc = [[MLKaitongPayViewController alloc]init];
        vc.dict = self.alldataArray[self.index];
        vc.paylist = self.payList;
        vc.appleType = self.appleType;
        vc.appleArr = self.appleArr;
        vc.page = indexPath.row;
        vc.wxPay = self.wxPay;
        vc.aliPay = self.aliPay;
        vc.cardPay = self.cardPay;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
    
@end
