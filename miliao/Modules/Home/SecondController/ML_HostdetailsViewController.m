//
//  ML_HostdetailsViewController.m
//  miliao
//
//  Created by apple on 2022/9/2.
//

#import "ML_HostdetailsViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ML_XuanAlbumView.h"
#import <Masonry/Masonry.h>
#import "ML_getTypeHostsApi.h"
#import <Colours/Colours.h>
#import "ML_hotsmessageCollectionViewCell.h"
#import "ML_HostGexingTableViewCell.h"
#import "ML_HostMessageTableViewCell.h"
#import "HXTagsCell.h"
#import "MLUserHomeApi.h"
#import "MLGetUserDynamicApi.h"
#import "ML_GetUserInfoApi.h"
#import "MLFocusApi.h"

#import "YBImageBrowser.h"
#import "MLMineDynameicViewController.h"
#import "UIViewController+MLHud.h"
#import "YBIBVideoData.h"
#import "ML_ToolViewHandlerTwo.h"
#import "ML_sayHelloApi.h"
#import "UIAlertView+NTESBlock.h"
#import "SiLiaoBack-Swift.h"
#import <JXCategoryView/JXCategoryView.h>
#import "ML_CommunityCell.h"
#import "ML_UnlockWxAlertView.h"
#define k_THUMBNAIL_IMG_WIDTH 100//缩略图大小
#define k_FPS 1//一秒想取多少帧

@interface ML_HostdetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,JXCategoryViewDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *dynamicdata;
@property (nonatomic,strong)NSMutableArray *urldynamicdata;
//@property (nonatomic, strong) UIImageView  *rangeimg;
//@property (nonatomic, strong) UILabel *rangeidnameLabel;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIImageView *rangbgview;
@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UICollectionView *ML_headCollectionView;
@property (nonatomic,strong) HXTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic,strong) NSArray *selectTags;
@property (nonatomic, strong) UIImageView  *boImageView;
@property (nonatomic, strong) UIImageView  *onlineimg;
@property (nonatomic, strong) UIImageView  * bgImageView;
@property (nonatomic, strong) UIScrollView * bgScrollView;
// 本地图片
@property (nonatomic, strong) SDCycleScrollView * ML_webCycleScrollView;
@property (nonatomic, strong) UILabel * bbnameLabel;
@property (nonatomic, strong) NSArray * giftListArr;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * idnameLabel;
@property (nonatomic, strong) UILabel *irrbbnameLabel;
@property (nonatomic, strong) UIButton * agebtn;
@property (nonatomic, strong) UILabel * countryLabel;
@property (nonatomic,strong)UILabel *indexlabel;
@property (nonatomic,strong)NSArray * localImageArray;
@property (nonatomic,strong)NSDictionary *userDict;
@property (nonatomic,assign)BOOL buyWxCode;
@property (nonatomic,strong)NSMutableArray *bannersArray;
@property (nonatomic,strong)NSMutableArray *urlArray;
@property (nonatomic,strong)NSDictionary *urldict;
@property (nonatomic,strong)NSDictionary *tagDic;
@property (nonatomic,strong)NSArray *tags;
@property (nonatomic,strong)NSArray *yinTags;
@property (nonatomic,strong)NSMutableArray *imgBrArr;
@property (nonatomic,strong)NSMutableArray *userArray;
@property (nonatomic,strong)UIButton *focusBtn;
@property (nonatomic,strong)NSString * userId;
@property(nonatomic,assign) BOOL isLahei;

@property (nonatomic,strong)UIImageView *statusimg;
@property (nonatomic,strong)UIButton *sixinbtn;
@property (nonatomic,strong)UIButton *giftbtn;
@property (nonatomic,strong)UIButton *dashanbtn;
@property (nonatomic,strong)UIButton *videobtn;
@property (nonatomic,strong)UIButton *shipinchargeLabel;
@property (nonatomic,strong)UILabel *wxV;
@property (nonatomic,strong)UIButton *chBtn;
@property (nonatomic,strong)JXCategoryTitleView *categoryView;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)ML_UnlockWxAlertView *unlock;
@end

@implementation ML_HostdetailsViewController

static NSString *ident = @"cell";

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    self.index = index;
    [self.tablview reloadData];
}

-(NSMutableArray *)urldynamicdata{
    if (_urldynamicdata == nil) {
        _urldynamicdata = [NSMutableArray array];
    }
    return _urldynamicdata;
}

-(NSMutableArray *)userArray{
    if (_userArray == nil) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

-(NSMutableArray *)urlArray{
    if (_urlArray == nil) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

-(NSMutableArray *)dynamicdata{
    if (_dynamicdata == nil) {
        _dynamicdata = [NSMutableArray array];
    }
    return _dynamicdata;
}

-(NSMutableArray *)bannersArray{
    if (_bannersArray == nil) {
        _bannersArray = [NSMutableArray array];
    }
    return _bannersArray;

}
- (instancetype)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _userId = [NSString stringWithFormat:@"%@", userId];
    }
    return self;

}
//- (instancetype)initWithUserId:(NSString *)userId
//{
//    self = [super init];
//    if (self) {
//        _userId = userId;
//    }
//    return self;
//
//}

#pragma mark 轮播
- (SDCycleScrollView *)ML_webCycleScrollView{
    if (!_ML_webCycleScrollView){
        self.ML_webCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"gegezhan"]];
        self.ML_webCycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
        self.ML_webCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        self.ML_webCycleScrollView.delegate = self;
        // 分页控件的位置
        self.ML_webCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.ML_webCycleScrollView.pageControlBottomOffset = 16*mHeightScale;
    }
    return _ML_webCycleScrollView;
}

-(UILabel *)indexlabel{
    if (!_indexlabel){
        self.indexlabel = [[UILabel alloc]init];
        self.indexlabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
        self.indexlabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _indexlabel;
}

// 点击图片代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
    if ([self.bannersArray[index] containsString:@".mp4"]) {
        
        NSArray *arr = self.userDict[@"photos"];
        
        NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
        NSString *ss = [NSString stringWithFormat:@"%@%@",basess, arr[index][@"icon"]];
            
        YBIBVideoData *Data = [YBIBVideoData new];
        Data.autoPlayCount = NSUIntegerMax;
        Data.shouldHideForkButton = NO;
        Data.allowSaveToPhotoAlbum = NO;
        Data.videoURL = kGetUrlPath(ss);
        Data.repeatPlayCount = NSUIntegerMax;
        Data.autoPlayCount = NSUIntegerMax;
        Data.projectiveView = cycleScrollView;

        __block YBImageBrowser *Browser = [YBImageBrowser new];
        Browser.dataSourceArray = @[Data];
        Browser.currentPage = 0;
        [Browser showToView:KEY_WINDOW.window];


        __block ML_ToolViewHandlerTwo *tool = [ML_ToolViewHandlerTwo new];
        tool.Browser = Browser;
        Browser.toolViewHandlers = @[tool];


        tool.ML_ToolViewHandlerBtnBlock = ^(NSInteger tag) {

            [Browser hide];
        };
        
        
    } else {
        
        YBImageBrowser *Browser = [YBImageBrowser new];
        Browser.dataSourceArray = self.imgBrArr;
        Browser.currentPage = index;
        [Browser showToView:[UIViewController topShowViewController].view];
        
        // 清理缓存
        [SDCycleScrollView clearImagesCache];
    }
}

