// 123123
//  MLRecommendViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLRecommendViewController.h"
#import <Masonry/Masonry.h>
#import "ML_HotCollectionViewCell.h"
#import "ML_headCollectionViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <Colours/Colours.h>
#import "ML_ForyouViewController.h"

#import "ML_GetUserInfoApi.h"
#import "ML_bannerApi.h"
#import "ML_ForyouApi.h"
#import "ML_getTypeHostsApi.h"
#import "ML_getRandomHostsOneApi.h"
#import "MJRefresh.h"
#import "ML_HostdetailsViewController.h"
#import "ML_HostVideoViewController.h"
#import "MLNewestVersionShowView.h"
#import "ML_NewestVersionApi.h"
#import "NSString+ML_MineVersion.h"
#import "UIViewController+MLHud.h"
#import "MLHomeOnlineViewController.h"
#import "MLHomeOnlineBottomView.h"
#import "MLHomeOneZhaohuView.h"
#import "Rob_euCHNRefreshGifHeader.h"
#import "Rob_euCHNRefreshFooter.h"
#import "MLZhaohuListApi.h"

@interface MLRecommendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSTimer *countDownTimer; // 计时器
@property (nonatomic, assign) int seconds; // 倒计时总时长
@property (nonatomic,strong)NSMutableArray *nmarray;
@property (nonatomic, strong)NSMutableArray *selectedArray;
@property (nonatomic,strong)UIButton *button_recommended_40;
@property (nonatomic,strong)UIButton *LingBtn1;
@property (nonatomic,strong)UILabel *recommendExpireLabel;
@property (nonatomic,assign)bool isOpen;
@property (nonatomic,assign)NSInteger tegle;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIView *ML_headVeiw;
@property (nonatomic,strong)UIImageView *foryouImg;


// 网络图片
@property (nonatomic, strong) SDCycleScrollView * ML_webCycleScrollView;
@property (nonatomic, strong) SDCycleScrollView * ML_webCycleScrollView2;
@property (nonatomic, strong) NSArray *broadcasts;
@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;
@property (nonatomic,strong)UICollectionView *ML_headCollectionView;
@property (nonatomic,strong)NSArray *callContents;
@property (nonatomic,strong)NSMutableArray *bannersArray;
@property (nonatomic,strong)NSMutableArray *foryouArray;
@property (nonatomic,strong)NSDictionary *foryouDic;
@property (nonatomic,strong)NSMutableArray *homearray;

@property (nonatomic,strong)NSMutableDictionary *nnndict;
@property (nonatomic,strong)UIButton *laNameV;
@property (nonatomic,strong)MLNewestVersionShowView *versionShowView;
//@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong)MLHomeOneZhaohuView *oneZhaohuView;
@end

@implementation MLRecommendViewController

static NSString *ident = @"cell";


-(NSMutableArray *)homearray{
    if (_homearray == nil) {
        _homearray = [NSMutableArray array];
    }
    return _homearray;
}

-(NSMutableArray *)bannersArray{
    if (_bannersArray == nil) {
        _bannersArray = [NSMutableArray array];
    }
    return _bannersArray;
}

-(NSMutableArray *)foryouArray{
    if (_foryouArray == nil) {
        _foryouArray = [NSMutableArray array];
    }
    return _foryouArray;
}

-(NSMutableArray *)selectedArray{
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark 轮播
- (SDCycleScrollView *)ML_webCycleScrollView{
    if (!_ML_webCycleScrollView){
        _ML_webCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"bannerZhan"]];
        _ML_webCycleScrollView.layer.cornerRadius = 12;
        _ML_webCycleScrollView.layer.masksToBounds = YES;
        _ML_webCycleScrollView.delegate = self;
        // 分页控件的位置
        _ML_webCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _ML_webCycleScrollView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_ML_webCycleScrollView adjustWhenControllerViewWillAppera];
    [_ML_webCycleScrollView2 adjustWhenControllerViewWillAppera];
    
    
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue] && !_LingBtn1){
        
        
        UIButton *LingBtn1 = [[UIButton alloc] init];
        LingBtn1.tag = 0;
        [LingBtn1 setBackgroundImage:kGetImage(@"button_chat_32") forState:UIControlStateNormal];
        [LingBtn1 addTarget:self action:@selector(LingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:LingBtn1];
        self.LingBtn1 = LingBtn1;
        [LingBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).mas_offset(0);
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-20);
            make.width.mas_equalTo(83);
            make.height.mas_equalTo(32);
        }];
        
    }
    
}

