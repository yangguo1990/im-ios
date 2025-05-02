//
//  MLMineViewController.m
//  miliao
//
//  Created by apple on 2022/8/17.
//

#import "MLMineViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "ML_MineTableViewCell.h"
#import <Colours/Colours.h>
#import "ML_MineCollectionViewCell.h"
#import "ML_SettingViewController.h"
#import "ML_BlackViewController.h"
#import "ML_GetUserInfoApi.h"
#import "ML_MineFocusViewController.h"
#import "ML_MineFriendViewController.h"
#import "ML_MineEditViewController.h"
#import "ML_HelpViewController.h"
#import "ML_BlackViewController.h"
#import "MLFabuDynamicViewController.h"
#import "MLTuijiangiftViewController.h"
#import "MLKaitongViewController.h"
#import "MLMineFaceViewController.h"
#import "UIColor+MLGradient.h"
#import "ML_ChongVC.h"
#import "BRPickerView.h"
#import "FUManager.h"
#import "FULiveModel.h"
#import "FUBeautyController.h"
#import "MLZhaohuSettingViewController.h"
#import "UIViewController+MLHud.h"
#import "MLGetUserSimpleInfoApi.h"
#import "ML_RequestManager.h"
#import "ML_SetChargeApi.h"
#import "ML_GetChargeApi.h"
#import "ML_SettingtitleTableViewCell.h"
#import "ML_GonghuiVC.h"
#import "ML_GonghuitongjiVC.h"
#import "UIImage+ML.h"
#import "ML_CommonApi2.h"
#import "WKWebViewController.h"

#import "SiLiaoBack-Swift.h"
#import "ML_MineBottomCollectionViewCell.h"
#import "ML_MineBottomFlowLayout.h"
#import "MLMineDynameicViewController.h"
@interface MLMineViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UITextField *accountfield;
@property (nonatomic,strong)UITextField *passwordfield;
@property (nonatomic,strong)UITextField *passwordcode;
@property (nonatomic,strong)UIButton *codebtn;
@property (nonatomic,copy)NSString *codeuuid;
@property (nonatomic,strong)UIView *headview;
@property (nonatomic,strong)UIView *footview;
@property (nonatomic,strong)UILabel *huiyuanLabel;
@property (nonatomic,strong)UIButton *kaitongBT;
@property (nonatomic,strong)UIView *videobgview;

@property (nonatomic,strong)UIView *footbgview;
@property (nonatomic,strong)NSDictionary *getUserSimpleInfo;
@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,retain) UIButton *beginTestBtn;
@property (nonatomic,retain) UILabel *textLabel;
@property (nonatomic,strong)UICollectionView *ML_homeCollectionView;

@property (nonatomic,strong)NSArray *ML_celltitleArray;
@property (nonatomic,strong)NSArray *ML_cellimgArray;

@property (nonatomic,strong)NSArray *ML_itemtitleArray;


@property (nonatomic,copy)NSString *chargelabel;
@property (nonatomic,strong)NSMutableArray *dataid;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UIImageView *headbgview;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *idnameLabel;
@property (nonatomic,strong)UILabel *slognameLabel;
@property (nonatomic,strong)NSDictionary *hostdict;
@property (nonatomic, copy) NSString* kfUrl;              // 客服链接


@property (nonatomic,strong)UILabel *likeNo;
@property (nonatomic,strong)UILabel *fansNo;
@property (nonatomic,strong)UILabel *fangkeNo;
@property (nonatomic,strong)UILabel *levelNo;
@end

@implementation MLMineViewController