// 滚动到第几张图片的回调
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
    self.indexlabel.text = [NSString stringWithFormat:@"%ld/%lu",index + 1,(unsigned long)self.bannersArray.count];
    
    if (index == 0) {
        self.boImageView.hidden = ![self.bannersArray[index] containsString:@".mp4"];
    } else {
        self.boImageView.hidden = YES;
    }
}

- (HXTagCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [HXTagCollectionViewFlowLayout new];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.unlock removeFromSuperview];
}

-(void)giveMLUserHomeApi{
    
//    [SVProgressHUD show];
    kSelf;
    MLUserHomeApi *api = [[MLUserHomeApi alloc] initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] toUserId:_userId];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        weakself.userDict = response.data[@"user"];
        weakself.buyWxCode = [weakself.userDict[@"buyWxCode"] boolValue];
        weakself.ML_titleLabel.text = weakself.userDict[@"name"];
        
        if (weakself.tagDic) { // weakself.userDict
            NSLog(@"123123123123");
            [weakself setUIWithData];
        }
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)setUIWithData
{
    kSelf;
    dispatch_async(dispatch_get_main_queue(), ^{ // 异步主线程
   
        [SVProgressHUD dismiss];
        
    
            NSLog(@"个人信息主页----%@", weakself.userDict);
            [weakself.bannersArray removeAllObjects];
            NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
            for (NSDictionary *aaD in weakself.userDict[@"photos"]) {
                
                  NSString *ss = [NSString stringWithFormat:@"%@%@",basess, aaD[@"icon"]];
                
                if ([ss containsString:@".mp4"]) {
                    
                    NSString *dd = @"?x-oss-process=video/snapshot,t_1,f_png,w_0,h_0,ar_auto&modify=0";
                    
                    [weakself.bannersArray addObject:[NSString stringWithFormat:@"%@%@", ss, dd]];
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ML_ScreenWidth / 2 - 40, 406 / 2 - 40, 80, 80)];
                    imgView.image = kGetImage(@"icon_shiping_36_nor");
                    [weakself.ML_webCycleScrollView addSubview:imgView];
                    weakself.boImageView = imgView;
                } else {
                    
                    [weakself.bannersArray addObject:ss];
                }
            }
            
            if (!self.bannersArray.count) {
                
                NSString *urlStr = [NSString stringWithFormat:@"%@%@", basess, self.userDict[@"icon"]];
                [self.bannersArray addObject:urlStr];
            }
            
    //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    //        view.backgroundColor= [UIColor redColor];
    //        [weakself.view addSubview:view];
    //        return;
            
            [weakself setupUI];
       
            [weakself setupHeadView];
            [weakself settingUIData];
            [weakself.ML_headCollectionView reloadData];
            [weakself.tablview reloadData];
            
            
            if ([weakself.userDict[@"host"] boolValue]) {
                weakself.wxV.hidden = NO;
                
                if ([weakself.userDict[@"buyWxCode"] boolValue] || [weakself.userId isEqualToString:[ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]) {
                   
                } else {
   
                }
            } else {

            }

            
            NSMutableArray *muArr = [NSMutableArray arrayWithArray:weakself.tagDic[@"lables"]];
    //        for (NSDictionary *dic in tagDic[@"lables"]) {
    //            [muArr addObject:dic[@"name"]?:@""];
    //        }
            weakself.tags = muArr;
            
            NSMutableArray *yinMuArr = [NSMutableArray arrayWithArray:weakself.tagDic[@"userLables"]];
    //        for (NSDictionary *dic in tagDic[@"userLables"]) {
    //            [yinMuArr addObject:dic[@"name"]?:@""];
    //        }
            weakself.yinTags = yinMuArr;
            
            weakself.giftListArr = weakself.tagDic[@"gifts"]?:@[];
            
            [weakself.userArray addObject:[NSString stringWithFormat:@"%@ %@岁", [weakself.tagDic[@"gender"] intValue]==1?Localized(@"男", nil):Localized(@"女", nil), weakself.tagDic[@"age"]?:@""]];
            
            if ([weakself.tagDic[@"height"]  integerValue])
             {
                [weakself.userArray addObject:[NSString stringWithFormat:@"%@cm", weakself.tagDic[@"height"]]];
             }
            if ([weakself.tagDic[@"city"] length])
             {
                [weakself.userArray addObject:[NSString stringWithFormat:@"所在地：%@", weakself.tagDic[@"city"]]];
             }
            if ([weakself.tagDic[@"weight"]  integerValue])
             {
                [weakself.userArray addObject:[NSString stringWithFormat:@"%@kg", weakself.tagDic[@"weight"]]];
             }
            if ([weakself.tagDic[@"uss"]  length])
             {
                [weakself.userArray addObject:[NSString stringWithFormat:@"%@", weakself.tagDic[@"uss"]]];
             }
            if ([weakself.tagDic[@"em"]  length])
             {
                [weakself.userArray addObject:[NSString stringWithFormat:@"%@", weakself.tagDic[@"em"]]];
             }
            if ([weakself.tagDic[@"pro"]  length])
             {
                [weakself.userArray addObject:[NSString stringWithFormat:@"%@", weakself.tagDic[@"pro"]]];
             }
    //        if ([tagDic[@"lastLoginTime"]  length])
    //        {
    //            [weakself.userArray addObject:[NSString stringWithFormat:@"上次登录：%@", tagDic[@"lastLoginTime"]]];
    //        }
            
           if ([weakself.userDict[@"online"] intValue] == 1) {
                weakself.onlineimg.image = AppDelegate.shareAppDelegate.busyImage;
            } else if ([weakself.userDict[@"online"] intValue] == 2) {
                weakself.onlineimg.image = [UIImage imageNamed:@"Sliceliao52"];
            } else if ([weakself.userDict[@"online"] intValue] == 3) {
                weakself.onlineimg.image = kGetImage(@"label_online");
            }else {
                weakself.onlineimg.image = AppDelegate.shareAppDelegate.offlineImage;
            }
            
            
            weakself.nameLabel.text = weakself.tagDic[@"name"];
    //        weakself.idnameLabel.text = tagDic[@"userId"];
            weakself.agebtn.selected = [weakself.tagDic[@"gender"] boolValue];
            if ([weakself.tagDic[@"gender"] integerValue] == 1) {
    //            [weakself.agebtn setImage:[UIImage imageNamed:@"icon_nansheng_24_sel-1"] forState:UIControlStateNormal];
    //            weakself.agebtn.backgroundColor = [UIColor colorWithRed:175/255.0 green:189/255.0 blue:250/255.0 alpha:1.0];
            } else {
    //          [weakself.agebtn setImage:[UIImage imageNamed:@"icon_nvsheng_24_sel-2"] forState:UIControlStateNormal];
    //            weakself.agebtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:151/255.0 blue:151/255.0 alpha:1.0];
            }
            //        [self.agebtn setTitle:[NSString stringWithFormat:@"%@",weakself.tagDic[@"age"]] forState:UIControlStateNormal];
            [self.agebtn setTitle:[NSString stringWithFormat:@"%@",weakself.tagDic[@"age"]] forState:UIControlStateNormal];
        
        if ([weakself.userDict[@"userType"] integerValue] == 1) {
            weakself.countryLabel.text = @"海外";
        }else {
            weakself.countryLabel.text = @"国内";
        }
            
            if ([weakself.tagDic[@"host"] integerValue] == 1) {
                weakself.statusimg.hidden = NO;
            }else{
                weakself.statusimg.hidden = YES;
            }

            
            if (weakself.bannersArray.count) {
                weakself.indexlabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)weakself.bannersArray.count];
            }
            
            
            if ([weakself.userDict[@"focus"] integerValue] == 0) {
                weakself.focusBtn.selected = NO;
            }else{
                weakself.focusBtn.selected = YES;
            }
            
            weakself.dashanbtn.hidden = [self.userDict[@"call"] boolValue];
            [weakself.idnameLabel setTitle:[NSString stringWithFormat:@"ID:%@", weakself.userDict[@"userId"]] forState:UIControlStateNormal];
        NSString * fensi = [NSString stringWithFormat:@"%@",weakself.userDict[@"fansNum"]];
        NSString *guanzhu = [NSString stringWithFormat:@"%@",weakself.userDict[@"foucsNum"]];;
            NSString *string = [NSString stringWithFormat:@"%@ %ld  %@ %ld",Localized(@"粉丝", nil),[weakself.userDict[@"fansNum"] integerValue]?:0,Localized(@"关注", nil),[weakself.userDict[@"foucsNum"]integerValue]?:0];
        NSMutableAttributedString *attributeS = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange range1 = [string rangeOfString:fensi];
        NSRange range2 = [string rangeOfString:guanzhu];
        [attributeS addAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14],NSForegroundColorAttributeName:kGetColor(@"ffffff")} range:range1];
        [attributeS addAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14],NSForegroundColorAttributeName:kGetColor(@"ffffff")} range:range2];
        weakself.bbnameLabel.attributedText = attributeS;
        [weakself.shipinchargeLabel setTitle:[NSString stringWithFormat:@"%@%@/分钟", self.userDict[@"charge"], Localized(@"金币", nil)] forState:UIControlStateNormal];
            if ([weakself.userDict[@"host"] integerValue] == 0) {
                weakself.shipinchargeLabel.hidden = YES;
            }else{
                weakself.shipinchargeLabel.hidden = NO;
            }
            
            if (![ML_AppUtil isCensor]) {
                weakself.shipinchargeLabel.hidden = YES;
            }
        
    });
    
}