- (SDCycleScrollView *)ML_webCycleScrollView2{
    if (!_ML_webCycleScrollView2){
        _ML_webCycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"bannerZhan"]];
        _ML_webCycleScrollView2.placeholderImage = nil;
        _ML_webCycleScrollView2.layer.borderWidth = 0.5;
        _ML_webCycleScrollView2.layer.borderColor = [UIColor colorWithRed:228/255.0 green:216/255.0 blue:255/255.0 alpha:1.0].CGColor;
        _ML_webCycleScrollView2.backgroundColor = [UIColor colorWithRed:251/255.0 green:250/255.0 blue:255/255.0 alpha:1.0];
        _ML_webCycleScrollView2.layer.cornerRadius = 8;
        _ML_webCycleScrollView2.layer.masksToBounds = YES;
        _ML_webCycleScrollView2.onlyDisplayText = YES;
        _ML_webCycleScrollView2.scrollDirection = UICollectionViewScrollDirectionVertical;
        _ML_webCycleScrollView2.titleLabelTextColor =  [UIColor blackColor];
        _ML_webCycleScrollView2.titleLabelBackgroundColor = [UIColor clearColor];
        _ML_webCycleScrollView2.titleLabelTextFont =  [UIFont systemFontOfSize:12];
        _ML_webCycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;

        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = kGetImage(@"icon_horn");
        [_ML_webCycleScrollView2 addSubview:img];
    }
    return _ML_webCycleScrollView2;
}




// 点击图片代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
    // 清理缓存
    [SDCycleScrollView clearImagesCache];
}

// 滚动到第几张图片的回调
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}

-(void)giveML_getTypeHostsApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    kSelf;
    ML_getTypeHostsApi *api = [[ML_getTypeHostsApi alloc] initWithtoken:token type:@"0" page:[NSString stringWithFormat:@"%ld", self.page] limit:@"20" location:@"" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        NSArray *arr = response.data[@"hosts"];
        
        arr = [NSArray changeType:arr];
        
        if (weakself.page == 1) {
            [weakself.homearray removeAllObjects];
            
            if ((!_button_recommended_40) && [ML_AppUserInfoManager.sharedManager.currentLoginUserData.host boolValue]) {
                UIButton *button_recommended_40 = [[UIButton alloc] init];
                button_recommended_40.tag = 1;
                [button_recommended_40 setBackgroundImage:kGetImage(@"button_recommended_40") forState:UIControlStateNormal];
                [button_recommended_40 setBackgroundImage:kGetImage(@"button_recommende_40") forState:UIControlStateSelected];
                [button_recommended_40 addTarget:weakself action:@selector(LingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [weakself.view addSubview:button_recommended_40];
                [button_recommended_40 mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.mas_equalTo(weakself.view).mas_offset(10);
                    make.centerX.mas_equalTo(weakself.view.mas_centerX);
                    make.bottom.mas_equalTo(weakself.view.mas_bottom).mas_offset(-12);
                    make.width.mas_equalTo(124);
                    make.height.mas_equalTo(44);
                }];
                weakself.button_recommended_40 = button_recommended_40;
                weakself.button_recommended_40.selected = [weakself.foryouDic[@"recommend"] boolValue];
                
                UILabel *label = [[UILabel alloc] init];
                label.hidden = YES;
                label.frame = CGRectMake(40,3,78,22);
                label.numberOfLines = 0;
                [button_recommended_40 addSubview:label];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:Localized(@"上推荐", nil) attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
                label.attributedText = string;
                label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
                label.textAlignment = NSTextAlignmentLeft;
                label.alpha = 1.0;

                UILabel *label2 = [[UILabel alloc] init];
                weakself.recommendExpireLabel = label2;
//                label2.frame = CGRectMake(label.x,label.height,67,14);
                label2.frame = CGRectMake(0,label.height + 3,124,14);
//                label2.numberOfLines = 0;
                [button_recommended_40 addSubview:label2];
                label2.textAlignment = NSTextAlignmentCenter;
                label2.alpha = 1.0;

                if (!weakself.button_recommended_40.selected) {
                    
                    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"10%@", Localized(@"分钟/次", nil)] attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]}];
                    weakself.recommendExpireLabel.attributedText = string2;
                }
                else {
                    weakself.seconds = [weakself.foryouDic[@"recommendExpire"] intValue];
                    if (weakself.seconds > 0){
                        weakself.countDownTimer = nil;
                        weakself.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePress) userInfo:nil repeats:YES];
                        [weakself.countDownTimer setFireDate:[NSDate distantPast]];
                    }
                }
            }
        }
        
        for (NSDictionary *dic in arr) {
            
            [weakself.homearray addObject:dic];
            
        }
        
        if (arr.count) {
            [weakself.ML_homeCollectionView reloadData];
        } else {
            
            self.ML_homeCollectionView.mj_footer.hidden = YES;
        }
        
        [weakself.ML_homeCollectionView.mj_footer endRefreshing];
        [weakself.ML_homeCollectionView.mj_header endRefreshing];
        
    [self.ML_homeCollectionView.mj_header endRefreshing];
        [self.ML_homeCollectionView.mj_footer endRefreshing];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

