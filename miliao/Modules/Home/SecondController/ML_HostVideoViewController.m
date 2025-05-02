//
//  ML_HostVideoViewController.m
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "ML_HostVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Colours/Colours.h>
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import <Masonry/Masonry.h>

#import "ML_XuanAlbumView.h"
#import "MLUserHomeApi.h"
#import "MLFocusApi.h"
#import "SiLiaoBack-Swift.h"
#import "ML_sayHelloApi.h"
@interface ML_HostVideoViewController ()

@property (nonatomic ,strong) AVPlayer * avplayer;
@property (nonatomic ,strong) AVPlayerItem * avplayerItem;
@property (nonatomic ,strong) AVPlayerLayer * playLayer;
@property (nonatomic, strong) SelVideoPlayer *ttplayer;
@property (nonatomic,strong)UIView *videobgview;

@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,strong)UIButton *dashanbtn;
@property (nonatomic,strong)NSDictionary *userdict;
@property (nonatomic,strong)UIButton *sixinbtn;
@property (nonatomic,strong)UIButton *giftbtn;
@property (nonatomic,strong)UIButton *videobtn;
@property (nonatomic,strong)UIButton *focusBtn;
@end

@implementation ML_HostVideoViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [self givehostmessage];
    if (_ttplayer) {
        
        [self.ttplayer _playVideo];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.ttplayer _pauseVideo];
}

-(void)givehostmessage{
    MLUserHomeApi *api = [[MLUserHomeApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] toUserId:_dict[@"userId"]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"获取用户信息列表---%@",response.data);
        self.userdict = response.data[@"user"];
        if ([self.userdict[@"focus"] integerValue] == 0) {//nv
            [self.dashanbtn setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
            self.dashanbtn.backgroundColor = kZhuColor;
        }else{
            [self.dashanbtn setTitle:Localized(@"已关注", nil) forState:UIControlStateNormal];
            self.dashanbtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        }
        [self setupUI];
        [self.view layoutIfNeeded];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * backIV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backIV.image = kGetImage(@"hostVideoBG");
    [self.view addSubview:backIV];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
}

- (void)handleSwipeFrom
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI{

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor_1"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-2"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16*mWidthScale);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(54*mHeightScale);
        make.width.height.mas_equalTo(24*mWidthScale);
    }];
    
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton addTarget:self action:@selector(ML_MoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setImage:kGetImage(@"button_home_page_32") forState:UIControlStateNormal];
//    moreButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
//    moreButton.layer.shadowOffset = CGSizeMake(0, 1);
//    moreButton.layer.shadowOpacity = 1;
//    moreButton.layer.shadowRadius = 4;
    [self.view addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backButton.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.width.mas_equalTo(52*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    
    self.videobgview = [[UIView alloc]init];
    self.videobgview.backgroundColor = UIColor.clearColor;
    self.videobgview.layer.cornerRadius = 16*mWidthScale;
    self.videobgview.layer.masksToBounds = YES;
    [self.view addSubview:_videobgview];
    [self.videobgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(100*mHeightScale);
        make.height.mas_equalTo(598*mHeightScale);
    }];

    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;
    configuration.supportedDoubleTap = YES;
    configuration.shouldAutorotate = YES;
    configuration.repeatPlay = YES;
    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
    configuration.sourceUrl = kGetUrlPath(self.userdict[@"videoPath"]);
     configuration.videoGravity = SelVideoGravityResizeAspectFill;
     self.ttplayer = [[SelVideoPlayer alloc]initWithFrame:self.videobgview.frame configuration:configuration];
    [self.videobgview addSubview:self.ttplayer];
    [self.ttplayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.videobgview);
    }];
 
    
    UIButton *sixinbtn = [[UIButton alloc]init];
    [sixinbtn setBackgroundImage:kGetImage(@"sixin") forState:UIControlStateNormal];