- (void)chBtnkanClick
{
    
    self.unlock = [ML_UnlockWxAlertView showWithUnlock:self.buyWxCode dic:self.userDict userId:self.userId];

}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    if (!_userId) {
        _userId = [NSString stringWithFormat:@"%@", dict[@"userId"]];
    }
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}


//获取个人动态----
-(void)giveMLGetUserDynamicApi{
    [SVProgressHUD show];
    kSelf;
    MLGetUserDynamicApi *api = [[MLGetUserDynamicApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token page:@(1) toUserId:_userId];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"个人动态--%@",response.data);
        
        
        self.dynamicdata = response.data[@"dynamics"];
        if (self.dynamicdata.count) {
            self.urldict = self.dynamicdata[0];
        }

        
        [self.urldict[@"url"] enumerateObjectsUsingBlock:^(NSString *url, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.urlArray addObject:url];
        }];

//        [self giveML_GetUserInfoApi];
        
        if (weakself.userDict && weakself.tagDic) { // weakself.dynamicdata
            NSLog(@"123123123123");
            [weakself setUIWithData];
        }
        
        
    } error:^(MLNetworkResponse *response) {
        
            NSLog(@"giveMLGetUserDynamicApi  报错--%@", response.data);
        
    } failure:^(NSError *error) {
        NSLog(@"giveMLGetUserDynamicApi报错--");
    }];
}

-(void)giveML_GetUserInfoApi{
//    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    
//    [SVProgressHUD show];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.userId} urlStr:@"host/getUserInfo"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
//        [SVProgressHUD dismiss];
        NSDictionary *tagDic = response.data[@"userInfo"];
        weakself.tagDic = tagDic;
        
//        [weakself giveMLUserHomeApi];
        
        
        if (weakself.userDict) { // weakself.tagDic
            NSLog(@"123123123123");
            [weakself setUIWithData];
        }
        
        
    } error:^(MLNetworkResponse *response) {
        
            NSLog(@"giveML_GetUserInfoApi  报错--%@", response.data);
        
    } failure:^(NSError *error) {
        
            NSLog(@"giveML_GetUserInfoApi报错--");
    }];
        
    
}

- (void)settingUIData
{
    self.ML_webCycleScrollView.imageURLStringsGroup = self.bannersArray;
    
    
    self.imgBrArr = [NSMutableArray array];
    for (NSString *strUrl in self.bannersArray) {
    
            YBIBImageData *Data = [YBIBImageData new];
            Data.imageURL = [NSURL URLWithString:strUrl];
            Data.projectiveView = self.ML_webCycleScrollView;
            Data.extraData = [NSURL URLWithString:strUrl];
            [self.imgBrArr addObject:Data];
        
    }
    
    if ([self.userDict[@"focus"] integerValue] == 0) {
        self.focusBtn.selected = NO;
    }else{
        self.focusBtn.selected = YES;
    }
    self.dashanbtn.hidden = [self.userDict[@"call"] boolValue];
    [self.idnameLabel setTitle:[NSString stringWithFormat:@"ID:%@", self.userDict[@"userId"]] forState:UIControlStateNormal]; ;
    NSString * fensi = [NSString stringWithFormat:@"%@",self.userDict[@"fansNum"]];
    NSString *guanzhu = [NSString stringWithFormat:@"%@",self.userDict[@"foucsNum"]];;
        NSString *string = [NSString stringWithFormat:@"%@ %ld  %@ %ld",Localized(@"粉丝", nil),[self.userDict[@"fansNum"] integerValue]?:0,Localized(@"关注", nil),[self.userDict[@"foucsNum"]integerValue]?:0];
    NSMutableAttributedString *attributeS = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range1 = [string rangeOfString:fensi];
    NSRange range2 = [string rangeOfString:guanzhu];
    [attributeS addAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14],NSForegroundColorAttributeName:kGetColor(@"ffffff")} range:range1];
    [attributeS addAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14],NSForegroundColorAttributeName:kGetColor(@"ffffff")} range:range2];
    self.bbnameLabel.attributedText = attributeS;
    [self.shipinchargeLabel setTitle:[NSString stringWithFormat:@"%@%@/分钟", self.userDict[@"charge"], Localized(@"金币", nil)] forState:UIControlStateNormal] ;
    if ([self.userDict[@"host"] integerValue] == 0) {
        self.shipinchargeLabel.hidden = YES;
    }else{
        self.shipinchargeLabel.hidden = NO;
    }
    
    if (![ML_AppUtil isCensor]) {
        self.shipinchargeLabel.hidden = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.hidden = YES;
    self.ML_titleLabel.textAlignment = NSTextAlignmentLeft;
    self.view.backgroundColor = UIColor.whiteColor;
    self.ML_titleLabel.textColor = UIColor.whiteColor;
    
    self.ML_navView.backgroundColor = [UIColor clearColor];
    
    [self giveMLGetUserDynamicApi];
    
    [self giveML_GetUserInfoApi];
    [self giveMLUserHomeApi];
    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"userId" : self.userId} urlStr:@"user/whetherFocus"];
     kSelf;
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

         weakself.isLahei = [response.data[@"block"] boolValue];
       
     } error:^(MLNetworkResponse *response) {

     } failure:^(NSError *error) {
         
     }];
    
    [self um_openingTimesOfAnchorData];
}