-(void)giveML_bannerApi{
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_bannerApi *api = [[ML_bannerApi alloc] initWithtoken:token extra:[self jsonStringForDictionary]];
    [SVProgressHUD show];
    [self.bannersArray removeAllObjects];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        self.broadcasts =  response.data[@"broadcasts"]; // 不要广播
        [self ML_setupHeadUI];
        NSLog(@"轮播图-------%@",response.data);
        [response.data[@"banners"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
            NSString *ss = [NSString stringWithFormat:@"%@%@",basess,dict[@"img"]];
            [self.bannersArray addObject:ss];
        }];
        self.ML_webCycleScrollView.imageURLStringsGroup = self.bannersArray;
        NSMutableArray *muArr = [NSMutableArray array];
        for (NSDictionary *ad in self.broadcasts) {
            [muArr addObject:[NSString stringWithFormat:@"         %@", ad[@"title"]]];
        }
        self.ML_webCycleScrollView2.titlesGroup = muArr;
        if (!muArr.count) {
            self.ML_webCycleScrollView2.hidden = YES;
            
        } else {
            self.ML_headVeiw.frame = CGRectMake(0, 0, self.view.bounds.size.width, 374);
        }
        
        [self.ML_homeCollectionView.mj_header endRefreshing];
        [self.ML_homeCollectionView.mj_footer endRefreshing];

     } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

-(void)giveML_ForyouApi{
    kSelf;
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_ForyouApi *api = [[ML_ForyouApi alloc]initWithtoken:token page:@"1" limit:@"50" extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        self.foryouArray = response.data[@"hosts"];
        self.foryouDic = response.data;
        NSLog(@"为你优选-----%lu",(unsigned long)self.foryouArray.count);
        self.button_recommended_40.selected = [self.foryouDic[@"recommend"] boolValue];
        
        if (!weakself.button_recommended_40.selected) {
            
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"10%@", Localized(@"分钟/次", nil)] attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]}];
            weakself.recommendExpireLabel.attributedText = string2;
        } else {
            weakself.seconds = [weakself.foryouDic[@"recommendExpire"] intValue];
            if (weakself.seconds > 0){
                weakself.countDownTimer = nil;
                weakself.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePress) userInfo:nil repeats:YES];
                [weakself.countDownTimer setFireDate:[NSDate distantPast]];
            }
//            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", ] attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
//            weakself.recommendExpireLabel.attributedText = string2;
        }
        
        [self.ML_headCollectionView reloadData];
        [self.ML_homeCollectionView.mj_header endRefreshing];
        [self.ML_homeCollectionView.mj_footer endRefreshing];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