//    sixinbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [sixinbtn addTarget:self action:@selector(sixinbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sixinbtn];
    self.sixinbtn = sixinbtn;
    
    [sixinbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40*mWidthScale);
        make.left.mas_equalTo(303*mWidthScale);
        make.height.mas_equalTo(40*mWidthScale);
        make.top.mas_equalTo(442*mHeightScale);
    }];
    
    UIButton *giftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [giftbtn setBackgroundImage:kGetImage(@"liwu") forState:UIControlStateNormal];

    [giftbtn addTarget:self action:@selector(giftbtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:giftbtn];
    self.giftbtn = giftbtn;
    [self.giftbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40*mWidthScale);
        make.centerX.mas_equalTo(sixinbtn.mas_centerX);
        make.top.mas_equalTo(sixinbtn.mas_bottom).offset(20*mHeightScale);
    }];
    
    self.dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dashanbtn setBackgroundImage:kGetImage(@"dashan") forState:UIControlStateNormal];
    
    [self.dashanbtn addTarget:self action:@selector(dashanClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.dashanbtn.layer.cornerRadius = 16;
    [self.view addSubview:self.dashanbtn];
    [self.dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40*mWidthScale);
        make.centerX.mas_equalTo(giftbtn.mas_centerX);
        make.height.mas_equalTo(40*mWidthScale);
        make.top.mas_equalTo(giftbtn.mas_bottom).offset(20*mHeightScale);
    }];
    
 
    UIButton *videobtn = [[UIButton alloc]init];
    [videobtn addTarget:self action:@selector(videobtnClick) forControlEvents:UIControlEventTouchUpInside];
    [videobtn setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
    [videobtn setTitle:@"与Ta视频" forState:UIControlStateNormal];
    [videobtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    videobtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:videobtn];
    self.videobtn = videobtn;
    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(48*mHeightScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(730*mHeightScale);
    }];
    

    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = _dict[@"name"];
    nameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    nameLabel.textColor = [UIColor colorFromHexString:@"#ffffff"];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32*mWidthScale);
        make.top.mas_equalTo(632*mHeightScale);
        make.height.mas_equalTo(28*mHeightScale);
    }];

    UILabel *persionSign = [[UILabel alloc]init];
    persionSign.text = _dict[@"persionSign"];
    persionSign.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    persionSign.textColor = [UIColor colorFromHexString:@"#a9a9ab"];
    [self.view addSubview:persionSign];
    [persionSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32*mWidthScale);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(18*mHeightScale);
    }];
    
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusBtn setBackgroundImage:[UIImage imageNamed:@"Cfollow_NO"] forState:UIControlStateNormal];
    [focusBtn setBackgroundImage:[UIImage imageNamed:@"canclefollow"] forState:UIControlStateSelected];
    [focusBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:focusBtn];
    self.focusBtn = focusBtn;
    self.focusBtn.selected = [self.userdict[@"focus"] boolValue];
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(279*mWidthScale);
        make.top.mas_equalTo(641*mHeightScale);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(68);
    }];
    
    
    
    
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#B8AFA2"];

    [self.view layoutIfNeeded];
}


-(void)viewDidLayoutSubviews{

    self.selectImg.layer.cornerRadius = self.selectImg.frame.size.width / 2;
    self.selectImg.layer.masksToBounds = YES;
    self.selectImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.selectImg layoutIfNeeded];
    
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host integerValue] == [self.userdict[@"host"] integerValue]) {
        self.dashanbtn.hidden = YES;
        self.sixinbtn.hidden = YES;
        self.giftbtn.hidden = YES;
        self.videobtn.hidden = YES;

    }else{
        self.dashanbtn.hidden = NO;
        self.sixinbtn.hidden = NO;
        self.giftbtn.hidden = NO;
        self.videobtn.hidden = NO;

    }
    [self.selectImg layoutIfNeeded];
    [self.view layoutIfNeeded];
}


- (void)dashanClick:(UIButton *)btn{
//    [SVProgressHUD show];
    kSelf;
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_sayHelloApi *api = [[ML_sayHelloApi alloc] initWithtoken:token toUserId:_dict[@"userId"] extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"打招呼%@",response.data);
        kplaceToast(Localized(@"打招呼成功,可以给好友私信啦", nil));
        [SVProgressHUD dismiss];
        
//        btn.selected = !btn.selected;
//        [btn removeFromSuperview];
        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


-(void)checkAction{
    NSLog(Localized(@"关注", nil));
    if ([self.userdict[@"focus"] integerValue] == 0) {
        [self giveMLFocusApi:@"1" toUserId:_dict[@"userId"]];
        [self.userdict setValue:@"1" forKey:@"focus"];
        self.focusBtn.selected = YES;
    }else{
        [self giveMLFocusApi:@"0" toUserId:_dict[@"userId"]];
        [self.userdict setValue:@"0" forKey:@"focus"];
//        self.dashanbtn.backgroundColor = kZhuColor;
//        [self.dashanbtn setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
        self.focusBtn.selected = NO;
    }
}

#pragma mark -----关注------
-(void)giveMLFocusApi:(NSString *)indexstr toUserId:(NSString *)touserId{
    MLFocusApi *api = [[MLFocusApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] toUserId:touserId type:indexstr];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"关注接口----%@",response.data);
        //[self.tablview reloadData];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}


- (void)ML_MoreButtonClick
{
    [self gotoInfoVC:self.dict[@"userId"]];
    return;
    NSArray<PopItemModel *> *Items = [PopItemModel toInfoController];
    kSelf;
    [ML_XuanAlbumView popItems:Items action:^(NSInteger index) {
   
        [weakself ML_InfoPopAction:index pDic:@{@"userId" : [NSString stringWithFormat:@"%@", weakself.dict[@"userId"]], @"dongId" : [NSString stringWithFormat:@"%@", weakself.dict[@"id"]], @"block" : @"0", @"showInfo" : @"1"}];
    }];
        
    

    
}

- (void)sixinbtnClick
{
    [self gotoChatVC:[NSString stringWithFormat:@"%@", self.dict[@"userId"]]];
}
- (void)giftbtnClick
{
    [self presentGiftByUserId:[self.dict[@"userId"] intValue]];
}
- (void)videobtnClick
{
    
    [self gotoCallVCWithUserId:[NSString stringWithFormat:@"%@", self.dict[@"userId"]] isCalled:NO];
}


- (void)imageViewAddTap:(UIGestureRecognizer *)gr
{
    NSString *userId = [NSString stringWithFormat:@"%@", self.dict[@"userId"]];
    [self gotoInfoVC:userId];
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