- (void)um_openingTimesOfAnchorData { // 进入页面
      NSDictionary *eventParams = @{@"Um_Key_PageName":@"主播资料打开次数",
                                    @"Um_Key_UserID":self.userId,
                                    @"Um_Key_Type":@"0"
                                  };

//    [MobClick beginEvent:@"5121" primarykey:@"openingTimesOfAnchorData" attributes:eventParams];
}

- (void)sixinbtnClick
{
    [self gotoChatVC:[NSString stringWithFormat:@"%@", self.userId]];
}
- (void)giftbtnClick
{

    [self presentGiftByUserId:[self.userId intValue]];
}
- (void)videobtnClick
{
    [self gotoCallVCWithUserId:self.userId isCalled:NO];
}


-(void)setupUI{
    
    UIView *bottomBack = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:bottomBack];
    [bottomBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.bottom.mas_equalTo(-40*mHeightScale);
        make.height.mas_equalTo(56*mHeightScale);
    }];
    bottomBack.backgroundColor = UIColor.whiteColor;
    bottomBack.layer.cornerRadius = 28*mHeightScale;
   
    bottomBack.layer.shadowColor = UIColor.blackColor.CGColor;
    bottomBack.layer.shadowOffset = CGSizeMake(0, 0);
    bottomBack.layer.shadowOpacity = 0.2;
    bottomBack.layer.shadowRadius = 2;
    
    UIButton *sixinbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sixinbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [sixinbtn setImage:[UIImage imageNamed:@"Cmessage"] forState:UIControlStateNormal];
    [sixinbtn setTitle:@"消息" forState:UIControlStateNormal];
    [sixinbtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    sixinbtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [sixinbtn setImageEdgeInsets:UIEdgeInsetsMake(-18*mHeightScale, 0, 0, 0)];
    [sixinbtn setTitleEdgeInsets:UIEdgeInsetsMake(27*mHeightScale, -27*mHeightScale, 0, 0)];
   
//    [sixinbtn setBackgroundImage:[UIImage imageNamed:@"SliceC-15"] forState:UIControlStateNormal];
    [sixinbtn addTarget:self action:@selector(sixinbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBack addSubview:sixinbtn];
    self.sixinbtn = sixinbtn;
    [sixinbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24*mWidthScale);
        make.left.mas_equalTo(30*mWidthScale);
        make.height.mas_equalTo(42*mHeightScale);
        make.centerY.mas_equalTo(bottomBack.mas_centerY);
    }];
    UIButton *giftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    giftbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [giftbtn addTarget:self action:@selector(giftbtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [giftbtn setImage:[UIImage imageNamed:@"Slice 31"] forState:UIControlStateNormal];
    [giftbtn setImage:[UIImage imageNamed:@"Cgift"] forState:UIControlStateNormal];
    [giftbtn setTitle:@"礼物" forState:UIControlStateNormal];
    [giftbtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    giftbtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [giftbtn setImageEdgeInsets:UIEdgeInsetsMake(-18*mHeightScale, 0, 0, 0)];
    [giftbtn setTitleEdgeInsets:UIEdgeInsetsMake(27*mHeightScale, -27*mHeightScale, 0, 0)];
    [bottomBack addSubview:giftbtn];
    self.giftbtn = giftbtn;
    [giftbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24*mWidthScale);
        make.height.mas_equalTo(42*mHeightScale);
        make.centerY.mas_equalTo(sixinbtn.mas_centerY);
        make.left.mas_equalTo(sixinbtn.mas_right).mas_offset(20*mWidthScale);
    }];
    
    UIButton *dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dashanbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [dashanbtn addTarget:self action:@selector(dashanClick:) forControlEvents:UIControlEventTouchUpInside];
    [dashanbtn setImage:[UIImage imageNamed:@"hibt"] forState:UIControlStateNormal];
    [dashanbtn setTitle:@"招呼" forState:UIControlStateNormal];
    [dashanbtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    dashanbtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [dashanbtn setImageEdgeInsets:UIEdgeInsetsMake(-18*mHeightScale, 0, 0, 0)];
    [dashanbtn setTitleEdgeInsets:UIEdgeInsetsMake(27*mHeightScale, -27*mHeightScale, 0, 0)];
    [bottomBack addSubview:dashanbtn];
    self.dashanbtn = dashanbtn;
    [dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24*mWidthScale);
        make.height.mas_equalTo(42*mWidthScale);
        make.centerY.mas_equalTo(giftbtn.mas_centerY);
        make.left.mas_equalTo(giftbtn.mas_right).mas_offset(20*mWidthScale);
    }];

    UIButton *videobtn = [[UIButton alloc]initWithFrame:CGRectZero];
    if (kisCH) {
//        [videobtn setImage:[UIImage imageNamed:@"Slice 32"] forState:UIControlStateNormal];
        [videobtn setBackgroundImage:kGetImage(@"buttonBG1") forState:UIControlStateNormal];
        [videobtn setTitle:@"与Ta视频" forState:UIControlStateNormal];
        [videobtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        videobtn.titleLabel.font = [UIFont systemFontOfSize:16];
    } else {
        videobtn.layer.cornerRadius = 24;
        videobtn.layer.masksToBounds = YES;
        videobtn.backgroundColor = kZhuColor;
        [videobtn setTitle:@"" forState:UIControlStateNormal];
        [videobtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [videobtn addTarget:self action:@selector(videobtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBack addSubview:videobtn];
    self.videobtn = videobtn;
    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomBack.mas_right).mas_offset(-4*mWidthScale);
        make.height.mas_equalTo(48*mHeightScale);

        make.centerY.mas_equalTo(sixinbtn.mas_centerY);
        make.width.mas_equalTo(183*mWidthScale);

    }];

    self.tablview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    [self.tablview setSeparatorColor:[UIColor whiteColor]];
    self.headView = [[UIView alloc]init];
    if ([self.userDict[@"host"] boolValue]) {
        //主播
        self.headView.frame = CGRectMake(0, 0, ML_ScreenWidth, 530*mHeightScale);
    }else{
        self.headView.frame = CGRectMake(0, 0, ML_ScreenWidth, 500*mHeightScale);
    }

    
    
    self.tablview.backgroundColor = UIColor.whiteColor;
    self.tablview.tableHeaderView = self.headView;
    self.tablview.rowHeight = UITableViewAutomaticDimension;

    self.tablview.allowsSelection = NO;
    [self.view addSubview:self.tablview];
    [self.view bringSubviewToFront:self.ML_navView];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);

        make.top.mas_equalTo(self.view.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(sixinbtn.mas_top).mas_offset(-12);
    }];
    

    [self.ML_backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor"] forState:UIControlStateNormal];
    [self ML_addNavRightBtnWithTitle:nil image:kGetImage(@"icon_fenxiang_24_FFF_nor")];

}