//获取版本
-(void)versionApi{
    kSelf;
    ML_NewestVersionApi *api = [[ML_NewestVersionApi alloc]initWithtype:@"1" extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        if([response.data[@"version"] isEqual:[NSNull null]])
        {

            NSLog(@"---NSNull---KDA!");
            return;
        }
        
        if(![response.data[@"version"] isKindOfClass:[NSDictionary class]])
        {

            NSLog(@"--NO-NSDictionary---KDA!");
            return;
        }
        
        if(response.data[@"version"] == nil)
        {

            NSLog(@"---nil---KDA!");
            return;
        }
        
        if(response.data[@"version"] == NULL)
        {

            NSLog(@"--NULL---KDA!");
            return;
        }
        
        
        
        NSLog(@"版本更新----%@--%@",response, [[NSUserDefaults standardUserDefaults] objectForKey:@"isGeng"]);
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isGeng"]) {
//            localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"isGeng"];
//        }
        NSString *webVersion = [NSString stringWithFormat:@"%@", response.data[@"version"][@"code"]];
        NSInteger ss = [NSString compareVersion:webVersion to:localVersion];
        if (ss > 0) {
            NSLog(@"去更新版本");
            [self setupnewversionview:response.data[@"version"]];
        }else{
            
            NSLog(@"没有新版本");
        }

        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
    ML_GetUserInfoApi *api2 = [[ML_GetUserInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token?:@"" extra:[self jsonStringForDictionary]];
    [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response2) {
        NSLog(@"我的信息---%@",response2.data);

        UserInfoData * loginCurrentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

        UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response2.data[@"user"]];
        if (response2.data[@"pay"]) {
            currentData.alipay_U = [NSString stringWithFormat:@"%@", response2.data[@"pay"][@"alipay"]];
            currentData.wxpay_U = [NSString stringWithFormat:@"%@", response2.data[@"pay"][@"wxpay"]];
        }
        currentData.domain = loginCurrentData.domain;
        currentData.thirdId = loginCurrentData.thirdId;
        currentData.imToken = loginCurrentData.imToken;
        currentData.must = loginCurrentData.must;
        currentData.token = loginCurrentData.token;
        currentData.userId = loginCurrentData.userId;
        currentData.wxPay = loginCurrentData.wxPay;

        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
      
        
        if (![ML_AppUserInfoManager sharedManager].currentLoginUserData.isHello && [[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender boolValue]) {
            //一键打招呼设置
            [weakself onekeyzhaohu];
        }
        if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]){
            
            
            UIButton *LingBtn1 = [[UIButton alloc] init];
            LingBtn1.tag = 0;
            [LingBtn1 setBackgroundImage:kGetImage(@"button_chat_32") forState:UIControlStateNormal];
            [LingBtn1 addTarget:weakself action:@selector(LingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [weakself.view addSubview:LingBtn1];
            [LingBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakself.view).mas_offset(0);
                make.bottom.mas_equalTo(weakself.view.mas_bottom).mas_offset(-20);
                make.width.mas_equalTo(83);
                make.height.mas_equalTo(32);
            }];
            
        }

        if ([ML_AppUtil isCensor]) {
            
            [weakself onlineView];
        }
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"behavior"]) {
            UIView *view3 = [[UIView alloc] initWithFrame:weakself.view.window.bounds];
            view3.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
            [weakself.view.window addSubview:view3];
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 311, 485)];
            imgV.userInteractionEnabled = YES;
            [view3 addSubview:imgV];
            imgV.image = kGetImage(@"user_behavior_background");
            imgV.center = CGPointMake(ML_ScreenWidth / 2, ML_ScreenHeight / 2);
            
            UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgV.width - 30, 60)];
            btn3.tag = 11;
            [btn3 addTarget:weakself action:@selector(chaView3:) forControlEvents:UIControlEventTouchUpInside];
            btn3.center = CGPointMake(imgV.width / 2, imgV.height - 44);
            [imgV addSubview:btn3];
        }

    } error:^(MLNetworkResponse *response) {

    } failure:^(NSError *error) {

    }];
    
}

