//
//  MLMineDynameDeatViewController.m
//  miliao
//
//  Created by apple on 2022/10/18.
//

#import "MLMineDynameDeatViewController.h"
#import "MLSaveRealAuditInfoApi.h"
#import "MLFaceRenResultViewController.h"
#import "ML_RequestManager.h"
#import "UIViewController+MLHud.h"
#import "MLRenzhengWebViewController.h"
#import "MLMineDynamelistCollectionViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "MLDeletDynameView.h"
#import "MLDelDynamicApi.h"
#import "UIViewController+MLHud.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import <AVFoundation/AVFoundation.h>

@interface MLMineDynameDeatViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic,copy)NSString *namestr;
@property (nonatomic,copy)NSString *idcardestr;

@property (nonatomic,strong)UICollectionView *ML_headCollectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *headflowLayout;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSArray *nmarray;
// 网络图片
@property (nonatomic, strong) SDCycleScrollView * ML_webCycleScrollView;
@property (nonatomic,strong)UIButton *dashanbtn;
@property (nonatomic,strong)UILabel *tuiguangtitle;
@property (nonatomic,strong)UIView *NmaskView;
@property (nonatomic,strong)MLDeletDynameView *deletDynameView;
@property (nonatomic,strong)UIView *videoimgBgview;

@property (nonatomic ,strong) AVPlayer * avplayer;
@property (nonatomic ,strong) AVPlayerItem * avplayerItem;
@property (nonatomic ,strong) AVPlayerLayer * playLayer;
@property (nonatomic, strong) SelVideoPlayer *ttplayer;
@property (nonatomic,assign)NSInteger likeindex;
@property (nonatomic,assign)NSInteger likecount;
@property (nonatomic,assign)NSInteger locatcount;


@end

@implementation MLMineDynameDeatViewController


-(NSArray *)nmarray{
    if (_nmarray == nil) {
        _nmarray = [NSArray array];
    }
    return _nmarray;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.ML_navView.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      
}

#pragma mark 轮播
- (SDCycleScrollView *)ML_webCycleScrollView{
    if (!_ML_webCycleScrollView){
        self.ML_webCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        self.ML_webCycleScrollView.backgroundColor = UIColor.blackColor;
        self.ML_webCycleScrollView.delegate = self;
        self.ML_webCycleScrollView.autoScroll = NO;
        self.ML_webCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        self.ML_webCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _ML_webCycleScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_navView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [self.dict[@"url"] enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
        NSString *ss = [NSString stringWithFormat:@"%@%@",basess,url];
        [self.dataArray addObject:ss];
    }];
    UILabel *tuiguangtitle = [[UILabel alloc]init];
    tuiguangtitle.text = [NSString stringWithFormat:@"%d/%lu", 1,(unsigned long)self.dataArray.count];
    tuiguangtitle.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    tuiguangtitle.textColor = [UIColor colorWithHexString:@"#ffffff"];
    tuiguangtitle.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:tuiguangtitle];
    self.tuiguangtitle = tuiguangtitle;
    [tuiguangtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight - 20);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-2"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(tuiguangtitle.mas_centerY);
    }];
    
    UIButton *rigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rigthBtn addTarget:self action:@selector(rightclick) forControlEvents:UIControlEventTouchUpInside];
    [rigthBtn setImage:[UIImage imageNamed:@"icon_fenxiang_24_FFF_nor"] forState:UIControlStateNormal];
    if (!self.userId) {
        rigthBtn.hidden = NO;
    }else{
        rigthBtn.hidden = YES;
     }
    [self.view addSubview:rigthBtn];
    [rigthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(tuiguangtitle.mas_centerY);
    }];
    
    UIView *bgview = [[UIView alloc]init];
    bgview.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    [self.view addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-34);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = self.dict[@"title"];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.bottom.mas_equalTo(bgview.mas_top).mas_offset(-12);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *timerLabel = [[UILabel alloc]init];
    timerLabel.text = self.dict[@"aduitTime"];
    timerLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    timerLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    timerLabel.numberOfLines = 0;
    [bgview addSubview:timerLabel];
    [timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgview.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(bgview.mas_centerY);
    }];

    self.dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dashanbtn setTitle:[NSString stringWithFormat:@"%@",self.dict[@"likeCount"]] forState:UIControlStateNormal];
    [self.dashanbtn setImage:[UIImage imageNamed:@"icon_dianzan_22_999_nor"] forState:UIControlStateNormal];
    [self.dashanbtn setImage:[UIImage imageNamed:@"icon_dianzan_22_999_sel"] forState:UIControlStateSelected];
    if ([_dict[@"like"] integerValue] == 0) {
        self.dashanbtn.selected = NO;
    }else{
        self.dashanbtn.selected = YES;
    }
    [self.dashanbtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.dashanbtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.dashanbtn.imageEdgeInsets = UIEdgeInsetsMake(0,-2, 0, 2);
    self.dashanbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [self.dashanbtn addTarget:self action:@selector(dashanClickbtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:self.dashanbtn];
    [self.dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.right.mas_equalTo(bgview.mas_right).mas_offset(-16);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(bgview.mas_centerY);
    }];
    
    self.videoimgBgview = [[UIView alloc]init];
    self.videoimgBgview.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:self.videoimgBgview];
    [self.videoimgBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(tuiguangtitle.mas_bottom).mas_offset(22);
        make.bottom.mas_equalTo(titleLabel.mas_top).mas_offset(-30);
    }];