- (void)ML_rightItemClicked
{
    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"userId" : self.userId} urlStr:@"user/whetherFocus"];
     kSelf;
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

         weakself.isLahei = [response.data[@"block"] boolValue];
         
         
         NSArray<PopItemModel *> *Items = [PopItemModel TwoToFYProfileControllerWithIsla:weakself.isLahei];
         kSelf2;
         [ML_XuanAlbumView popItems:Items action:^(NSInteger index) {
        
             [weakself ML_PopAction:index pDic:@{@"userId" : weakself2.userId, @"dongId" : @"0", @"block" : @(weakself2.isLahei)}];
         }];
         
     } error:^(MLNetworkResponse *response) {

     } failure:^(NSError *error) {
         
     }];
    
    
        
}

//-(void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewDidLayoutSubviews {
    CGRect oldRect = self.bgview.bounds;
    oldRect.size.width = [UIScreen mainScreen].bounds.size.width;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:oldRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16*mHeightScale, 16*mHeightScale)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskLayer.frame = oldRect;
    self.bgview.layer.mask = maskLayer;

    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host integerValue] == [self.tagDic[@"host"] integerValue]) {
        self.focusBtn.hidden = YES;
        self.sixinbtn.hidden = YES;
        self.dashanbtn.hidden = YES;
        self.giftbtn.hidden = YES;
        self.videobtn.hidden = YES;
        [self.tablview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarSafeBottomMargin);
        }];
    }else{
        self.focusBtn.hidden = NO;
        self.sixinbtn.hidden = NO;
        self.dashanbtn.hidden = [self.userDict[@"call"] boolValue];
        self.giftbtn.hidden = NO;
        self.videobtn.hidden = NO;
        [self.tablview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.sixinbtn.mas_top).mas_offset(-12);
        }];
    }
    
    if (self.shipinchargeLabel.hidden == YES) {
        [self.bbnameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headView.mas_left).mas_offset(16);
            make.top.mas_equalTo(self.idnameLabel.mas_bottom).mas_offset(12);
        }];
    }
}

#pragma mark ---- 头部视图---------

-(void)setupHeadView{
    BOOL ishost = [self.tagDic[@"host"] boolValue];
//    ishost = NO;
    [self.headView addSubview:self.ML_webCycleScrollView];
      [self.ML_webCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.right.top.mas_equalTo(self.headView);
          make.height.mas_equalTo(380*mHeightScale);
//          make.bottom.mas_equalTo(self.headView.mas_bottom).mas_offset(-205 - 151);
      }];
    //online 主播在线状态，0-离线 1-勿扰 2-在聊 3-在线
    
//    UIImageView *onlineimg = [[UIImageView alloc]init];
//    [self.headView addSubview:onlineimg];
//    [onlineimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(48);
//        make.height.mas_equalTo(18);
//        make.left.mas_equalTo(self.headView.mas_left).mas_offset(16);
//        make.bottom.mas_equalTo(self.ML_webCycleScrollView.mas_bottom).mas_offset(-18);
//    }];
//    self.onlineimg = onlineimg;

    [self.headView addSubview:self.indexlabel];
    [self.indexlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(self.ML_webCycleScrollView.mas_right).mas_offset(-16);
    }];
    

//    UIView *liveV = [[UIView alloc] init];
//    liveV.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
//    [self.headView addSubview:liveV];
//    [liveV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.headView.mas_left).mas_offset(16);
//        make.bottom.mas_equalTo(self.headView.mas_bottom).mas_offset(1);
//        make.height.mas_equalTo(1);
//        make.width.mas_equalTo(ML_ScreenWidth-32);
//    }];
    
    
        
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = self.userDict[@"name"];
    nameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#ffffff"];
    [self.headView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView.mas_left).mas_offset(16);
        make.top.mas_equalTo(280*mHeightScale);
    }];
    self.nameLabel = nameLabel;
    
    
    UIButton *agebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agebtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
//    agebtn.layer.cornerRadius = 7;
    agebtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [agebtn setImage:[UIImage imageNamed:@"female"] forState:UIControlStateNormal];
    [agebtn setImage:[UIImage imageNamed:@"male"] forState:UIControlStateSelected];
//    agebtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:151/255.0 blue:151/255.0 alpha:1.0].CGColor;
    [agebtn setTitleColor:[UIColor colorWithHexString:@"#FF458E"] forState:UIControlStateNormal];
    [agebtn setTitleColor:[UIColor colorWithHexString:@"#4DA6FF"] forState:UIControlStateSelected];
    [self.headView addSubview:agebtn];
    [agebtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(bookimg.mas_right).mas_offset(12);
//        make.centerY.mas_equalTo(idnameLabel.mas_centerY);
        make.left.mas_equalTo(nameLabel.mas_right).offset(2);
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.width.mas_equalTo(40*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    self.agebtn = agebtn;
    
    
    
    
    
    
    UIImageView *statusimg = [[UIImageView alloc]init];
    statusimg.image = [UIImage imageNamed:@"isreal"];
    statusimg.hidden = YES;
    [self.headView addSubview:statusimg];
    self.statusimg = statusimg;
    [statusimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agebtn.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(32);
    }];
    
    
    UIImageView *onlineimg = [[UIImageView alloc]init];
    [self.headView addSubview:onlineimg];
    [onlineimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32*mWidthScale);
        make.height.mas_equalTo(12*mHeightScale);
        make.left.mas_equalTo(statusimg.mas_right).mas_offset(16*mWidthScale);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
    }];
    self.onlineimg = onlineimg;
    
 
    
  /*地址*/
//    UILabel *countryLabel = [[UILabel alloc] init];
//    countryLabel.text = @"国内";
//    countryLabel.font = [UIFont systemFontOfSize:11];
//    countryLabel.textColor = [UIColor colorWithHexString:@"#B2533E"];
//    countryLabel.backgroundColor = [UIColor colorWithHexString:@"#FFE4D6" alpha:0.8];
//    countryLabel.textAlignment = NSTextAlignmentCenter;
//    countryLabel.layer.cornerRadius = 4;
//    countryLabel.layer.masksToBounds = YES;
//    [self.bgview addSubview:countryLabel];
//    [countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.agebtn.mas_right).mas_offset(12);
//        make.centerY.mas_equalTo(self.agebtn.mas_centerY);
//        make.width.mas_equalTo(36);
//        make.height.mas_equalTo(14);
//    }];
//    self.countryLabel = countryLabel;
    
    
    
    
    UIButton *idbutton=[[UIButton alloc]init];