- (void)LingBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) { // 上推荐
        
        if (btn.selected) {
            return;
        }
        ML_CommonApi *api2 = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"user/topRecommend"];
        kSelf;
        [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            
            
            NSDictionary *dic = response.data;
            if ([dic[@"recommendCode"] intValue] == 0) {
                btn.selected = YES;
                
                kplaceToast(@"上推荐成功");
                
                [weakself.ML_homeCollectionView reloadData];
                [weakself.ML_headCollectionView reloadData];
                
                weakself.seconds = [dic[@"recommendExpire"] intValue];
                if (weakself.seconds > 0){
                    weakself.countDownTimer = nil;
                    weakself.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePress) userInfo:nil repeats:YES];
                    [weakself.countDownTimer setFireDate:[NSDate distantPast]];
                }
                
            } else if ([dic[@"recommendCode"] intValue] == 1) {
                btn.selected = YES;
                
               NSString *str =  [NSString stringWithFormat:@"%@%@%@", Localized(@"请求频繁，请等待：", nil), dic[@"recommendExpire"], Localized(@"秒", nil)];
                
                kplaceToast(str);
            }
                
            
        } error:^(MLNetworkResponse *response) {
    
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
        
    } else { // 一键搭讪
        UIView *view3 = [[UIView alloc] initWithFrame:self.view.window.bounds];
        view3.backgroundColor = [UIColor clearColor];
        [self.view.window addSubview:view3];
        
        CGFloat imgW = 343;
        if (ML_ScreenWidth < 343) {
            imgW = ML_ScreenWidth;
        }
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((ML_ScreenWidth - imgW) / 2, ML_ScreenHeight - 244 - ML_TabbarHeight - 10, imgW, 244)];
        imgV.userInteractionEnabled = YES;
        imgV.image = kGetImage(@"pop_up_background");
        [view3 addSubview:imgV];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 303, 48)];
        btn3.tag = 1;
        btn3.layer.cornerRadius = 24;
        [btn3 setTitle:@"一键搭讪" forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn3 setBackgroundImage:kGetImage(@"button_chat_unchecked") forState:UIControlStateNormal];
        btn3.backgroundColor = kZhuColor;
        [btn3 addTarget:self action:@selector(chaView3:) forControlEvents:UIControlEventTouchUpInside];
        btn3.center = CGPointMake(imgV.width / 2, imgV.height - 30);
        [imgV addSubview:btn3];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(imgV.width - 40, 40, 40, 40)];
        [btn addTarget:self action:@selector(chaView3:) forControlEvents:UIControlEventTouchUpInside];
        [imgV addSubview:btn];
        
        
        MLZhaohuListApi *api = [[MLZhaohuListApi alloc]initWithstatus:@"0" limit:@"10" page:@"1" token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            
            
            CGFloat maxX = 24;
            CGFloat maxY = 94;
            int i = 0;
            int row = 0;
            int col = 0;
            NSArray *arr  = response.data[@"callContents"];
            self.callContents = arr;
            
            for (NSDictionary *dic in arr) {
                NSString *tagStr = dic[@"content"];
                CGSize size = [tagStr sizeWithFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] maxSize:CGSizeMake(200, 24)];
                size.width += 30;
                UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(maxX, maxY + row * (18 + 24), size.width, 24)];
                label.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                if (i == 0) {
                    self.laNameV = label;
//                    label.backgroundColor = [UIColor colorWithHexString:@"#DBCFFF"];
//                    label.backgroundColor = kZhuColor;
                    [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                } else {
                    
                    [label setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                    
                }
                [label addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                if (CGRectGetMaxX(label.frame) >= (imgV.width-48)) {
                    maxX = 24;
                    col = 0;
                    row += 1;
                    if (row >= 3) {
                        break;
                    }
                }
                label.frame = CGRectMake(maxX, maxY + row * (6 + 24), size.width, 24);
                
                if (CGRectGetMaxX(label.frame) < (imgV.width-48)) {
                    col += 1;
                }
                
                label.tag = i;
                [label setTitle:tagStr forState:UIControlStateNormal];
                label.titleLabel.textAlignment = NSTextAlignmentCenter;
                label.layer.cornerRadius = 12;
                label.layer.masksToBounds = YES;
                label.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
                [imgV addSubview:label];
                maxX = CGRectGetMaxX(label.frame) + 12;
                
                if (i == (arr.count-1)) {
                    maxY = CGRectGetMaxY(label.frame);
                }
                
                i++;
                
            }
            
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}
- (void)timePress{
    
    _seconds--;
    if (_seconds > 0) {
        self.button_recommended_40.selected = YES;
        //修改按钮显示时间
        NSLog(@"asdfasdf===%d", _seconds);
        
            NSString *str  = [NSString stringWithFormat:@"0%d:0%d后使用", _seconds / 60, _seconds % 60];
        if (_seconds % 60 >= 10) {
            str  = [NSString stringWithFormat:@"0%d:%d后使用", _seconds / 60, _seconds % 60];
            
        }
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        self.recommendExpireLabel.attributedText = string2;
        
        
        
    } else {
        self.button_recommended_40.selected = NO;
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"10%@", Localized(@"分钟/次", nil)] attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName: [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]}];
        self.recommendExpireLabel.attributedText = string2;
        
        //关闭定时器
         [_countDownTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)tagBtnClick:(UIButton *)btn
{
    
//    self.laNameV.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.laNameV setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
//    btn.backgroundColor = kZhuColor;
//    btn.backgroundColor = [UIColor colorWithHexString:@"#DBCFFF"];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.laNameV = btn;
    
}