//    [self.view addSubview:self.ML_webCycleScrollView];
//    [self.ML_webCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.top.mas_equalTo(tuiguangtitle.mas_bottom).mas_offset(22);
//        make.bottom.mas_equalTo(titleLabel.mas_top).mas_offset(-30);
//    }];

    if (titleLabel.text.length > 70) {
        [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
            make.bottom.mas_equalTo(bgview.mas_top).mas_offset(-12);
            make.height.mas_equalTo(120);
        }];
    }

    if ([self.dict[@"type"] integerValue] == 0) {
       [self.videoimgBgview addSubview:self.ML_webCycleScrollView];
        self.ML_webCycleScrollView.imageURLStringsGroup = self.dataArray;
        [self.ML_webCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.videoimgBgview);
        }];
    }else{
        SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
        configuration.shouldAutoPlay = YES;
        configuration.supportedDoubleTap = YES;
        configuration.shouldAutorotate = YES;
        configuration.repeatPlay = NO;
        configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
         NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
    //     NSString *ss = [NSString stringWithFormat:@"%@%@",basess,self.dict[@"cover"]];
    //    configuration.sourceUrl = [NSURL URLWithString:ss];
        configuration.sourceUrl = kGetUrlPath(self.dict[@"url"][0]);
         configuration.videoGravity = SelVideoGravityResizeAspect;
         self.ttplayer = [[SelVideoPlayer alloc]initWithFrame:self.videoimgBgview.frame configuration:configuration];
        [self.videoimgBgview addSubview:self.ttplayer];
        [self.ttplayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(self.videoimgBgview);
        }];
    }
    
    self.likeindex = [self.dict[@"like"] integerValue];
    self.likecount = [self.dict[@"likeCount"] integerValue];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
      return UIStatusBarStyleLightContent;
}

-(void)backclick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightclick{
    NSLog(@"右边弹框");
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.NmaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.NmaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    self.deletDynameView = [MLDeletDynameView alterViewWithTitle:@"" content:@"" sure:@"" address:@"" name:@"" phone:@"" timer:@"" sureBtClcik:^{
        [self.NmaskView removeFromSuperview];
        MLDelDynamicApi *api = [[MLDelDynamicApi alloc]initWithtotoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token dynamicId:[NSString stringWithFormat:@"%@",self.dict[@"id"]] extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            //NSLog(@"删除动态----%@",response.data);
            if ([response.status integerValue] == 0) {
                [self showMessage:@"删除动态成功"];
            }
            [self.navigationController popViewControllerAnimated:YES];
            } error:^(MLNetworkResponse *response) {
            } failure:^(NSError *error) {
            }];
    } cancelClick:^{
        [self.NmaskView removeFromSuperview];
    }];

     [self.NmaskView addSubview:self.deletDynameView];
     [window addSubview:self.NmaskView];
  }

-(void)dashanClickbtn:(UIButton *)btn{
    if (self.likeindex == 0) {
        self.likeindex = 1;
        self.likecount += 1;
    }else{
        self.likeindex = 0;
        self.likecount -= 1;
    }
    self.locatcount = self.likecount;
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"dynamicId" : self.dict[@"id"], @"like" :[NSString stringWithFormat:@"%ld",(long)self.likeindex] } urlStr:@"/dynamic/likeDynamic"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (self.locatcount > 1000000) {
                [self.dashanbtn setTitle:@"100W+" forState:UIControlStateSelected];
            }else{
                [self.dashanbtn setTitle:[NSString stringWithFormat:@"%ld",self.locatcount] forState:UIControlStateSelected];
            }
        } else {
            if (self.locatcount > 1000000) {
                [self.dashanbtn setTitle:@"100W+" forState:UIControlStateNormal];
            }else{
                [self.dashanbtn setTitle:[NSString stringWithFormat:@"%ld",self.locatcount] forState:UIControlStateNormal];
            }
        }
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
    
    
    
    
}


// 点击图片代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    // 清理缓存
    [SDCycleScrollView clearImagesCache];
}

// 滚动到第几张图片的回调
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.tuiguangtitle.text = [NSString stringWithFormat:@"%ld/%lu",index + 1,(unsigned long)self.dataArray.count];
}





@end