//    [idbutton setImage:kGetImage(@"ID") forState:UIControlStateNormal];
    idbutton.titleLabel.font=[UIFont systemFontOfSize:12];
    [idbutton setTitleColor:[UIColor colorWithHexString:@"8c8c8c"] forState:UIControlStateNormal];

    [self.headView addSubview:idbutton];
    [idbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(18*mHeightScale);
    }];
    

    self.idnameLabel = idbutton;
    
    UIImageView *bookimg = [[UIImageView alloc]init];
    bookimg.userInteractionEnabled = YES;
    UITapGestureRecognizer *booktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bookClick)];
    [bookimg addGestureRecognizer:booktap];
    bookimg.image = [UIImage imageNamed:@"icon_fuzhi_16_000_nor_1"];
    [self.headView addSubview:bookimg];
    [bookimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(idbutton.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(idbutton.mas_centerY);
        make.height.mas_equalTo(16*mHeightScale);
        make.width.mas_equalTo(16*mWidthScale);
    }];



    //关注状态，0-未关注 1-已关注
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusBtn setBackgroundImage:[UIImage imageNamed:@"Cfollow_NO"] forState:UIControlStateNormal];
    [focusBtn setBackgroundImage:[UIImage imageNamed:@"canclefollow"] forState:UIControlStateSelected];
    [focusBtn addTarget:self action:@selector(focuClickbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:focusBtn];
    self.focusBtn = focusBtn;
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headView.mas_right).mas_offset(-16);
        make.top.mas_equalTo(304*mHeightScale);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(68);
    }];
    
    UILabel *bbnameLabel = [[UILabel alloc]init];
    //bbnameLabel.text = @"9999粉丝 · 9999关注";
    bbnameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    bbnameLabel.textColor = [UIColor colorFromHexString:@"#8c8c8c"];
    [self.headView addSubview:bbnameLabel];
    [bbnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView.mas_left).mas_offset(16);
        make.top.mas_equalTo(bookimg.mas_bottom).mas_offset(12);
    }];
    self.bbnameLabel = bbnameLabel;

    UIView *bgview = [[UIView alloc]init];
    bgview.backgroundColor = UIColor.whiteColor;
    [self.headView addSubview:bgview];
    self.bgview = bgview;
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.headView);
        make.top.mas_equalTo(self.ML_webCycleScrollView.mas_bottom).offset(-16*mHeightScale);
    }];
    
    
//    UILabel * lianxilabel = [[UILabel alloc]init];
//    lianxilabel.text = @"与TA联系";
//    lianxilabel.hidden = ![self.tagDic[@"host"] boolValue];
//    lianxilabel.textColor = kGetColor(@"000000");
//    lianxilabel.font = [UIFont boldSystemFontOfSize:16];
//    [self.headView addSubview:lianxilabel];
//    [lianxilabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(16*mWidthScale);
//        make.top.mas_equalTo(bbnameLabel.mas_bottom).offset(15);
//        make.height.mas_equalTo(24*mHeightScale);
//    }];
    ///////////////////////等级-----------------------
    self.rangbgview = [[UIImageView alloc]init];
    [self.bgview addSubview:self.rangbgview];
    [self.rangbgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(80*mHeightScale);
    }];
    int level = [self.tagDic[@"identity"] intValue];
    switch (level) {
        case 0:
            self.rangbgview.image = kGetImage(@"noLevel");
            break;
        case 10:
            self.rangbgview.image = kGetImage(@"Group 1538");
            break;
        case 20:
            self.rangbgview.image = kGetImage(@"Group 1539");
            break;
        case 30:
            self.rangbgview.image = kGetImage(@"Group 1540");
            break;
        default:
            break;
    }
    self.rangbgview.hidden = ishost;
//    self.rangbgview.hidden = NO;
    

    UIImageView *shipinV = [[UIImageView alloc]init];
    shipinV.image = kGetImage(@"shipinBG");
    shipinV.layer.cornerRadius = 8;
    shipinV.userInteractionEnabled = YES;
    shipinV.hidden = !ishost;
//    shipinV.hidden = YES;
//    shipinV.backgroundColor = [UIColor colorWithHexString:@"#FFDAEF"];
    [self.bgview addSubview:shipinV];
//    self.wxV = wxV;
    [shipinV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(12*mHeightScale);
        make.height.mas_equalTo(52*mHeightScale);
        make.width.mas_equalTo(168*mWidthScale);
    }];
    
    UIButton *shipinMBt = [[UIButton alloc]init];
    self.shipinchargeLabel = shipinMBt;
    shipinMBt.backgroundColor = [UIColor whiteColor];
    shipinMBt.layer.cornerRadius = 10*mHeightScale;
    shipinMBt.layer.masksToBounds = YES;
    [shipinMBt setImage:kGetImage(@"shipinMlogo") forState:UIControlStateNormal];
    [shipinMBt setTitleColor:kGetColor(@"fe6291") forState:UIControlStateNormal];
    shipinMBt.titleLabel.font = [UIFont systemFontOfSize:10];
    [shipinV addSubview:shipinMBt];
    [shipinMBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60*mWidthScale);
        make.top.mas_equalTo(24*mHeightScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    
    UIButton *wxV2 = [[UIButton alloc]init];
    [wxV2 setBackgroundImage:kGetImage(@"vxBg") forState:UIControlStateNormal];
    [wxV2 addTarget:self action:@selector(chBtnkanClick) forControlEvents:UIControlEventTouchUpInside];
    wxV2.layer.cornerRadius = 8;
    wxV2.hidden = YES;
    if (ishost) {
        wxV2.hidden = ![self.userDict[@"wxShow"] boolValue];
    }
//
//    wxV2.backgroundColor = [UIColor colorWithHexString:@"#E8FDE1"];
    [self.bgview addSubview:wxV2];
//    self.wxV = wxV;
    [wxV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(shipinV.mas_top);
        make.height.mas_equalTo(52*mHeightScale);
        make.width.mas_equalTo(168*mWidthScale);
    }];
    self.chBtn = wxV2;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = kGetColor(@"f6f6f6");
    [self.bgview addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(shipinV.mas_bottom).offset(20*mHeightScale);
        make.height.mas_equalTo(6*mHeightScale);
    }];
    lineView.hidden = !ishost;
    
    UIView *categoryBack = [[UIView alloc]initWithFrame:CGRectZero];
    categoryBack.backgroundColor = UIColor.whiteColor;
    categoryBack.layer.cornerRadius = 16*mHeightScale;
    categoryBack.layer.masksToBounds = YES;
    [self.bgview addSubview:categoryBack];
    if (ishost) {
        [categoryBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(lineView.mas_bottom);
            make.height.mas_equalTo(76*mHeightScale);
        }];
    }else{
        [categoryBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(60*mHeightScale);
            make.height.mas_equalTo(76*mHeightScale);
        }];
    }
    
    
    
    
    
    self.categoryView = [[JXCategoryDotView alloc]init];
    
//    self.categoryView.titles = @[Localized(@"魅力榜", nil), Localized(@"邀请榜", nil)];
    self.categoryView.titles = @[Localized(@"资料", nil), Localized(@"动态", nil), Localized(@"荣誉", nil)];
    
    self.categoryView.titleColor = [UIColor colorFromHexString:@"#666666"];