- (void)chaView3:(UIButton *)btn
{
    if (btn.tag == 11) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"behavior"];
    }
    [btn.superview.superview removeFromSuperview];
    
    if (btn.tag == 1) {
        
        NSDictionary *dic = self.callContents[self.laNameV.tag];
        
        
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"contentId" : dic[@"id"]} urlStr:@"host/sayHelloAccost"];
        
         [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
             if ([response.data[@"sayCode"] intValue] == 1) {
                 
                 [self um_oneTouchChatWithUserId:[NSString stringWithFormat:@"%@", dic[@"id"]]];
             } else {
                 kplaceToast(response.data[@"msg"]?:@"搭讪失败");
             }
             
        } error:^(MLNetworkResponse *response) {
            
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}


- (void)um_oneTouchChatWithUserId:(NSString *)userId { 
      NSDictionary *eventParams = @{@"Um_Key_PageName":@"一键搭讪",
                                    @"Um_Key_UserID":userId,
                                    @"Um_Key_Type":@"1"
                                  };

//    [MobClick beginEvent:@"5122" primarykey:@"oneTouchChat" attributes:eventParams];
}


-(void)onekeyzhaohu{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    self.maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.maskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    kSelf;
    self.oneZhaohuView = [MLHomeOneZhaohuView alterVietextview:@"" namestr:@"" StrblocksureBtClcik:^{
  
        UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        userData.isHello = YES;
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = userData;
        [weakself.oneZhaohuView removeFromSuperview];
    } cancelClick:^{
        [weakself.oneZhaohuView removeFromSuperview];
    }];
//     [self.maskView addSubview:self.oneZhaohuView];
     [window addSubview:self.oneZhaohuView];
}