-(NSMutableArray *)dataid{
    if (_dataid == nil) {
        _dataid = [NSMutableArray array];
    }
    return _dataid;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(NSArray *)ML_celltitleArray{
    if (_ML_celltitleArray == nil) {

        
            if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) {
                if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.hostAudit integerValue] == 1) {
                    _ML_celltitleArray = @[Localized(@"勿扰模式", nil),Localized(@"邀请奖励", nil),Localized(@"招呼设置", nil), Localized(@"通话价格", nil),Localized(@"美颜参数", nil),Localized(@"系统设置", nil)];
                    _ML_cellimgArray = @[@"wurao",@"icon_yaoqingjiangli_24_nor",@"icon_zhaohushezhi_24_nor", @"1681673428373", @"1691673428378",@"icon-systemSet"];
                }else{
                    _ML_celltitleArray = @[Localized(@"勿扰模式", nil),Localized(@"邀请奖励", nil),Localized(@"招呼设置", nil),Localized(@"通话价格", nil),Localized(@"美颜参数", nil),Localized(@"系统设置", nil)];
                    _ML_cellimgArray = @[@"wurao",@"icon_yaoqingjiangli_24_nor",@"icon_zhaohushezhi_24_nor", @"1681673428373", @"1691673428378",@"icon-systemSet"];
                }
            }else{
                _ML_celltitleArray = @[Localized(@"勿扰模式", nil),Localized(@"邀请奖励", nil),Localized(@"美颜参数", nil),Localized(@"系统设置", nil)];
                _ML_cellimgArray = @[@"wurao",@"icon_yaoqingjiangli_24_nor", @"1691673428378",@"icon-systemSet"];
            }


    }
    return _ML_celltitleArray;
}



-(NSArray *)ML_itemtitleArray{
    if (_ML_itemtitleArray == nil) {
        _ML_itemtitleArray = @[Localized(@"我的喜欢", nil),Localized(@"我的访客", nil),Localized(@"我的动态", nil)];
    }
    return _ML_itemtitleArray;
}


-(UIView *)footview{
    if (_footview == nil) {
        _footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        //_footview.backgroundColor = [UIColor redColor];
    }
    return _footview;
}

-(UIView *)headview{
    if (_headview == nil) {
        _headview = [[UIView alloc]init];
        _headview.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 288+48);
    }
    return _headview;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
    self.ML_celltitleArray = nil;
    self.ML_cellimgArray = nil;
 }
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   

    
    [self giveMLGetUserSimpleInfoApi];
    [self ML_celltitleArray];
    [self ML_cellimgArray];
    
    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

    self.chargelabel = [NSString stringWithFormat:@"%@", currentData.charge];
    
    [self.headbgview sd_setImageWithURL:kGetUrlPath(currentData.icon) placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
    self.nameLabel.text = currentData.name;
    if (![currentData.persionSign length]) {
        self.slognameLabel.text = Localized(@"你还没有设置签名哦~", nil);
    }else{
        self.slognameLabel.text = currentData.persionSign;
    }
    self.idnameLabel.text = [NSString stringWithFormat:@"ID:%@", currentData.userId];
    [self.tableview reloadData];
    [self.headview layoutIfNeeded];

    [self giveML_GetUserInfoApi];

 }