//    self.categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.categoryView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.categoryView.cellSpacing = 28;

    self.categoryView.titleLabelZoomEnabled = YES;
    
    self.categoryView.titleLabelStrokeWidthEnabled = YES;
    self.categoryView.titleLabelSelectedStrokeWidth = -4;
    self.categoryView.titleSelectedColor = [UIColor blackColor];//[self.way isEqualToString:@"4"]?[UIColor colorFromHexString:@"#7143EE"]:[UIColor colorFromHexString:@"#CF4EE5"];
    self.categoryView.titleColorGradientEnabled = NO;
    self.categoryView.titleLabelZoomScale = 1.08;
    self.categoryView.titleLabelVerticalOffset = 0;
    self.categoryView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8" alpha:1];
    self.categoryView.layer.cornerRadius = 10*mWidthScale;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 32*mHeightScale;
    backgroundView.indicatorWidth = 100*mWidthScale;
    backgroundView.indicatorColor = kGetColor(@"ffffff");
    backgroundView.indicatorCornerRadius = 8*mHeightScale;
    self.categoryView.indicators = @[backgroundView];
    self.categoryView.delegate = self;
    [categoryBack addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.height.mas_equalTo(36*mHeightScale);
        make.top.mas_equalTo(20*mHeightScale);
//        make.centerY.mas_equalTo(SSL_StatusBarHeight + 22);
    }];
    
    
    
    
    
  
    
//    UILabel *irrbbnameLabel = [[UILabel alloc]init];
//    irrbbnameLabel.textAlignment = NSTextAlignmentLeft;
//    irrbbnameLabel.text = Localized(@"最新动态", nil);
//    irrbbnameLabel.userInteractionEnabled = YES;
//    [irrbbnameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(irrbbnameLabelTap)]];
//    irrbbnameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
//    irrbbnameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
//    [self.bgview addSubview:irrbbnameLabel];
//    self.irrbbnameLabel = irrbbnameLabel;
//    [irrbbnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.headView.mas_left).mas_offset(16);
//        make.width.mas_equalTo(ML_ScreenWidth - 32);
//        if ([self.tagDic[@"identity"] intValue] != 0) {
//            make.top.mas_equalTo(self.rangbgview.mas_bottom).mas_offset(30);
//        } else {
//            
//            make.top.mas_equalTo(shipinV.mas_bottom).mas_offset(24);
//        }
//    }];
    
    
//    UIView *liveV2 = [[UIView alloc] init];
//    liveV2.hidden = YES;
//    liveV2.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
//    [self.bgview addSubview:liveV2];
//    [self.bgview bringSubviewToFront:liveV2];
//    [liveV2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.headView.mas_left).mas_offset(16);
//        make.width.mas_equalTo(ML_ScreenWidth - 32);
//        make.height.mas_equalTo(1);
//        if ([self.tagDic[@"identity"] intValue] != 0) {
//            make.top.mas_equalTo(self.rangbgview.mas_bottom).mas_offset(12);
//        } else {
//            
//            make.top.mas_equalTo(bbnameLabel.mas_bottom).mas_offset(14);
//        }
//    }];
    
//    UIImageView *irrowimg = [[UIImageView alloc]init];
//    irrowimg.hidden = YES;
//    irrowimg.image = [UIImage imageNamed:@"morebt"];
//    [self.bgview addSubview:irrowimg];
//    [irrowimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.headView.mas_right).mas_offset(-16);
//        make.centerY.mas_equalTo(irrbbnameLabel.mas_centerY);
//        make.height.mas_equalTo(24*mHeightScale);
//        make.width.mas_equalTo(50*mWidthScale);
//    }];
    
//    if (self.urlArray.count) {
//        
////        liveV2.hidden = NO;
////        irrowimg.hidden = NO;
//        UICollectionViewFlowLayout *headflowLayout = [[UICollectionViewFlowLayout alloc]init];
//        headflowLayout.itemSize= CGSizeMake((self.view.frame.size.width - 32) / 4, 86);
//        headflowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 0);
//        [headflowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        self.ML_headCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:headflowLayout];
//        self.ML_headCollectionView.backgroundColor = [UIColor whiteColor];
//        self.ML_headCollectionView.dataSource = self;
//        self.ML_headCollectionView.delegate = self;
//        [self.ML_headCollectionView setShowsHorizontalScrollIndicator:NO];
//        [self.ML_headCollectionView registerClass:[ML_hotsmessageCollectionViewCell class] forCellWithReuseIdentifier:ident];
//        //添加到视图中
//        [self.headView addSubview:self.ML_headCollectionView];
//        [self.ML_headCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.bgview.mas_left).mas_offset(0);
//            make.right.mas_equalTo(self.bgview.mas_right).mas_offset(0);
//            make.top.mas_equalTo(self.irrbbnameLabel.mas_bottom).mas_offset(20);
//            make.bottom.mas_equalTo(self.bgview.mas_bottom).mas_offset(-10);
//         }];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ML_headCollectionViewClick)];
//        [self.ML_headCollectionView addGestureRecognizer:tap];
////
////        UIView *liveV2 = [[UIView alloc] initWithFrame:CGRectMake(16, 0, ML_ScreenWidth - 32, 1)];
////        liveV2.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
////        [self.ML_headCollectionView addSubview:liveV2];
//        
//    } else {
//        self.irrbbnameLabel.hidden = YES;
//    }
    
    
}

- (void)dashanClick:(UIButton *)btn{
//    [SVProgressHUD show];
    kSelf;
    NSString *token = [ML_AppUserInfoManager sharedManager].currentLoginUserData.token;
    ML_sayHelloApi *api = [[ML_sayHelloApi alloc] initWithtoken:token toUserId:self.userId extra:[self jsonStringForDictionary]];
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

- (void)irrbbnameLabelTap
{
    NSLog(@"点击最新动态==%@", self.urlArray);
    MLMineDynameicViewController *vc = [[MLMineDynameicViewController alloc] init];
    vc.userId = self.userId;
    vc.userName=self.nameLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)bookClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@", self.userDict[@"userId"]];
    [self showMessage:Localized(@"复制成功", nil)];
}
#pragma mark -----关注------

-(void)focuClickbtn:(UIButton *)btn{
    if (btn.selected == NO) {
        [self giveMLFocusApi:@"1"];
    }else{
        [self giveMLFocusApi:@"0"];
    }
}

-(void)giveMLFocusApi:(NSString *)indexstr{
    MLFocusApi *api = [[MLFocusApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary] toUserId:_userId type:indexstr];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"关注接口----%@ %@",response.data,response.msg);
        NSInteger fansNo = [self.userDict[@"fansNum"] integerValue]?:0;
      
        if ([indexstr isEqualToString:@"1"]) {
            self.focusBtn.selected = YES;
            fansNo++;
        }else{
            self.focusBtn.selected = NO;
            fansNo--;
        }
        [self.userDict setValue:@(fansNo) forKey:@"fansNum"];
        NSString * fensi = [NSString stringWithFormat:@"%ld",fansNo];
        NSString *guanzhu = [NSString stringWithFormat:@"%@",self.userDict[@"foucsNum"]];;
        NSString *string = [NSString stringWithFormat:@"%@ %ld  %@ %ld",Localized(@"粉丝", nil),fansNo,Localized(@"关注", nil),[self.userDict[@"foucsNum"]integerValue]?:0];
        NSMutableAttributedString *attributeS = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange range1 = [string rangeOfString:fensi];
        NSRange range2 = [string rangeOfString:guanzhu];
        [attributeS addAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14],NSForegroundColorAttributeName:kGetColor(@"ffffff")} range:range1];
        [attributeS addAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14],NSForegroundColorAttributeName:kGetColor(@"ffffff")} range:range2];
        self.bbnameLabel.attributedText = attributeS;
        [self.tablview reloadData];
        } error:^(MLNetworkResponse *response) {
            [SVProgressHUD showErrorWithStatus:response.msg];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
}