-(void)onlineView{
    MLHomeOnlineBottomView *onlinebottomview = [[MLHomeOnlineBottomView alloc]init];
    [onlinebottomview setSure_block:^{
        MLHomeOnlineViewController *vc = [[MLHomeOnlineViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:onlinebottomview];
    [onlinebottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-78);
        make.width.mas_equalTo(116);
        make.height.mas_equalTo(32);
    }];
}


-(void)setupnewversionview:(NSDictionary *)dict{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    kSelf;
    self.versionShowView = [MLNewestVersionShowView alterVietextview:dict[@"content"] must:[dict[@"must"] boolValue] namestr:[NSString stringWithFormat:@"V%@%@",dict[@"version"], Localized(@"版本更新通知", nil)] StrblocksureBtClcik:^{

        NSURL *url = [NSURL URLWithString:[dict[@"url"] length]?dict[@"url"]:@"itms-services:///?action=download-manifest&url=https://dahuixiong.oss-cn-shenzhen.aliyuncs.com/data/apk/ios/Info.plist"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//        NSArray *arr = nil;
//        NSString *s =  arr[0];
    } cancelClick:^{

            [weakself.versionShowView removeFromSuperview];

    }];

    [window addSubview:self.versionShowView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOpen = NO;
    self.tegle = 0;
    self.page = 1;
    [self setupUI];
    //[self setML_SHowView];
//    [self ML_setupHeadUI];
    [self giveML_bannerApi];
//    [self giveML_ForyouApi];
//    [self giveML_getTypeHostsApi];
    
    //[self giveML_getRandomHostsOneApi];
    
//    self.ML_homeCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        [weakself giveML_ForyouApi];
//        [weakself giveML_getTypeHostsApi];
//
//    }];
    
    kSelf;
    self.ML_homeCollectionView.mj_header = [Rob_euCHNRefreshGifHeader headerWithRefreshingBlock:^{
        weakself.page = 1;
        [weakself giveML_ForyouApi];
        [weakself giveML_getTypeHostsApi];
    }];
    [self.ML_homeCollectionView.mj_header beginRefreshing];
    
    self.ML_homeCollectionView.mj_footer = [Rob_euCHNRefreshFooter footerWithRefreshingBlock:^{
    
        weakself.page ++;
        
        [weakself giveML_getTypeHostsApi];
    }];
    
    
    [self versionApi];
    
}


-(void)setupUI{

    //1、实例化一个流水布局
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
       //1-1、设置Cell大小
//       flowLayout.itemSize= CGSizeMake((self.view.frame.size.width-21)/2, 180);
//       //1-2、设置四周边距
//       flowLayout.sectionInset = UIEdgeInsetsMake(2, 5, 2, 5);
    
           flowLayout.itemSize= CGSizeMake((self.view.frame.size.width-21)/2, 180);
           //1-2、设置四周边距
           flowLayout.sectionInset = UIEdgeInsetsMake(0, 7, 0, 7);
    flowLayout.minimumInteritemSpacing = 7;
    flowLayout.minimumLineSpacing = 7;
    self.ML_homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
       //3、设置背景为白色
    self.ML_homeCollectionView.backgroundColor = [UIColor clearColor];
       //4、设置数据源代理
    self.ML_homeCollectionView.dataSource = self;
    self.ML_homeCollectionView.delegate = self;
       //添加到视图中
       [self.view addSubview:self.ML_homeCollectionView];
       //注册Cell视图
       [self.ML_homeCollectionView registerClass:[ML_HotCollectionViewCell class] forCellWithReuseIdentifier:ident];
       [self.ML_homeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReusableView"];
        [self.ML_homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
}


#pragma mark headView大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        return CGSizeMake(self.view.frame.size.width, self.ML_webCycleScrollView2.titlesGroup.count?374:324);
    }else{
        return CGSizeMake(0, 0);
    }
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if ([collectionView isEqual:self.ML_homeCollectionView]) {
            UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headReusableView" forIndexPath:indexPath];
           //添加头视图的内容
            for (UIView *view in header.subviews){
                [view removeFromSuperview];
            }
           [self ML_setupHeadUI];
           //头视图添加view
           [header addSubview:self.ML_headVeiw];
           return header;
        }else{
            UICollectionReusableView *headerrr=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"tt" forIndexPath:indexPath];
           return headerrr;
        }
    }
    return nil;
}

-(void)ML_setupHeadUI{
    self.ML_headVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 324)];
    [self.ML_headVeiw addSubview:self.ML_webCycleScrollView];
    [self.ML_webCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(140);
    }];
    [self.ML_headVeiw addSubview:self.ML_webCycleScrollView2];
    [self.ML_webCycleScrollView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.left.right.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(ML_ScreenWidth - 24);
    }];

    UIImageView *foryouImg =[[UIImageView alloc]init];
    foryouImg.image = [UIImage imageNamed:@"icon_weiniyouxuan_20-nor"];
    [self.ML_headVeiw addSubview:foryouImg];
    self.foryouImg = foryouImg;
    [foryouImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_headVeiw.mas_left).mas_offset(7);
        make.top.mas_equalTo((self.broadcasts.count?self.ML_webCycleScrollView2:self.ML_webCycleScrollView).mas_bottom).mas_offset(20);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];

    UIButton *nameLabel = [[UIButton alloc]init];
    [nameLabel setImage:[UIImage imageNamed:@"icon_weiniyouxuan_20-nor"] forState:UIControlStateNormal];
//    nameLabel.text = Localized(@"为你优选", nil);
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:nameLabel.text attributes:@{NSKernAttributeName:@(2)}];
//     NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//     [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameLabel.text length])];
//    nameLabel.attributedText = attributedString;
//     [nameLabel sizeToFit];
    nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    nameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