-(void)giveMLGetUserSimpleInfoApi{
    NSDictionary *dict = @{
        @"token":[ML_AppUserInfoManager sharedManager].currentLoginUserData.token,
    };
    kSelf;
     [ML_RequestManager requestPath:@"user/getUserSimpleInfo" parameters:dict doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
         weakself.hostdict = responseObject[@"data"][@"user"];
         
         NSLog(@"%@",responseObject);
         
         UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;

         currentData.icon = [weakself.hostdict[@"icon"] isEqual:[NSNull null]]?@"":weakself.hostdict[@"icon"];
         currentData.name = [weakself.hostdict[@"name"] isEqual:[NSNull null]]?@"":weakself.hostdict[@"name"];
         currentData.persionSign = [weakself.hostdict[@"persionSign"] isEqual:[NSNull null]]?@"":weakself.hostdict[@"persionSign"];
         currentData.verified = [NSString stringWithFormat:@"%@", weakself.hostdict[@"verified"]];
         currentData.host = [NSString stringWithFormat:@"%@", weakself.hostdict[@"host"]];
         currentData.guildCode = [NSString stringWithFormat:@"%@", weakself.hostdict[@"guildCode"]];
         
         [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
         
         [weakself.headbgview sd_setImageWithURL:kGetUrlPath(currentData.icon) placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
         weakself.nameLabel.text = currentData.name;
         if (![currentData.persionSign length]) {
             weakself.slognameLabel.text = Localized(@"你还没有设置签名哦~", nil);
         }else{
             weakself.slognameLabel.text = currentData.persionSign;
         }
         weakself.fangkeNo.text = [NSString stringWithFormat:@"%@",weakself.hostdict[@"accessLogNum"]];
         [weakself.ML_homeCollectionView reloadData];
         [weakself.tableview reloadData];
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor  =  [UIColor colorWithRed:244/255.0f green:244/255.0f  blue:244/255.0f  alpha:1];
    self.ML_titleLabel.text = nil;

    self.ML_navView.backgroundColor = [UIColor clearColor];
//    [self ML_addNavRightBtnWithTitle:nil image:kGetImage(@"icon_shezhi_22_000_nor")]; //
//    
//   UIButton *rightCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 100, ML_NavViewHeight - 44, 40, 44)];
//   rightCustomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//   [rightCustomButton addTarget:self action:@selector(setnetClick) forControlEvents:UIControlEventTouchUpInside];
//   rightCustomButton.titleLabel.font = kGetFont(14);
//   [rightCustomButton setImage:[UIImage imageNamed:@"icon_bianji_22_000_nor"] forState:UIControlStateNormal];
//   rightCustomButton.contentMode = UIViewContentModeRight;
//   [self.ML_navView addSubview:rightCustomButton];
    
    
//   UIButton *rightCustomButton2 = [[UIButton alloc] initWithFrame:CGRectMake(ML_ScreenWidth - 140, ML_NavViewHeight - 44, 40, 44)];
//    rightCustomButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//   [rightCustomButton2 addTarget:self action:@selector(setnetClickkefu) forControlEvents:UIControlEventTouchUpInside];
//    rightCustomButton2.titleLabel.font = kGetFont(14);
//   [rightCustomButton2 setImage:[UIImage imageNamed:@"icon_kefu_22_000_nor"] forState:UIControlStateNormal];
//    rightCustomButton2.contentMode = UIViewContentModeRight;
//   [self.ML_navView addSubview:rightCustomButton2];
//    
//    UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 276*mHeightScale)];
//    [bgV setImage:[UIImage imageNamed:@"my_background"]];
//    [self.view addSubview:bgV];
    
    
    //[self setupUI]; my_background
   
    [self setupMineUI];
    [self setCollectionView];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) {
        [self giveML_GetChargeApi];
    }

}

- (void)setnetClickkefu
{
    [self gotoChatVC:@"100000"];
}

- (void)gotoChatVC:(NSString *)userId{
    kSelf;
    NSInteger type = [self.hostdict[@"curCustomerType"] intValue];
    if (type == 0) {
        IMChatVC *chatvc = [[IMChatVC alloc]initWithUserId:userId.integerValue];

        [self.navigationController pushViewController:chatvc animated:YES];
    }else {
        if (self.kfUrl && self.kfUrl.length) {
            [self gotoChatWebVC:self.kfUrl];
        } else {
            [[[ML_CommonApi2 alloc] initWithPDic:@{} urlStr:@"/base/getCustomUrl"] networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                    NSDictionary *data = response.data;
                    NSString *url = data[@"url"];
                weakself.kfUrl = url;
                    [weakself gotoChatWebVC:url];
                } error:^(MLNetworkResponse *response) {
                    kplaceToast(@"请求错误，请稍后重试");
                } failure:^(NSError *error) {
                    kplaceToast(@"请求错误，请稍后重试");
                }];
            
        }
    }
}

- (void)gotoChatWebVC:(NSString *)url{
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    vc.Rob_euCvar_Url = url;
    [self.navigationController pushViewController:vc animated:YES];
}

//获取价格列表--
-(void)giveML_GetChargeApi{
    ML_GetChargeApi *api = [[ML_GetChargeApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        NSLog(@"heheh-----%@",[ML_AppUserInfoManager sharedManager].currentLoginUserData.charge);
        [response.data[@"charges"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.data addObject:[NSString stringWithFormat:@"%@",dict[@"charge"]]];
            [self.dataid addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
            
        }];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}
-(void)giveML_GetUserInfoApi{
        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
  
    NSLog(@"asdfasdf===%@", kGetUrlPath(currentData.icon));
        [self.headbgview sd_setImageWithURL:kGetUrlPath(currentData.icon) placeholderImage:[UIImage imageNamed:@"Ellipse 24"]];
        self.nameLabel.text = currentData.name;
        if (![currentData.persionSign length]) {
            self.slognameLabel.text = Localized(@"你还没有设置签名哦~", nil);
        }else{
            self.slognameLabel.text = currentData.persionSign;
        }

        [self.tableview reloadData];

}


-(void)setupMineUI{
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
            statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    [self addheadview];
}

- (void)headbgviewTap
{
    ML_MineEditViewController *vc = [[ML_MineEditViewController alloc]init];
    vc.typevideo = @"更新资料";
    [self.navigationController pushViewController:vc animated:YES];
}

//添加headview---
-(void)addheadview{
    UIImageView *headimg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 266*mHeightScale)];
    headimg.image = kGetImage(@"my_background");
    
    headimg.userInteractionEnabled = YES;
    [self.view addSubview:headimg];
    
    //mineheadbg
    UIImageView *nameIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [headimg addSubview:nameIV];
    [nameIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(56*mHeightScale);
        make.width.mas_equalTo(60*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    nameIV.image = kGetImage(@"myIcon");
    
    
    
    UIImageView *headbgview = [[UIImageView alloc] init];
    headbgview.userInteractionEnabled = YES;
    headbgview.contentMode = UIViewContentModeScaleAspectFill;
    headbgview.layer.cornerRadius = 40*mWidthScale;
    headbgview.layer.masksToBounds = YES;
    [headimg addSubview:headbgview];
    [headbgview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headbgviewTap)]];
    self.headbgview = headbgview;
    [headbgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headimg.mas_left).mas_offset(261*mWidthScale);
        make.top.mas_equalTo(headimg.mas_top).mas_offset(100*mHeightScale);
        make.height.width.mas_equalTo(80*mWidthScale);
    }];
    
    UIButton *editeBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [editeBt setBackgroundImage:kGetImage(@"buttonBG1") forState:UIControlStateNormal];
    [editeBt addTarget:self action:@selector(headbgviewTap) forControlEvents:UIControlEventTouchUpInside];
    [editeBt setTitle:@"编辑主页" forState:UIControlStateNormal];
    [editeBt setTitleColor:kGetColor(@"ffffff") forState:UIControlStateNormal];
    editeBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [headimg addSubview:editeBt];
    [editeBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(headbgview);
        make.height.mas_equalTo(24*mHeightScale);
    }];
    
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#000000"];
    [headimg addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(104*mHeightScale);
        make.height.mas_equalTo(28*mHeightScale);
    }];
    
    UIImageView *sexIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [headimg addSubview:sexIV];
    [sexIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.left.mas_equalTo(nameLabel.mas_right).offset(5);
        make.width.height.mas_equalTo(16*mWidthScale);
    }];
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender isEqualToString:@"1"]) {
        sexIV.image = kGetImage(@"male");
    }else{
        sexIV.image = kGetImage(@"female");
    }
    
    UIImageView *levelIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [headimg addSubview:levelIV];
    [levelIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sexIV.mas_centerY);
        make.left.mas_equalTo(sexIV.mas_right).offset(5);
        make.width.mas_equalTo(56*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    
    NSInteger level = [[ML_AppUserInfoManager sharedManager].currentLoginUserData.identity integerValue];
    
    if (level == 0) {
        levelIV.hidden = YES;
    }else{
        levelIV.hidden = NO;
        switch (level) {
            case 10:
                levelIV.image = kGetImage(@"baiyingIcon");
                break;
            case 20:
                levelIV.image = kGetImage(@"huangjinIcon");
                break;
            case 30:
                levelIV.image = kGetImage(@"zuanshiIcon");
                break;
            default:
                break;
        }
    }
    
    
    UILabel *idnameLabel = [[UILabel alloc]init];
    idnameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    idnameLabel.textColor = [UIColor colorFromHexString:@"##FF999999"];
    [headimg addSubview:idnameLabel];
    self.idnameLabel = idnameLabel;
    [idnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(6);
    }];

    UIImageView *bookimg = [[UIImageView alloc]init];
    bookimg.image = [UIImage imageNamed:@"icon_fuzhi_16_000_nor_1"];
    bookimg.userInteractionEnabled = YES;
    UITapGestureRecognizer *booktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bookClick)];
    [bookimg addGestureRecognizer:booktap];
    [headimg addSubview:bookimg];
    [bookimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(idnameLabel.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(idnameLabel.mas_centerY);
        make.height.mas_equalTo(16*mHeightScale);
        make.width.mas_equalTo(16*mWidthScale);
    }];

    UILabel *slognameLabel = [[UILabel alloc]init];
    slognameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    slognameLabel.textColor = [UIColor colorFromHexString:@"##FF999999"];
    [headimg addSubview:slognameLabel];
    self.slognameLabel = slognameLabel;
    [slognameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(headbgview.mas_left).mas_offset(-20);
        make.top.mas_equalTo(idnameLabel.mas_bottom).mas_offset(6);
    }];
    
    UIView * topMiddleView = [[UIView alloc]initWithFrame:CGRectZero];
    [headimg addSubview:topMiddleView];
    topMiddleView.layer.cornerRadius = 12*mHeightScale;
    topMiddleView.layer.masksToBounds = YES;
    topMiddleView.backgroundColor = UIColor.whiteColor;
    [topMiddleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headimg.mas_centerX);
        make.top.mas_equalTo(slognameLabel.mas_bottom).offset(10*mHeightScale);
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(64*mHeightScale);
    }];
    NSInteger ismale = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender.integerValue;
    for (int i=0; i<3; i++) {
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectZero];
        label1.textColor = kGetColor(@"ff63c2");
        label1.font = [UIFont systemFontOfSize:16];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.userInteractionEnabled = YES;
        
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectZero];
        label2.textColor = kGetColor(@"8c8c8c");
        label2.font = [UIFont systemFontOfSize:10];
        label2.textAlignment = NSTextAlignmentCenter;
        
        switch (i) {
            case 0:
            {
                label2.text = @"我的喜欢";
                self.likeNo = label1;
                self.likeNo.text = [ML_AppUserInfoManager sharedManager].currentLoginUserData.focusNum;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guanzhuFans)];
                [label1 addGestureRecognizer:tap];
            }
                break;
            case 1:
            {
                label2.text = @"我的粉丝";
                self.fansNo = label1;
                self.fansNo.text = [ML_AppUserInfoManager sharedManager].currentLoginUserData.fansNum;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guanzhuFans)];
                [label1 addGestureRecognizer:tap];
            }
                break;
            case 2:
            {
                label2.text = @"我的访客";
                self.fangkeNo = label1;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wodeFangke)];
                [label1 addGestureRecognizer:tap];
            }
                break;
                
            default:
                break;
        }
        
        [topMiddleView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(115*mWidthScale);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(42*mHeightScale);
            make.left.mas_equalTo(115*mWidthScale*i);
        }];
        
        [topMiddleView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(115*mWidthScale);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(26*mHeightScale);
            make.left.mas_equalTo(115*mWidthScale*i);
        }];
    }
    
}