#pragma mark -----UICollectionView------------

//组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//列
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlArray.count;
}

//子View
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ML_hotsmessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if ([self.urlArray[indexPath.row] containsString:@".mp4"]) {
        cell.imageView.image = [UIImage imageNamed:@"人气推荐占位图"];
        UIImage *img = [self getVideoThumbnailWithUrl:kGetUrlPath(self.urlArray[indexPath.row]) second:1];
        if (img) {
            
            cell.imageView.image = img;
        }
    } else {
        [cell.imageView sd_setImageWithURL:kGetUrlPath(self.urlArray[indexPath.row]) placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    }
    
    return cell;
 }


- (UIImage *)getVideoThumbnailWithUrl:(NSURL *)videoUrl second:(CGFloat)second
{
    if (!videoUrl)
    {
        NSLog(@"WARNING:videoUrl为空");
        return nil;
    }
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:videoUrl];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

    BOOL getThumbnail = YES;
    if (getThumbnail)
    {
    CGFloat width = [UIScreen mainScreen].scale * k_THUMBNAIL_IMG_WIDTH;
    imageGenerator.maximumSize = CGSizeMake(width, width);
    }
    NSError *error = nil;
    CMTime time = CMTimeMake(second,k_FPS);
    CMTime actucalTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
    NSLog(@"ERROR:获取视频图片失败,%@",error.domain);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    NSLog(@"imageWidth=%f,imageHeight=%f",image.size.width,image.size.height);
    CGImageRelease(cgImage);
    return image;
}


#pragma mark -----tableView-------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.index == 0) {
        return 4;
    }else if(self.index == 1){
        return self.dynamicdata.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 2) {
            ML_HostMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
              if(cell == nil) {
                  cell =[[ML_HostMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                  cell.backgroundColor = [UIColor whiteColor];
              }
            cell.listArr = self.giftListArr;
            
            cell.tnameLabel.hidden = !self.giftListArr.count;
            cell.tnameLabel.text = [self.userDict[@"host"] boolValue]?Localized(@"收到礼物", nil):@"送出礼物";
            
            
            return cell;
    }
    
    if (self.index == 1) {
        ML_CommunityCell *cell = [ML_CommunityCell ML_cellWithTableView:tableView];
        NSDictionary *dic =  self.dynamicdata[indexPath.row];
        ML_CommunityModel *model0 =  [ML_CommunityModel mj_objectWithKeyValues:dic];
        model0.username = dic[@"name"];
        model0.isLike = dic[@"like"];
        model0.index = indexPath.row;
        model0.likesCount = dic[@"likeCount"];
        model0.createTime = dic[@"aduitTime"];
        model0.location = @"";
        cell.ML_Model = model0;
        return cell;
    }
    
    

    if(indexPath.row == 0){
        ML_HostGexingTableViewCell* topcell = [tableView dequeueReusableCellWithIdentifier:@"topcell"];
              if(topcell == nil) {
                  topcell =[[ML_HostGexingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topcell"];
                  topcell.backgroundColor = [UIColor whiteColor];
              }
        topcell.adrrnameStr = self.userDict[@"persionSign"];
            return topcell;
    }else if(indexPath.row == 1){
        if (kisCH) {
            HXTagsCell *hxcell = [tableView dequeueReusableCellWithIdentifier:@"cellId_1"];
            if (!hxcell) {
                hxcell = [[HXTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId_1"];
                hxcell.backgroundColor = [UIColor whiteColor];
            }
            hxcell.namelabel.text = Localized(@"基本资料", nil);
            hxcell.tags = self.userArray;
            return hxcell;
        } else {
            ML_HostMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
              if(cell == nil) {
                  cell =[[ML_HostMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                  cell.backgroundColor = [UIColor whiteColor];
              }
            cell.listArr = self.giftListArr;
            
            cell.tnameLabel.hidden = !self.giftListArr.count;
            cell.tnameLabel.text = [self.userDict[@"host"] boolValue]?Localized(@"收到礼物", nil):@"送出礼物";
            
            return cell;
        }
    } else if (indexPath.row == 2 || indexPath.row == 3){
        
        HXTagsCell *hxcell = [tableView dequeueReusableCellWithIdentifier:@"cellId_2"];
        if (!hxcell) {
            hxcell = [[HXTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId_2"];
            hxcell.backgroundColor = [UIColor whiteColor];
        }
        hxcell.namelabel.text = indexPath.row == 2?Localized(@"个人标签", nil):Localized(@"印象标签", nil);
        hxcell.tags2 = indexPath.row == 2?self.tags:self.yinTags;
        
        hxcell.namelabel.hidden = indexPath.row == 2?!self.tags.count:!self.yinTags.count;
        
        return hxcell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 1) {
        ML_CommunityCell * cell = (ML_CommunityCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

        return cell.cellHeight;
    }
    
    if (self.index == 2) {
        if (!self.giftListArr.count) return 0;
        ML_HostMessageTableViewCell * cell = (ML_HostMessageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

        return cell.cellHeight+12;
    }
    
    
    
    
    if (indexPath.row == 0) {
        if (![self.userDict[@"persionSign"] length]) return 0;
        ML_HostGexingTableViewCell * cell = (ML_HostGexingTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return CGRectGetMaxY(cell.adrrnameLabel.frame) + 10;
        
    }else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
        
        if (!self.tags.count && indexPath.row == 2) return 0;
        if (!self.yinTags.count && indexPath.row == 3) return 0;
        
//        float height = [HXTagsCell getCellHeightWithTags:self.userArray layout:self.layout tagAttribute:nil width:tableView.frame.size.width];
        HXTagsCell * cell = (HXTagsCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        float height = 190;
          return cell.cellHeight+12;
    }
    else if(indexPath.row == 4){
        if (!self.giftListArr.count) return 0;
        ML_HostMessageTableViewCell * cell = (ML_HostMessageTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];

        return cell.cellHeight+12;
    }
    else{
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
    }
}

- (void)ML_headCollectionViewClick
{
    
    [self irrbbnameLabelTap];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat minAlphaOffset = -(ML_NavViewHeight);
  CGFloat maxAlphaOffset = 300;
  CGFloat offset = scrollView.contentOffset.y;
  CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
  self.ML_navAlphaView.alpha = alpha<0.25?0:alpha;
    
    if (alpha < 0.4) {
        
        [self.ML_backBtn setImage:[UIImage imageNamed:@"icon_back_24_FFF_nor"] forState:UIControlStateNormal];
        [self ML_addNavRightBtnWithTitle:nil image:kGetImage(@"icon_fenxiang_24_FFF_nor")];
    } else {
        
        // 黑
        [self.ML_backBtn setImage:kGetImage(@"icon_back_24_FFF_nor_1") forState:UIControlStateNormal];
        [self ML_addNavRightBtnWithTitle:nil image:kGetImage(@"icon_sessionlist_more_normal")];
    }
    
}


@end