//    nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick)];
    [nameLabel addGestureRecognizer:tap];
    nameLabel.userInteractionEnabled = YES;
    [self.ML_headVeiw addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(foryouImg.mas_right).mas_offset(4);
        make.centerY.mas_equalTo(foryouImg.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(ML_ScreenWidth);
    }];

    UIImageView *foryouselectImg =[[UIImageView alloc]init];
    foryouselectImg.image = [UIImage imageNamed:@"icon_more"]; // icon_more
    [self.ML_headVeiw addSubview:foryouselectImg];
    [foryouselectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ML_headVeiw.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(foryouImg.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(50);
    }];

    UICollectionViewFlowLayout *headflowLayout = [[UICollectionViewFlowLayout alloc]init];
    //1-1、设置Cell大小
    headflowLayout.itemSize= CGSizeMake((self.view.frame.size.width-40)/3, 83);
    //1-2、设置四周边距
    headflowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 8);
    headflowLayout.minimumInteritemSpacing = 10;
    //headflowLayout.itemSize= CGSizeMake((self.view.frame.size.width-21)/2, 180);
    //1-2、设置四周边距
    //headflowLayout.sectionInset = UIEdgeInsetsMake(0, 7, 0, 7);
   // headflowLayout.minimumInteritemSpacing = 7;

    // 设置滚动的方向
    [headflowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.ML_headCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:headflowLayout];
    //3、设置背景为白色
    self.ML_headCollectionView.backgroundColor = [UIColor whiteColor];

    //self.ML_headCollectionView.alwaysBounceHorizontal = YES;
   // self.ML_headCollectionView.showsVerticalScrollIndicator = NO;
    //4、设置数据源代理
    self.ML_headCollectionView.dataSource = self;
    self.ML_headCollectionView.delegate = self;
    [self.ML_headCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"tt"];
    [self.ML_headCollectionView registerClass:[ML_headCollectionViewCell class] forCellWithReuseIdentifier:ident];
    //添加到视图中
    [self.ML_headVeiw addSubview:self.ML_headCollectionView];
    //注册Cell视图
    [self.ML_headCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_headVeiw.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.ML_headVeiw.mas_right).mas_offset(0);
        make.height.mas_equalTo(83);
        make.top.mas_equalTo(foryouImg.mas_bottom).mas_offset(8);
 }];

    UIImageView *hotyouImg =[[UIImageView alloc]init];
    hotyouImg.image = [UIImage imageNamed:@"icon_renqituijian_20_nor"];
    [self.ML_headVeiw addSubview:hotyouImg];
    [hotyouImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_headVeiw.mas_left).mas_offset(11);
        make.top.mas_equalTo(self.ML_headCollectionView.mas_bottom).mas_offset(24);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(0);
    }];

    UIButton *hotnameLabel = [[UIButton alloc]init];
    hotnameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [hotnameLabel setImage:kGetImage(@"home_tab_official_ popularity") forState:UIControlStateNormal];
//    hotnameLabel.text = Localized(@"人气推荐", nil);
//    NSMutableAttributedString *hotattributedString = [[NSMutableAttributedString alloc] initWithString:hotnameLabel.text attributes:@{NSKernAttributeName:@(2)}];
//     NSMutableParagraphStyle *hotparagraphStyle = [[NSMutableParagraphStyle alloc] init];
//     [hotattributedString addAttribute:NSParagraphStyleAttributeName value:hotparagraphStyle range:NSMakeRange(0, [hotnameLabel.text length])];
//     hotnameLabel.attributedText = hotattributedString;
//    [hotnameLabel sizeToFit];
//    hotnameLabel.textAlignment = NSTextAlignmentCenter;
//    hotnameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
//    hotnameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.ML_headVeiw addSubview:hotnameLabel];
    [hotnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hotyouImg.mas_right).mas_offset(4);
        make.centerY.mas_equalTo(hotyouImg.mas_centerY);
        make.height.mas_equalTo(25);
    }];
}


//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        return self.homearray.count;
    }else{
        return self.foryouArray.count;
    }
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        ML_HotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[ML_HotCollectionViewCell alloc]init];
        }
        cell.dict = self.homearray[indexPath.item];
        return cell;
    }else{
        ML_headCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[ML_headCollectionViewCell alloc]init];
        }
        cell.dict = self.foryouArray[indexPath.item];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"点击次数------");


    if ([collectionView isEqual:self.ML_homeCollectionView]) {
        if ([self.homearray[indexPath.item][@"coverType"] integerValue] == 0) {
            ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
            vc.dict = self.homearray[indexPath.row];
            //ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc] initWithUserId:[NSString stringWithFormat:@"%@", dict[@"userId"]]];
//            ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc] initWithUserId:[NSString stringWithFormat:@"%@", dict[@"userId"]]];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ML_HostVideoViewController *vc = [[ML_HostVideoViewController alloc]init];
            vc.dict = self.homearray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
        if (!self.foryouArray.count) {
            return;
        }
        
        if ([self.foryouArray[indexPath.item][@"coverType"] integerValue] == 0) {
            ML_HostdetailsViewController *vc = [[ML_HostdetailsViewController alloc]init];
            vc.dict = self.foryouArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ML_HostVideoViewController *vc = [[ML_HostVideoViewController alloc]init];
            vc.dict = self.foryouArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}


-(void)tapclick {
    ML_ForyouViewController *vc = [ML_ForyouViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