- (void)guanzhuFans{
    ML_MineFocusViewController *vc = [[ML_MineFocusViewController alloc]init];
    vc.focusLogNum = [self.hostdict[@"focusLogNum"] boolValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)wodeFangke{
    ML_MineFriendViewController *vc = [[ML_MineFriendViewController alloc]init];
    vc.accessLogNum = [self.hostdict[@"accessLogNum"] boolValue];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)kaitongHuiYuan:(UIButton*)sender{
    MLKaitongViewController *vc = [[MLKaitongViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)bookClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId;
    [self showMessage:Localized(@"复制成功", nil)];
}


-(void)setCollectionView{
    //1、实例化一个流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
       //1-1、设置Cell大小
//       flowLayout.itemSize= CGSizeMake((self.view.frame.size.width-202)/3, 84);
//       //1-2、设置四周边距
//       flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
//       //1-3、设置最小列之间的距离
//       flowLayout.minimumInteritemSpacing = 61;
    
        flowLayout.itemSize= CGSizeMake((self.view.frame.size.width-202)/3, 84);
      //1-2、设置四周边距
       flowLayout.sectionInset = UIEdgeInsetsMake(0,32,0,32);
       flowLayout.minimumInteritemSpacing = 32;
       
    
    
       //2、实例化创建一个 UICollectionView
       //UICollectionView必须有一个 flowLayout ，必须在实例化的时候进行设置
    self.ML_homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
       //3、设置背景为白色
    self.ML_homeCollectionView.layer.cornerRadius = 16;
       //4、设置数据源代理
    self.ML_homeCollectionView.dataSource = self;
    self.ML_homeCollectionView.delegate = self;
    //添加到视图中
    [self.view addSubview:self.ML_homeCollectionView];
    //注册Cell视图
    [self.ML_homeCollectionView registerClass:[ML_MineCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.ML_homeCollectionView registerClass:[ML_MineBottomCollectionViewCell class] forCellWithReuseIdentifier:@"cellTwo"];
    [self.ML_homeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
        [self.ML_homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.top.mas_equalTo(266*mHeightScale);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
        }];

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(164*mWidthScale,64*mHeightScale);;
    }else{
        return CGSizeMake(343*mWidthScale, 48*mHeightScale);;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(16, 16, 0, 16);
    }else{
        return UIEdgeInsetsMake(0,32,0,32);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 1) {
            UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
            
           //添加头视图的内容
            for (UIView *view in header.subviews){
                [view removeFromSuperview];
            }
            
            UILabel *slognameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0 , 100,48)];
            slognameLabel.text = @"常用功能";
            slognameLabel.font = [UIFont boldSystemFontOfSize:16];
            slognameLabel.textColor = [UIColor colorFromHexString:@"#000000"];
            
           //头视图添加view
           [header addSubview:slognameLabel];
            
           return header;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }else{
        return CGSizeMake(self.view.frame.size.width, 48);
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
            return 2;
    }else{
        return self.ML_celltitleArray.count;
    }
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ML_MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            if (cell==nil) {
                cell = [[ML_MineCollectionViewCell alloc]init];
            }
        NSInteger ismale = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender.integerValue;
        switch (indexPath.row) {
            case 0:
                if (ismale) {
                    cell.imageView.image = kGetImage(@"myWallet");
                }else{
                    cell.imageView.image = kGetImage(@"jifenCashOut");
                }
                break;
            case 1:
                if (ismale) {
                    cell.imageView.image = kGetImage(@"heardVip");
                }else{
                    cell.imageView.image = kGetImage(@"myRenzheng");
                }
                break;
            default:
                break;
        }
        return cell;
    }else{
        ML_MineBottomCollectionViewCell *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellTwo" forIndexPath:indexPath];
        cellTwo.nameLabel.text = self.ML_celltitleArray[indexPath.row];
        cellTwo.cellIcon.image = [UIImage imageNamed:self.ML_cellimgArray[indexPath.row]];
        if (indexPath.row == 0) {
            cellTwo.rightArrow.hidden = YES;
            cellTwo.setnetbtn.hidden = NO;
        }else{
            cellTwo.rightArrow.hidden = NO;
            cellTwo.setnetbtn.hidden = YES;
        }
        if ([cellTwo.nameLabel.text isEqualToString:@"通话价格"]) {
            cellTwo.priceLabel.text = [NSString stringWithFormat:@"%@%@/%@", [ML_AppUserInfoManager sharedManager].currentLoginUserData.charge, Localized(@"金币", nil), Localized(@"分钟", nil)];
        }else{
            cellTwo.priceLabel.text = @"";
        }
        return cellTwo;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSInteger ismale = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender.integerValue;
        switch (indexPath.row) {
            case 0:
                    [self gotoChongVC];
 
                break;
            case 1:
                if (ismale) {
                   //我的会员
                    MLKaitongViewController *vc = [[MLKaitongViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    //我的认证
                    MLMineFaceViewController *vc = [[MLMineFaceViewController alloc]init];
                    vc.dict = self.hostdict;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            default:
                break;
        }

    }else{
        if ([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"我的钱包", nil)]||[_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"积分提现", nil)]) {
            [self gotoChongVC];
        }else if([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"邀请奖励", nil)]){
            MLTuijiangiftViewController *vc = [[MLTuijiangiftViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"开通会员", nil)] ||
                 [_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"我的会员", nil)]){
            MLKaitongViewController *vc = [[MLKaitongViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"我的认证", nil)]){
            MLMineFaceViewController *vc = [[MLMineFaceViewController alloc]init];
            vc.dict = self.hostdict;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"] && [_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"招呼设置", nil)]){
      
            MLZhaohuSettingViewController *vc = [[MLZhaohuSettingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"通话价格", nil)]){
            
            [self changePrice];
            
        }else if([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"官方客服", nil)]){
            
            [self gotoChatVC:@"100000"];
            
        }else if([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"我的工会", nil)]){
            
            if ([ML_AppUserInfoManager.sharedManager.currentLoginUserData.guildCode intValue] == 0) {
                ML_GonghuiVC *vc = [[ML_GonghuiVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([ML_AppUserInfoManager.sharedManager.currentLoginUserData.guildCode intValue] == 1) {
                kplaceToast(Localized(@"审核中，请耐心等待", nil));
            } else if ([ML_AppUserInfoManager.sharedManager.currentLoginUserData.guildCode intValue] == 2) {
                kplaceToast(Localized(@"审核通过，请联系客服", nil));
            } else if ([ML_AppUserInfoManager.sharedManager.currentLoginUserData.guildCode intValue] == 3) {
                ML_GonghuitongjiVC *vc = [[ML_GonghuitongjiVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"美颜参数", nil)]){
                        [FYAppManager.shareInstanse fy_openCamerePage:self complte:^(BOOL isSuccess) {
                            if (isSuccess) {
                                NSArray *array = [FUManager shareManager].dataSource[0];
                                if (array.count) {
                                    FULiveModel *model = (FULiveModel *)array[0];
                                    [FUManager shareManager].currentModel = model;

                                    FUBeautyController *vc = [[FUBeautyController alloc] init];
                                    vc.model = array[0];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }
                        }];
        }else if ([_ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"系统设置", nil)]){
            ML_SettingViewController *vc = [[ML_SettingViewController alloc]init];
        //    vc.dict = self.mineDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

//-(void)ML_rightItemClicked{
//    ML_SettingViewController *vc = [[ML_SettingViewController alloc]init];
////    vc.dict = self.mineDict;
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)setnetClick{
    ML_MineEditViewController *vc = [[ML_MineEditViewController alloc]init];
    vc.typevideo = @"更新资料";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 点击更多--------
-(void)exitbtnClick{
    NSLog(@"推出账号...");
}



-(void)changePrice{
    if (!self.dataid.count) {
        [SVProgressHUD show];
        [self giveML_GetChargeApi];
        return;
    }
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    //stringPickerView.title = @"";
    stringPickerView.dataSourceArr = self.data;
       stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
           NSLog(@"%@",resultModel.value);
           self.chargelabel = resultModel.value;
           [self setML_SetChargeApichargid:self.dataid[resultModel.index]];
//           [self.tableview reloadData];
      };
    // 自定义弹框样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    if (@available(iOS 13.0, *)) {
//        customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
        customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
    } else {
        customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
    }
    //customStyle.separatorColor = setcolor(200, 200, 200, 1);
    stringPickerView.pickerStyle = customStyle;
    [stringPickerView show];
}


//设置价格列表--
-(void)setML_SetChargeApichargid:(NSString *)chargid{
    ML_SetChargeApi *api = [[ML_SetChargeApi alloc]initWithchargeId:chargid extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data);
        if ([response.status integerValue] == 0)  {
            [self showMessage:Localized(@"设置成功", nil)];
            UserInfoData *infoData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
            infoData.charge = self.chargelabel;
            [ML_AppUserInfoManager sharedManager].currentLoginUserData = infoData;
            [self.ML_homeCollectionView reloadData];
        }else{
            [self showMessage:@"设置异常"];
        }
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
