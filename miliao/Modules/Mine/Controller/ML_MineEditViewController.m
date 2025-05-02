//
//  ML_MineEditViewController.m
//  miliao
//
//  Created by apple on 2022/9/15.
//

#import "ML_MineEditViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_FocusBottomTableViewCell.h"
#import "ML_MineHeadTableViewCell.h"
#import "ML_MineNameTableViewCell.h"
#import "ML_MineSexSelectTableViewCell.h"
#import "ML_MinegexingTableViewCell.h"
#import "ML_WxNumVC.h"
#import <SDWebImage/SDWebImage.h>
#import "MLMineNmaechangeViewController.h"
#import "MLMineXingxiangTableViewCell.h"
#import "MLMineXingxiangViewController.h"
#import "BRPickerView.h"
#import "MLMineTextViewTableViewCell.h"
#import "UIViewController+MLHud.h"
#import "TZImagePickerController.h"
#import "MLGetUSSLibApi.h"
#import "MLGetEmLibApi.h"
#import "MLGetProLibApi.h"
#import "MLGetAreaLibApi.h"
#import "MLGetAuditInfoApi.h"
#import "MLSaveAuditInfoApi.h"
#import "UIImage+ML.h"
#import "ML_getUploadToken.h"
#import "YBImageBrowser.h"
#import "YBIBVideoData.h"
#import "ML_ToolViewHandlerTwo.h"
#import "RSKImageCropper.h"
#import "UIAlertController+MLBlock.h"
#import "VideoObj.h"
#import "ML_editeImageCollectionViewCell.h"

#define k_THUMBNAIL_IMG_WIDTH 100//缩略图大小
#define k_FPS 1//一秒想取多少帧

@interface ML_MineEditViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *imgBtn;
@property (nonatomic,assign)BOOL isGai;
//@property(nonatomic,strong)UITableView *ML_showTableview;
@property (nonatomic,strong)UIView *ML_headview;
@property (nonatomic,strong)UIImage *headimg;
@property (nonatomic,copy)NSString *namestr;
@property (nonatomic,assign)NSInteger isFirst_index;
@property (nonatomic,copy)NSString *sexstr;
@property (nonatomic,copy)NSString *birthdaystr;
@property (nonatomic,copy)NSString *phonestr;
@property (nonatomic,copy)NSString *wxStr;
@property (nonatomic,copy)NSString *persionSignstr;
@property (nonatomic,copy)NSString *genderstr;
@property (nonatomic,copy)NSString *iconstr;
@property (nonatomic,strong)NSMutableArray *potos;
@property (nonatomic,copy)NSString *persionVideo;
@property (nonatomic,copy)NSString *video;
@property (nonatomic,copy)NSString *height;
@property (nonatomic,copy)NSString *persionGif;
@property (nonatomic,copy)NSString *weight;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSDictionary *cityDic;
@property (nonatomic,copy)NSDictionary *proDic;
@property (nonatomic,copy)NSDictionary *emDic;
@property (nonatomic,copy)NSDictionary *ussDic;
@property (nonatomic,copy)NSString *work;
@property (nonatomic,copy)NSString *love;
@property (nonatomic,copy)NSString *xingzuo;
@property (nonatomic,strong)NSMutableArray *btnArr;
@property (nonatomic,strong)NSMutableArray *labelArray;
@property (nonatomic,strong)NSMutableArray *phoArr;
@property (nonatomic,strong)NSMutableArray *USSdata;
@property (nonatomic,strong)NSMutableArray *qinggandata;
//@property (nonatomic,strong)NSMutableArray *lableLib;
@property (nonatomic,strong)NSMutableArray *workdata;
@property (nonatomic,strong)NSMutableArray *cityData;
@property (nonatomic,strong)NSDictionary *userDict;
@property (nonatomic,assign)BOOL isIcon;
//@property (nonatomic,copy)NSString *shipingStr;
@property (nonatomic,copy)NSString *stytype;
@property (nonatomic,strong)UIButton *bianqianbtn;
@property (nonatomic,strong)NSArray *weightArray;
@property (nonatomic,strong)NSArray *heightArray;
@property (nonatomic,strong)UICollectionView *topCollectionView;
@property (nonatomic,strong)UIButton *iconBt;
@end

@implementation ML_MineEditViewController

-(NSArray *)weightArray{
    if (_weightArray == nil) {
        _weightArray = @[@"35kg",@"36kg",@"37kg",@"38kg",@"39kg",@"40kg",@"41kg",@"42kg",@"43kg",@"44kg",@"45kg",@"46kg",@"47kg",@"48kg",@"49kg",@"50kg",@"51kg",@"52kg",@"53kg",@"54kg",@"55kg",@"56kg",@"57kg",@"58kg",@"59kg",@"60kg",@"61kg",@"62kg",@"63kg",@"64kg",@"65kg",@"66kg",@"67kg",@"68kg",@"69kg",@"70kg",@"71kg",@"72kg",@"73kg",@"74kg",@"75kg",@"76kg",@"77kg",@"78kg",@"79kg",@"80kg",@"81kg",@"82kg",@"83kg",@"84kg",@"85kg",@"86kg",@"87kg",@"88kg",@"89kg",@"90kg",@"91kg",@"92kg",@"93kg",@"94kg",@"95kg",@"96kg",@"97kg",@"98kg",@"99kg",@"100kg",@"101kg",@"102kg",@"103kg",@"104kg",@"105kg",@"106kg",@"107kg",@"108kg",@"109kg",@"110kg",@"111kg",@"112kg",@"113kg",@"114kg",@"115kg",@"116kg",@"117kg",@"118kg",@"119kg",@"120kg"];
    }
    return _weightArray;
}
-(NSArray *)heightArray{
    if (_heightArray == nil) {
        _heightArray = @[@"135cm",@"136cm",@"137cm",@"138cm",@"139cm",@"140cm",@"141cm",@"142cm",@"143cm",@"144cm",@"145cm",@"146cm",@"147cm",@"148cm",@"149cm",@"150cm",@"151cm",@"152cm",@"153cm",@"154cm",@"155cm",@"156cm",@"157cm",@"158cm",@"159cm",@"160cm",@"161cm",@"162cm",@"163cm",@"164cm",@"165cm",@"166cm",@"167cm",@"168cm",@"169cm",@"170cm",@"171cm",@"172cm",@"173cm",@"174cm",@"175cm",@"176cm",@"177cm",@"178cm",@"179cm",@"180cm",@"181cm",@"182cm",@"183cm",@"184cm",@"185cm",@"186cm",@"187cm",@"188cm",@"189cm",@"190cm",@"191cm",@"192cm",@"193cm",@"194cm",@"195cm",@"196cm",@"197cm",@"198cm",@"199cm",@"200cm"];
    }
    return _heightArray;
}

-(NSMutableArray *)labelArray{
    if (_labelArray == nil) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

//-(NSMutableArray *)lableLib{
//    if (_lableLib == nil) {
//        _lableLib = [NSMutableArray array];
//    }
//    return _lableLib;
//}

-(UIView *)ML_headview{
    if (_ML_headview == nil) {
        _ML_headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.type?250*mHeightScale:374*mHeightScale)];
        _ML_headview.backgroundColor = UIColor.clearColor;
    }
    return _ML_headview;
}
-(NSMutableArray *)workdata{
    if (_workdata == nil) {
        _workdata = [NSMutableArray array];
    }
    return _workdata;
}
-(NSMutableArray *)btnArr{
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
-(NSMutableArray *)potos{
    if (_potos == nil) {
        _potos = [NSMutableArray array];
    }
    return _potos;
}
-(NSMutableArray *)cityData{
    if (_cityData == nil) {
        _cityData = [NSMutableArray array];
    }
    return _cityData;
}


-(NSMutableArray *)qinggandata{
    if (_qinggandata == nil) {
        _qinggandata = [NSMutableArray array];
    }
    return _qinggandata;
}


-(NSMutableArray *)USSdata{
    if (_USSdata == nil) {
        _USSdata = [NSMutableArray array];
    }
    return _USSdata;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self giveML_getTypeHostsApi];
//    if (@available(iOS 11.0, *)) {
//        
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
//        
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)handleSwipeFrom
{
    [self ML_backClickklb_la];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isEnablePanGesture = NO;
    self.view.backgroundColor = kGetColor(@"f8f8f8");
//    self.navigationItem.title = Localized(@"基本信息", nil);
//    [self ML_setUpCustomNavklb_la];
    self.ML_titleLabel.text = self.type?@"基础身份认证":Localized(@"基本信息", nil);
    self.ML_navView.backgroundColor = UIColor.clearColor;
    self.isFirst_index = -1;
    self.genderstr = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender?:@"";
    [self setupUI];
    
    self.height = @"";
    self.weight = @"";
    self.city = @"";
    self.work = @"";
    self.love = @"";
    self.xingzuo = @"";
    

    [self giveMLGetUSSLibApi];
    [self giveMLGetEmLibApi];
    [self giveMLGetProLibApi];
    [self giveMLGetAreaLibApi];
    [self giveMLGetAuditInfoApi];
     
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reGif:) name:@"reGif" object:nil];

}

- (void)reGif:(NSNotification *)nt
{
    self.persionGif = nt.object;
    
}


//获取认证信息----
-(void)giveMLGetAuditInfoApi{
    MLGetAuditInfoApi *api = [[MLGetAuditInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    kSelf;
    [SVProgressHUD show];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        [weakself.labelArray removeAllObjects];
        NSLog(@"获取认证信息--%@",response.data);
        weakself.wxStr = response.data[@"auditInfo"][@"wxNo"];
        weakself.userDict = response.data[@"auditInfo"];
        weakself.persionGif = weakself.userDict[@"persionGif"];
        weakself.persionSignstr = weakself.userDict[@"persionSign"];
        weakself.cityDic = [weakself.userDict[@"city"] isKindOfClass:[NSDictionary class]]?weakself.userDict[@"city"]:@{};
        weakself.proDic = [weakself.userDict[@"pro"] isKindOfClass:[NSDictionary class]]?weakself.userDict[@"pro"]:@{};
        weakself.emDic = [weakself.userDict[@"em"] isKindOfClass:[NSDictionary class]]?weakself.userDict[@"em"]:@{};
        weakself.ussDic = [weakself.userDict[@"uss"] isKindOfClass:[NSDictionary class]]?weakself.userDict[@"uss"]:@{};
        weakself.height = [NSString stringWithFormat:@"%@", weakself.userDict[@"height"]];
        weakself.weight = [NSString stringWithFormat:@"%@", weakself.userDict[@"weight"]];
        weakself.namestr = weakself.userDict[@"name"];
        weakself.sexstr = [NSString stringWithFormat:@"%@",weakself.userDict[@"gender"]];
        weakself.birthdaystr = weakself.userDict[@"birthday"];
        weakself.phonestr = weakself.userDict[@"phone"];
        weakself.potos = [NSMutableArray arrayWithArray:weakself.userDict[@"potos"]];
        weakself.persionVideo = weakself.userDict[@"persionVideo"]?:@"";
        weakself.video = weakself.userDict[@"video"]?:@"";
        weakself.iconstr = weakself.userDict[@"icon"];
        
        [weakself.userDict[@"lables"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakself.labelArray addObject:dict];
        }];
        
        
        NSDate *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"info_edit"];
        NSDictionary *muPDic = [weakself returnDictionaryWithDataPath:data];
        if ([muPDic[@"labelArray"] count]) {
            weakself.labelArray = muPDic[@"labelArray"];
        }
        if ([muPDic[@"xingzuo"] length]) {
            weakself.xingzuo = muPDic[@"xingzuo"];
        }
        if ([muPDic[@"potos"] count]) {
            weakself.potos = muPDic[@"potos"];
        }
        if ([muPDic[@"persionVideo"] length] || [muPDic[@"persionVideo"] isEqualToString:@""]) {
            weakself.persionVideo = muPDic[@"persionVideo"];
        }
        if ([muPDic[@"work"] length]) {
            weakself.work = muPDic[@"work"];
        }
        if ([muPDic[@"love"] length]) {
            weakself.love = muPDic[@"love"];
        }
        if ([muPDic[@"city"] length]) {
            weakself.city = muPDic[@"city"];
        }
        if ([muPDic[@"height"] length]) {
            weakself.height = muPDic[@"height"];
        }
        if ([muPDic[@"weight"] length]) {
            weakself.weight = muPDic[@"weight"];
        }
        if ([muPDic[@"videpath"] length]) {
            weakself.videpath = muPDic[@"videpath"];
        }
        if ([muPDic[@"namestr"] length]) {
            weakself.namestr = muPDic[@"namestr"];
        }
        if ([muPDic[@"phonestr"] length]) {
            weakself.phonestr = muPDic[@"phonestr"];
        }
        if ([muPDic[@"persionSignstr"] length]) {
            weakself.persionSignstr = muPDic[@"persionSign"];
        }
        if ([muPDic[@"birthdaystr"] length]) {
            weakself.birthdaystr = muPDic[@"birthdaystr"];
        }
        if ([muPDic[@"sexstr"] length]) {
            weakself.sexstr = muPDic[@"sexstr"];
        }
//        if ([muPDic[@"shipingStr"] length]) {
//            weakself.shipingStr = muPDic[@"shipingStr"];
//        }
//        if (muPDic[@"coverImage"]) {
//            weakself.coverImage = muPDic[@"coverImage"];
//        }
        
        [weakself ML_setupHeadview1];
        [weakself.tableView reloadData];
    } error:^(MLNetworkResponse *response) {
        [weakself.navigationController popViewControllerAnimated:YES];
        kplaceToast(@"请求失败，请重试！");
    } failure:^(NSError *error) {
        [weakself.navigationController popViewControllerAnimated:YES];
        kplaceToast(@"请求失败，请重试！");
    }];
}

//xingzuo
-(void)giveMLGetUSSLibApi{
    MLGetUSSLibApi *api = [[MLGetUSSLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    kSelf;
    [SVProgressHUD show];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        kSelf2;
        [response.data[@"uusLib"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakself2.USSdata addObject:dict];
            
        }];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

//qinggan
-(void)giveMLGetEmLibApi{
    MLGetEmLibApi *api = [[MLGetEmLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    kSelf;
    [SVProgressHUD show];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        kSelf2;
        [response.data[@"emLib"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakself2.qinggandata addObject:dict];
        }];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

//zhiye
-(void)giveMLGetProLibApi{
    MLGetProLibApi *api = [[MLGetProLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    kSelf;
    [SVProgressHUD show];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        kSelf2;
        [response.data[@"proLib"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakself2.workdata addObject:dict];
    }];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

//chengshi
-(void)giveMLGetAreaLibApi{
    MLGetAreaLibApi *api = [[MLGetAreaLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    kSelf;
    [SVProgressHUD show];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        [weakself.cityData addObjectsFromArray:response.data[@"areaLibToCity"]];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

-(void)setupUI{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.layer.backgroundColor = kZhuColor.CGColor;
//    btn.layer.cornerRadius = 25;
    [btn setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
    NSDate *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"info_edit"];
    NSDictionary *muPDic = [self returnDictionaryWithDataPath:data];
    if (muPDic) {
        [btn setTitle:Localized(@"提交", nil) forState:UIControlStateNormal];
    } else {
        [btn setTitle:Localized(@"完成", nil) forState:UIControlStateNormal];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    kSelf;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakself.view.mas_bottom).mas_offset(-SSL_TabbarMLMargin);
        make.left.mas_equalTo(weakself.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(weakself.view.mas_right).mas_offset(-16);
        make.height.mas_equalTo(53);
    }];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.ML_headview;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(weakself.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(weakself.view.mas_top);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-10);
    }];
    
}

-(void)ML_setupHeadview{
    [self.btnArr removeAllObjects];
    
    UIButton *covebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    covebtn.imageView.hidden = YES;
    [covebtn addTarget:self action:@selector(addImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [covebtn setBackgroundImage:[UIImage imageNamed:@"Slice 42"] forState:UIControlStateNormal];
    covebtn.contentMode = UIViewContentModeScaleAspectFill;
    covebtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    covebtn.layer.cornerRadius = 8;
    covebtn.layer.masksToBounds = YES;
    covebtn.tag = 0;
    covebtn.imageView.tag = 101;
    [self.ML_headview addSubview:covebtn];
    [self.btnArr addObject:covebtn];
    [covebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_headview.mas_left).mas_offset(4);
        make.top.mas_equalTo(self.ML_headview.mas_top).mas_offset(15);
        make.width.height.mas_equalTo(244);
    }];
    
    for (UIImageView *view in covebtn.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(219, 0, 25, 25)];
    [btn1 addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.hidden = YES;
    [btn1 setBackgroundImage:kGetImage(@"Slice 5") forState:UIControlStateNormal];
    [covebtn addSubview:btn1];
    
    for (UIButton *btn in self.ML_headview.subviews) {
        if (btn.tag == 1008) {
            [btn removeFromSuperview];
            break;
        }
    }
    UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(4, 15, 53, 28)];
    btn0.tag = 1008;
    if (kisCH) {
        [btn0 setBackgroundImage:[UIImage imageNamed:@"Slice 44"] forState:UIControlStateNormal];
    } else {
        btn0.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn0 setTitle:Localized(@"封面", nil) forState:UIControlStateNormal];
        [btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn0.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        btn0.layer.cornerRadius = 14;
        btn0.layer.masksToBounds = YES;
        btn0.layer.maskedCorners = kCALayerMaxXMaxYCorner|kCALayerMinXMinYCorner; // 指定圆角
    }
    
    [self.ML_headview addSubview:btn0];
    
    UIButton *topbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topbtn.tag = 1;
    topbtn.imageView.tag = 101;
    [topbtn addTarget:self action:@selector(addImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topbtn setBackgroundImage:[UIImage imageNamed:@"Slice 43"] forState:UIControlStateNormal];
    topbtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    topbtn.layer.cornerRadius = 8;
    topbtn.layer.masksToBounds = YES;
    [self.ML_headview addSubview:topbtn];
    [self.btnArr addObject:topbtn];
    [topbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(covebtn.mas_right).mas_offset(3);
        make.top.mas_equalTo(covebtn.mas_top).mas_offset(0);
        make.right.mas_equalTo(self.ML_headview.mas_right).mas_offset(-4);
        make.bottom.mas_equalTo(covebtn.mas_centerY).mas_offset(-2);
    }];
    
    for (UIImageView *view in topbtn.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:kGetImage(@"Slice 5") forState:UIControlStateNormal];
    btn2.hidden = YES;
    [topbtn addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topbtn.mas_right).mas_offset(0);
        make.top.mas_equalTo(topbtn.mas_top).mas_offset(0);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(28);
    }];
    
    UIButton *bottombtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottombtn.tag = 2;
    bottombtn.imageView.tag = 101;
    [bottombtn addTarget:self action:@selector(addImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottombtn setBackgroundImage:[UIImage imageNamed:@"Slice 43"] forState:UIControlStateNormal];
    bottombtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    bottombtn.layer.cornerRadius = 8;
    bottombtn.layer.masksToBounds = YES;
    [self.ML_headview addSubview:bottombtn];
    [self.btnArr addObject:bottombtn];
    [bottombtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(covebtn.mas_right).mas_offset(3);
        make.top.mas_equalTo(topbtn.mas_bottom).mas_offset(2);
        make.right.mas_equalTo(self.ML_headview.mas_right).mas_offset(-4);
        make.bottom.mas_equalTo(covebtn.mas_bottom).mas_offset(0);
    }];
    
    for (UIImageView *view in bottombtn.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundImage:kGetImage(@"Slice 5") forState:UIControlStateNormal];
    btn3.hidden = YES;
    [bottombtn addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottombtn.mas_right).mas_offset(0);
        make.top.mas_equalTo(bottombtn.mas_top).mas_offset(0);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.tag = 3;
    rightbtn.imageView.tag = 101;
    [rightbtn addTarget:self action:@selector(addImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"Slice 43"] forState:UIControlStateNormal];
    rightbtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    rightbtn.layer.cornerRadius = 8;
    rightbtn.layer.masksToBounds = YES;
    [self.ML_headview addSubview:rightbtn];
    [self.btnArr addObject:rightbtn];
    [rightbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottombtn.mas_bottom).mas_offset(3);
        make.right.mas_equalTo(self.ML_headview.mas_right).mas_offset(-4);
        make.width.mas_equalTo(bottombtn.mas_width);
        make.height.mas_equalTo(bottombtn.mas_height);
    }];
    
    for (UIImageView *view in rightbtn.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    
    UIButton *btn4 = [[UIButton alloc] init];
    [btn4 setBackgroundImage:kGetImage(@"Slice 5") forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn4.hidden = YES;
    [rightbtn addSubview:btn4];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightbtn.mas_right).mas_offset(0);
        make.top.mas_equalTo(rightbtn.mas_top).mas_offset(0);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
    UIButton *middlebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    middlebtn.tag = 4;
    middlebtn.imageView.tag = 101;
    [middlebtn addTarget:self action:@selector(addImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [middlebtn setBackgroundImage:[UIImage imageNamed:@"Slice 43"] forState:UIControlStateNormal];
    middlebtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    middlebtn.layer.cornerRadius = 8;
    middlebtn.layer.masksToBounds = YES;
    [self.ML_headview addSubview:middlebtn];
    [self.btnArr addObject:middlebtn];
    [middlebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(covebtn.mas_centerX).mas_offset(1.5);
        make.top.mas_equalTo(rightbtn.mas_top).mas_offset(0);
        make.right.mas_equalTo(rightbtn.mas_left).mas_offset(-3);
        make.height.mas_equalTo(rightbtn.mas_height);
    }];
    
    for (UIImageView *view in middlebtn.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    
    UIButton *btn5 = [[UIButton alloc] init];
    [btn5 setBackgroundImage:kGetImage(@"Slice 5") forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn5.hidden = YES;
    [middlebtn addSubview:btn5];
    [btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(middlebtn.mas_right).mas_offset(0);
        make.top.mas_equalTo(middlebtn.mas_top).mas_offset(0);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];

    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.tag = 5;
    leftbtn.imageView.tag = 101;
    [leftbtn addTarget:self action:@selector(addImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"Slice 43"] forState:UIControlStateNormal];
    leftbtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    leftbtn.layer.cornerRadius = 8;
    leftbtn.layer.masksToBounds = YES;
    [self.ML_headview addSubview:leftbtn];
    [self.btnArr addObject:leftbtn];
    [leftbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(covebtn.mas_left).mas_offset(0);
        make.top.mas_equalTo(rightbtn.mas_top).mas_offset(0);
        make.right.mas_equalTo(covebtn.mas_centerX).mas_offset(-1.5);
        make.height.mas_equalTo(rightbtn.mas_height);
    }];
    
    for (UIImageView *view in leftbtn.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    UIButton *btn6 = [[UIButton alloc] init];
    [btn6 setBackgroundImage:kGetImage(@"Slice 5") forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn6.hidden = YES;
    [leftbtn addSubview:btn6];
    [btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(leftbtn.mas_right).mas_offset(0);
        make.top.mas_equalTo(leftbtn.mas_top).mas_offset(0);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
    
    for (NSDictionary *dic in self.potos) {
        
        if ([dic[@"isFirst"] intValue] == 1) {
            [covebtn sd_setBackgroundImageWithURL:kGetUrlPath(dic[@"icon"]) forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached];
            btn1.hidden = NO;
        } else if ([dic[@"isFirst"] intValue] == 2) {
            [topbtn sd_setBackgroundImageWithURL:kGetUrlPath(dic[@"icon"]) forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached];
            btn2.hidden = NO;
        } else if ([dic[@"isFirst"] intValue] == 3) {
            [bottombtn sd_setBackgroundImageWithURL:kGetUrlPath(dic[@"icon"]) forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached];
            btn3.hidden = NO;
        } else if ([dic[@"isFirst"] intValue] == 4) {
            [rightbtn sd_setBackgroundImageWithURL:kGetUrlPath(dic[@"icon"]) forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached];
            btn4.hidden = NO;
        } else if ([dic[@"isFirst"] intValue] == 5) {
            [middlebtn sd_setBackgroundImageWithURL:kGetUrlPath(dic[@"icon"]) forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached];
            btn5.hidden = NO;
        } else if ([dic[@"isFirst"] intValue] == 6) {
            [leftbtn sd_setBackgroundImageWithURL:kGetUrlPath(dic[@"icon"]) forState:UIControlStateNormal placeholderImage:nil options:SDWebImageRefreshCached];
            btn6.hidden = NO;
        }
    }
    
    
    
    
    UIButton *videobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    videobtn.tag = 6;
    [videobtn addTarget:self action:@selector(videobtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [videobtn setBackgroundImage:[UIImage imageNamed:@"Slice 45"] forState:UIControlStateNormal];
    videobtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    videobtn.layer.cornerRadius = 8;
    videobtn.layer.masksToBounds = YES;
    [self.ML_headview addSubview:videobtn];
    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(covebtn.mas_left).mas_offset(0);
        make.top.mas_equalTo(leftbtn.mas_bottom).mas_offset(3);
        make.right.mas_equalTo(leftbtn.mas_right).mas_offset(0);
        make.height.mas_equalTo(82);
    }];
    
    for (UIImageView *view in videobtn.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    UIButton *btn7 = [[UIButton alloc] init];
    [btn7 addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn7 setBackgroundImage:kGetImage(@"Slice 5") forState:UIControlStateNormal];
    [btn7 addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn7.hidden = YES;
    [videobtn addSubview:btn7];
    [btn7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(videobtn.mas_right).mas_offset(0);
        make.top.mas_equalTo(videobtn.mas_top).mas_offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    
    if (self.persionVideo.length) {
        btn7.hidden = NO;
        UIImage *img = [self getVideoThumbnailWithUrl:kGetUrlPath(self.persionVideo) second:1];
        [videobtn setBackgroundImage:img forState:UIControlStateNormal];
        [videobtn setImage:kGetImage(@"icon_shiping_25_nor") forState:UIControlStateNormal];
    }
    UIImageView *dimg = [[UIImageView alloc]init];
    dimg.image = [UIImage imageNamed:@"icon_dianliang_21_nor"];
    [self.ML_headview addSubview:dimg];
    [dimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ML_headview.mas_left).mas_offset(5);
        make.top.mas_equalTo(videobtn.mas_bottom).mas_offset(15);
        make.height.width.mas_equalTo(21);
    }];

    UILabel *messagelabel = [[UILabel alloc]init];
    messagelabel.text = Localized(@"请上传个人视频,可以大大提高吸引力哦!", nil);
    messagelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    messagelabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [self.ML_headview addSubview:messagelabel];
    [messagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(dimg.mas_centerY);
        make.left.mas_equalTo(dimg.mas_right).mas_offset(7);
    }];

    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = Localized(@"基本信息", nil);
    titlelabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titlelabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.ML_headview addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dimg.mas_bottom).mas_offset(32);
        make.left.mas_equalTo(self.ML_headview.mas_left).mas_offset(16);
    }];
}


- (void)ML_setupHeadview1{
    self.view.backgroundColor = kGetColor(@"f8f8f8");
    self.ML_headview.backgroundColor = UIColor.clearColor;
    UIImageView *topBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 88*mHeightScale)];
    topBack.image = kGetImage(@"bg_top");
    [self.ML_headview addSubview:topBack];
    UIButton *iconBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [iconBt addTarget:self action:@selector(uploadIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.ML_headview addSubview:iconBt];
    self.iconBt = iconBt;
    [iconBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80*mWidthScale);
        make.centerX.mas_equalTo(self.ML_headview.mas_centerX);
        make.top.mas_equalTo(104*mHeightScale);
    }];
    iconBt.layer.cornerRadius = 40*mWidthScale;
    iconBt.layer.masksToBounds = YES;
    [iconBt sd_setBackgroundImageWithURL:kGetUrlPath(self.iconstr) forState:UIControlStateNormal placeholderImage:kGetImage(@"touxiangN")];
    UIImageView *edit = [[UIImageView alloc]initWithFrame:CGRectZero];
    edit.image = kGetImage(@"touxiangE");
    [self.ML_headview addSubview:edit];
    [edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24*mWidthScale);
        make.right.bottom.mas_equalTo(iconBt);
    }];
    if (self.type) {
        iconBt.hidden = YES;
        edit.hidden = YES;
    }
    
    UIView *collectonBack = [[UIView alloc]initWithFrame:CGRectZero];
    [self.ML_headview addSubview:collectonBack];
    collectonBack.backgroundColor = UIColor.whiteColor;
    collectonBack.layer.cornerRadius = 12*mHeightScale;
    collectonBack.layer.masksToBounds = YES;
    [collectonBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(iconBt.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(162*mHeightScale);
    }];
    
    UILabel * xingxiangLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [collectonBack addSubview:xingxiangLabel];
    [xingxiangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*mWidthScale);
        make.height.mas_equalTo(22*mHeightScale);
        make.top.mas_equalTo(16*mWidthScale);
    }];
    xingxiangLabel.text = @"形象照(2/9) 上传视频可提高吸引力            >";
    xingxiangLabel.textColor = kGetColor(@"000000");
    xingxiangLabel.font = [UIFont systemFontOfSize:16];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(100*mWidthScale, 100*mWidthScale);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 10*mWidthScale;
    self.topCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectonBack addSubview:self.topCollectionView];
    [self.topCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(xingxiangLabel.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(100*mHeightScale);
    }];
    [self.topCollectionView registerClass:[ML_editeImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.topCollectionView.delegate = self;
    self.topCollectionView.dataSource = self;
}

- (void)uploadIcon{
    self.isIcon = YES;
    [self addPicTap];
}

/*collectionDelegate*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ML_editeImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.photos = self.potos;
    cell.index = indexPath.row;
    cell.cellBolock = ^{
        self.isGai = YES;
        [self.topCollectionView reloadData];
    };
    if (indexPath.row < self.potos.count) {
        cell.dataDic = self.potos[indexPath.row];
        cell.shanBt.hidden = NO;
        cell.fengBt.hidden = NO;
    }else{
        cell.shanBt.hidden = YES;
        cell.fengBt.hidden = YES;
        cell.dataDic = nil;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self addImgBtnClick:nil];
}



- (void)shanBtnClick:(UIButton *)btn
{
    self.isGai = YES;
    
    NSInteger tag = btn.superview.tag;
    
    if (tag == 6) {
        btn.hidden = YES;
        self.persionVideo = @"";
        UIButton *sBtn = (UIButton *)btn.superview;
        [sBtn setImage:nil forState:UIControlStateNormal];
        [sBtn setBackgroundImage:[UIImage imageNamed:@"Slice 45"] forState:UIControlStateNormal];
        return;
    }
    
//    if (tag < self.potos.count) {
        
        for (NSDictionary *aaD in self.potos) {
            if ([aaD[@"isFirst"] intValue] == tag+1) {
                [self.potos removeObject:aaD];
                break;
            }
        }
        
//        [self.potos removeObjectAtIndex:tag];
//        if (tag == 0 && self.potos.count) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.potos firstObject]];
//            [dic setValue:@"1" forKey:@"isFirst"];
//            [self.potos replaceObjectAtIndex:0 withObject:dic];
//        }
        
        [self.ML_headview removeFromSuperview];
        self.ML_headview = nil;
        self.tableView.tableHeaderView = self.ML_headview;
        self.tableView.backgroundColor = UIColor.clearColor;
        [self ML_setupHeadview1];
        [self.tableView reloadData];
        
//    }
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

- (void)videobtnClick:(UIButton *)btn
{
    BOOL h = NO;
    for (UIView *view in btn.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            h = view.hidden;
            break;
        }
    }
    
    
    for (UIImageView *view in btn.subviews) {
        if ([view isKindOfClass:[UIButton class]] && !h) {

            // 网络视频
            YBIBVideoData *Data = [YBIBVideoData new];
            Data.autoPlayCount = NSUIntegerMax;
            Data.shouldHideForkButton = NO;
            Data.allowSaveToPhotoAlbum = NO;
            if (self.persionVideo) {
                Data.videoURL = kGetUrlPath(self.persionVideo?:@"");
            } else {
                Data.videoURL = kGetUrlPath(self.persionVideo);
            }
            Data.repeatPlayCount = NSUIntegerMax;
            Data.autoPlayCount = NSUIntegerMax;
            Data.projectiveView = btn;

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

            return;
        }
    }
    
    
    self.imgBtn = btn;
    
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.naviTitleColor= [UIColor blackColor];
    imagePicker.barItemTextColor= [UIColor blackColor];
    imagePicker.allowPickingVideo = YES;
    imagePicker.allowPickingImage = NO;
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.iconThemeColor = kZhuColor;
    imagePicker.oKButtonTitleColorNormal = kZhuColor;
    imagePicker.oKButtonTitleColorDisabled = UIColorHex(0xEDEDED);
//    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    // 4. 照片排列按修改时间升序
    imagePicker.sortAscendingByModificationDate = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - TZImagePickerController
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto  {
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    
    self.isGai = YES;
    
    self.imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imgBtn setBackgroundImage:coverImage forState:UIControlStateNormal];
    NSLog(@"assets.duration = %f", asset.duration);
    [self.imgBtn setImage:kGetImage(@"icon_shiping_25_nor") forState:UIControlStateNormal];
//    self.coverImage = coverImage;
    [SVProgressHUD showWithStatus:Localized(@"上传中...", nil)];
//    [TZImagePickerConfig sharedInstance].needFixComposition = YES;
//    kSelf;
//    [TZImageManager.manager getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
//        NSLog(@"info = %f", CMTimeGetSeconds(playerItem.duration));
        if ((int)asset.duration > 30) {
            [SVProgressHUD dismiss];
            kplaceToast(Localized(@"视频时长不能超过30秒哦！", nil))
            
            [self.imgBtn setBackgroundImage:kGetImage(@"Slice 45") forState:UIControlStateNormal];
            [self.imgBtn setImage:nil forState:UIControlStateNormal];
        } else {
            
            @weakify(self);
            kSelf;
            [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
                 NSData *data = [NSData dataWithContentsOfFile:outputPath];
                
                if (data) {
                    kSelf2;
                    ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc] initWithfileName:[NSString stringWithFormat:@"%@_file", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]?:@"" dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[weakself giveformatter] checkSum:[weakself shaData] extra:[self jsonStringForDictionary]];
                    [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                        NSLog(@"%@",response);
                        
                        for (UIView *view in weakself2.imgBtn.subviews) {
                            if ([view isKindOfClass:[UIButton class]]) {
                                view.hidden = NO;
                                break;
                            }
                        }
                        
                        kSelf3;
                        [ML_CommonApi  uploadImages:@[data] dic:response.data[@"sts"] block:^(NSString * _Nonnull url) {
//                            weakself3.shipingStr = url;
                            weakself3.persionVideo = url;
                            [SVProgressHUD dismiss];
                            
                            
                            [[VideoObj new] getPicGit:kGetUrlPath(url) sts:@{@"sts" : response.data[@"sts"]?:@"", @"gif" : @"1"}];
                            
                        }];
                        
                        
                    } error:^(MLNetworkResponse *response) {
                        
                        [SVProgressHUD dismiss];
                        
                        
                        [weakself2.imgBtn setImage:nil forState:UIControlStateNormal];
                        
                    } failure:^(NSError *error) {
                        
                        [weakself2.imgBtn setImage:nil forState:UIControlStateNormal];
                        [SVProgressHUD dismiss];
                        
                    }];
                    
                    
                    
                }
            } failure:^(NSString *errorMessage, NSError *error) {
                [SVProgressHUD dismiss];
                [weakself.imgBtn setImage:nil forState:UIControlStateNormal];
            }];
        }
//    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- 点击图片上传-----

-(void)addImgBtnClick:(UIButton *)btn{
    NSLog(@"点击图片上传");
    self.isIcon = NO;
    [self addPicTap];
}

- (void)sheBtnClick:(UIButton *)btn
{
    self.isGai = YES;
    
//
    for (NSDictionary *aaD in self.potos) {
        
        if ([aaD[@"isFirst"] intValue] == 1) {
            
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:aaD];
            [muDic setObject:@(btn.tag+1) forKey:@"isFirst"];
            
            [self.potos removeObject:aaD];
            [self.potos addObject:muDic];
            break;
        }

    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.potos];
    
    for (NSDictionary *aaD in arr) {

        if ([aaD[@"isFirst"] intValue] == btn.tag+1) {

            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:aaD];
            [muDic setObject:@(1) forKey:@"isFirst"];

            [arr removeObject:aaD];
//            [arr addObject:muDic];
            [arr insertObject:muDic atIndex:0];
            break;

        }
    }
    self.potos = arr;
    
//    NSMutableDictionary *dic0 = nil;
//    UIButton *firBtn = [self.btnArr firstObject];
//    for (UIButton *aBtn in firBtn.subviews) {
//        if (!aBtn.hidden && [aBtn isKindOfClass:[UIButton class]]) {
//
//            dic0 = [NSMutableDictionary dictionaryWithDictionary:[self.potos firstObject]];
//            [dic0 setValue:@"0" forKey:@"isFirst"];
//            break;
//
//        }
//
//    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.potos[btn.tag]];
//    [dic setValue:@"1" forKey:@"isFirst"];
//    [self.potos removeObjectAtIndex:btn.tag];
//    [self.potos replaceObjectAtIndex:0 withObject:dic];
//    if (dic0) {
//        [self.potos insertObject:dic0 atIndex:1];
//    }
    
    [self.ML_headview removeFromSuperview];
    self.ML_headview = nil;
    self.tableView.tableHeaderView = self.ML_headview;
    [self ML_setupHeadview1];
    [self.tableView reloadData];
    
    [btn.superview removeFromSuperview];
}

- (void)bigViewClick:(UIGestureRecognizer *)gr
{
    [gr.view removeFromSuperview];
}

- (void)addPicTap
{
    TZImagePickerController *tzCtrl = [[TZImagePickerController alloc] initWithMaxImagesCount:self.isIcon?1:(9-self.potos.count)  delegate:self];
    tzCtrl.barItemTextColor = [UIColor blackColor];
    tzCtrl.showSelectBtn = NO;
   tzCtrl.allowCrop = YES;
   tzCtrl.allowTakePicture = YES;
   tzCtrl.allowPickingOriginalPhoto = NO;
   tzCtrl.allowPickingVideo = NO;
   tzCtrl.allowTakeVideo = NO;
   tzCtrl.allowPickingGif = NO;
   tzCtrl.preferredLanguage = @"zh-Hans";
   tzCtrl.needCircleCrop = NO;//是否是圆形裁剪 YES 则是圆形裁剪 NO 方形
    tzCtrl.cropRect = CGRectMake(0, (ML_ScreenHeight - ML_ScreenWidth) / 2, ML_ScreenWidth, ML_ScreenWidth);
   tzCtrl.autoSelectCurrentWhenDone = YES;
//   tzCtrl.modalPresentationStyle = UIModalPresentationFullScreen;

   [self presentViewController:tzCtrl animated:YES completion:nil];
    
}

#pragma mark RSKImageCropViewControllerDataSource---返回图片的位置
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{

    CGRect imgRect;
       
//        if([self.type isEqualToString:@"1"]){//横图
//            imgRect = CGRectMake(20, (ML_ScreenHeight-100)/2, ML_ScreenWidth-40, 160);
//        }else{
    imgRect = CGRectMake(0, (ML_ScreenHeight - ML_ScreenWidth) / 2, ML_ScreenWidth, ML_ScreenWidth);
//        }
    return imgRect;
}

#pragma mark RSKImageCropViewControllerDataSource---返回裁剪框的位置
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect imgRect;
    
//     if([self.type isEqualToString:@"1"]){//横图
//         imgRect = CGRectMake(20, (SCREEN_HEIGHT-100)/2, KSCREEN_WIDTH-40, 160);
//     }else{
         imgRect = CGRectMake(0, (ML_ScreenHeight - ML_ScreenWidth) / 2, ML_ScreenWidth, ML_ScreenWidth);
//     }
    
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:imgRect cornerRadius:0];
    
    return path;
}


#pragma mark RSKImageCropViewControllerDataSource 返回一个图片可以移动的矩形区域
 
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    return controller.maskRect;
}

#pragma mark RSKImageCropViewControllerDelegate---图片裁剪完
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle
{
    if (self.isIcon) {
        [SVProgressHUD showWithStatus:Localized(@"上传中...", nil)];
        kSelf;
        ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc] initWithfileName:[NSString stringWithFormat:@"%@_file", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId] dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[weakself giveformatter] checkSum:[weakself shaData] extra:[weakself jsonStringForDictionary]];
        [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"%@",response);
            [ML_CommonApi  uploadImages:@[croppedImage] dic:response.data[@"sts"] block:^(NSString * _Nonnull url) {
                
                weakself.iconstr = url;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.iconBt setBackgroundImage:croppedImage forState:UIControlStateNormal];
                });
                [SVProgressHUD dismiss];
            }];
            
            
        } error:^(MLNetworkResponse *response) {
            
            [SVProgressHUD dismiss];
            
            
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismiss];
            
        }];
    }else{
        [self chuanImageWithArr:croppedImage index:1 count:1];
    }
    
    [self.navigationController popViewControllerAnimated:NO];

}
#pragma mark RSKImageCropViewControllerDelegate---取消按钮
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -- 相册回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    self.isGai = YES;
    
    if (photos.count == 1) {
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:[photos lastObject] cropMode:RSKImageCropModeCustom];

        imageCropVC.delegate = self;

        imageCropVC.dataSource=self;
        [self.navigationController pushViewController:imageCropVC animated:YES];

    } else {
        for (UIImage *image in photos) {
            [self chuanImageWithArr:image index:1 count:1];
        }

//        NSInteger i = 0;
//        for (UIButton *aBtn in self.btnArr) {
            
//            if (i == photos.count-1) {
//                for (UIButton *btn2 in self.imgBtn.subviews) {
//                    if (btn2.hidden && [btn2 isKindOfClass:[UIButton class]]) {
//                        btn2.hidden = NO;
//                        [self.imgBtn setBackgroundImage:[photos lastObject] forState:UIControlStateNormal];
//                        [self chuanImageWithArr:photos[(self.imgBtn.tag-1)] index:(self.imgBtn.tag+1) count:(photos.count-i)];
////                        NSLog(@"i==123==%d===%@", i, photos[i]);
//                        i = photos.count;
//                        break;
//                    }
//                }
//            } else {
                
//                for (UIButton *btn2 in aBtn.subviews) {
//                    if (btn2.hidden && [btn2 isKindOfClass:[UIButton class]]) {
//                        btn2.hidden = NO;
//                        [aBtn setBackgroundImage:photos[i] forState:UIControlStateNormal];
//                        [self chuanImageWithArr:photos[i] index:(aBtn.tag+1) count:(photos.count-i)];
////                        NSLog(@"i==sdf===%d===%@", i, photos[i]);
//                        i++;
//                        break;
//                    }
//                }
////            }
//            if (i == photos.count) {
//                break;
//            }
//        }
    }
}

- (void)chuanImageWithArr:(UIImage *)image index:(NSInteger)index count:(NSInteger)aCount
{
//    __block NSInteger count = aCount;
    [SVProgressHUD showWithStatus:Localized(@"上传中...", nil)];
    self.ML_headview.userInteractionEnabled = NO;
    kSelf;
    ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc] initWithfileName:[NSString stringWithFormat:@"%@_file", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]?:@"" dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        
        kSelf2;
        [ML_CommonApi  uploadImages:@[image] dic:response.data[@"sts"] block:^(NSString * _Nonnull url) {
            
//            count--;
            NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
            
            [muDic setObject:url forKey:@"icon"];
            
//            if (aCount == 0) {
//                [muDic setObject:@(weakself2.imgBtn.tag+1) forKey:@"isFirst"];
//            } else {
            NSLog(@"asdf-sdf-asdf-asdf----%d", index);
                [muDic setObject:@(index) forKey:@"isFirst"];
//            }
            if (aCount==1) {
                
                weakself2.ML_headview.userInteractionEnabled = YES;
            }

            [weakself2.potos addObject:muDic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.topCollectionView reloadData];
            });
           
            NSLog(@"urlurl====%@", url);
            
            [SVProgressHUD dismiss];
        }];
        
        
    } error:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        
        
        weakself.ML_headview.userInteractionEnabled = YES;
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
        weakself.ML_headview.userInteractionEnabled = YES;
    }];
    
    
}



-(void)saveClick{
    
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.potos];
    BOOL ma = YES;
    for (NSDictionary *dic in self.potos) {

        if ([dic[@"isFirst"] boolValue]) {
            ma = NO;
            break;
        }
        
    }
    if (ma) {
        kplaceToast(@"至少要保留一张封面图哦！");
        return;
    }
    NSString *jsonString = @"";
    if (muArr.count) {
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:muArr
                                                           options:kNilOptions
                                                             error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableArray *lableLib = [NSMutableArray array];
    for (NSDictionary *dic in self.labelArray) {
        [lableLib addObject:dic[@"id"]];
    }
    NSString *labelStr = @"";
    if (lableLib.count) {
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lableLib
                                                           options:kNilOptions
                                                             error:&error];
        labelStr = [[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    }
    if (![labelStr length]) {
        kplaceToast(@"请选择标签");
        return;
    }
    
//    if (([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]|| ![[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender boolValue]) && ![self.wxStr length] && [self.typevideo isEqualToString:Localized(@"视频认证", nil)]) {
//        kplaceToast(@"请填写微信号");
//        return;
//    }
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue] && ![self.wxStr length]) {
        kplaceToast(@"请填写微信号");
        return;
    }
    
    NSString *ussId = @"";
    if ([self.xingzuo length]) {
        for (NSDictionary *dic in self.USSdata) {
            if ([self.xingzuo isEqualToString:dic[@"name"]]) {
                ussId = [NSString stringWithFormat:@"%@", dic[@"id"]];
                break;
            }
        }
    } else {
        if ([[self.ussDic allKeys] count]) {
            
            ussId = [NSString stringWithFormat:@"%@", self.ussDic[@"id"]]?:@"";
        }
    }
    if ([ussId isEqualToString:@""]) {
//        kplaceToast(Localized(@"请选择星座", nil));
//        return;
    }
    
    NSString *proId = @"";
    if ([self.work length]) {
        for (NSDictionary *dic in self.workdata) {
            if ([self.work isEqualToString:dic[@"name"]]) {
                proId = [NSString stringWithFormat:@"%@", dic[@"id"]];
                break;
            }
        }
    } else {
        if ([[self.proDic allKeys] count]) {
            
            proId = [NSString stringWithFormat:@"%@", self.proDic[@"id"]]?:@"";
        }
    }
   
    if ([proId isEqualToString:@""]) {
//        kplaceToast(Localized(@"请选择职业", nil));
//        return;
    }
    if (![self.height length] || [self.height isKindOfClass:[NSNull class]]) {
        kplaceToast(Localized(@"请选择身高", nil));
        return;
    }
    if (![self.weight length] || [self.weight isKindOfClass:[NSNull class]]) {
        kplaceToast(Localized(@"请选择体重", nil));
        return;
    }

    NSString *emId = @"";
    if ([self.love length]) {
        for (NSDictionary *dic in self.qinggandata) {
            if ([self.love isEqualToString:dic[@"name"]]) {
                emId = [NSString stringWithFormat:@"%@", dic[@"id"]];
                break;
            }
        }
    } else {
        if ([[self.emDic allKeys] count]) {
            
            emId = [NSString stringWithFormat:@"%@", self.emDic[@"id"]]?:@"";
        }
    }
    if ([emId isEqualToString:@""]) {
//        kplaceToast(Localized(@"请选择情感", nil));
//        return;
    }
    
    NSString *cityID = @"";
    if (/*![self.city containsString:@","]*/ ![self.city length]) {
        if ([[self.cityDic allKeys] containsObject:@"adCode"]) {
       
            cityID = [NSString stringWithFormat:@"%@", self.cityDic[@"adCode"]];
        }
        
    } else {
//        NSArray * payModeArray = [self.city componentsSeparatedByString:@","];
        
        for (NSDictionary *dic in self.cityData) {
//            if ([/*[payModeArray firstObject]*/self.city isEqualToString:dic[@"name"]]) {
//
//
//
//            }
                NSArray *arr = dic[@"childrens"];
                for (NSDictionary *dic2 in arr) {
                    if ([/*[payModeArray lastObject]*/self.city isEqualToString:dic2[@"name"]]) {
                        cityID = [NSString stringWithFormat:@"%@", dic2[@"adCode"]];
                        break;
                    }
                }
            
//            }
        }
    }
    if ([cityID isEqualToString:@""]) {
        kplaceToast(Localized(@"请选择城市", nil));
        return;
    }
    
    if ([self.typevideo isEqualToString:Localized(@"视频认证", nil)]) {
        self.stytype = @"0";
    }else{
        
        self.stytype = @"1";

    }

    UserInfoData *userData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    MLSaveAuditInfoApi *api = [[MLSaveAuditInfoApi alloc] initWithPersionGif:self.persionGif extra:[self jsonStringForDictionary] type:self.stytype video:self.videpath potos:jsonString?:@"" name:self.namestr?:userData.name phone:self.phonestr?:userData.phone height:self.height?:userData.height weight:self.weight?:userData.weight ussId:ussId cityCode:cityID lables:labelStr?:@"" persionSign:self.persionSignstr?:userData.persionSign idCardFront:@"" idCardReverse:@"" handIdCard:@"" icon:self.iconstr?:userData.icon birthday:self.birthdaystr?:userData.birthday gender:self.genderstr?:@"" proId:proId emId:emId code:@"" persionVideo:/*self.shipingStr?:*/self.persionVideo wxNo:self.wxStr?:@""];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"保存信息----%@",response.data);
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"info_edit"];
        
        UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        currentData.persionSign = weakself.persionSignstr?:userData.persionSign;
        currentData.name = weakself.namestr?:userData.name;
        currentData.phone = weakself.phonestr?:userData.phone;
        currentData.icon = weakself.iconstr?:userData.icon;
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
        
        NSString *str = [NSString stringWithFormat:@"%@", response.msg?:Localized(@"提交成功，审核中...", nil)];
        PNSToast(KEY_WINDOW.window, str, 1.0);
        if ([weakself.typevideo isEqualToString:Localized(@"视频认证", nil)]) {
            [weakself.navigationController popToViewController:[weakself.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else{
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
        
    }];

}


#pragma mark ----- 选择器 ---------
-(void)changeAge{
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.pickerMode = BRDatePickerModeYMD;
    datePickerView.title = Localized(@"请选择出生日期", nil);
    kSelf;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSLog(@"出生日期---%@",selectValue);
        weakself.birthdaystr = selectValue;
        [weakself.tableView reloadData];
        //self.agelabel.text = selectValue;
        //self.agelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    };
    BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
    datePickerView.pickerStyle = customStyle;
    [datePickerView show];
}

-(void)changeSex{
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    //stringPickerView.title = @"";
    stringPickerView.dataSourceArr = @[Localized(@"女", nil), Localized(@"男", nil)];
       stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
           NSLog(@"%@",resultModel.value);
           //self.chargelabel = resultModel.value;
           //[self.tab reloadData];
          //[self setML_SetChargeApichargid:self.dataid[resultModel.index]];
      };
    // 自定义弹框样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    if (@available(iOS 13.0, *)) {
        customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
    } else {
        customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
    }
    //customStyle.separatorColor = setcolor(200, 200, 200, 1);
    stringPickerView.pickerStyle = customStyle;
    [stringPickerView show];
}


-(void)changHeight{
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.selectValue = @"170cm";
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    //stringPickerView.title = @"";
    stringPickerView.dataSourceArr = self.heightArray;
    kSelf;
       stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
           NSLog(@"%@",resultModel.value);
           weakself.height = [resultModel.value stringByReplacingOccurrencesOfString:@"cm" withString:@""];
//           self.height = resultModel.value;
           [weakself.tableView reloadData];
           //self.chargelabel = resultModel.value;
           //[self.tab reloadData];
          //[self setML_SetChargeApichargid:self.dataid[resultModel.index]];
      };
    // 自定义弹框样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    if (@available(iOS 13.0, *)) {
        customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
    } else {
        customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
    }
    //customStyle.separatorColor = setcolor(200, 200, 200, 1);
    stringPickerView.pickerStyle = customStyle;
    [stringPickerView show];
}

-(void)changeWeight{
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.selectValue = @"60kg";
    stringPickerView.dataSourceArr = self.weightArray;
    kSelf;
       stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
           NSLog(@"%@",resultModel.value);
           weakself.weight = [resultModel.value stringByReplacingOccurrencesOfString:@"kg" withString:@""];
//           self.weight = resultModel.value;
           [weakself.tableView reloadData];
           //self.chargelabel = resultModel.value;
           //[self.tab reloadData];
          //[self setML_SetChargeApichargid:self.dataid[resultModel.index]];
      };
    // 自定义弹框样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    if (@available(iOS 13.0, *)) {
        customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
    } else {
        customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
    }
    //customStyle.separatorColor = setcolor(200, 200, 200, 1);
    stringPickerView.pickerStyle = customStyle;
    [stringPickerView show];
}

-(void)changqinggan{
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSDictionary *dic in self.qinggandata) {
        [muArr addObject:dic[@"name"]];
    }
    stringPickerView.dataSourceArr = muArr;
    kSelf;
       stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
           NSLog(@"%@",resultModel.value);
           weakself.love = resultModel.value;
           [weakself.tableView reloadData];
           //self.chargelabel = resultModel.value;
           //[self.tab reloadData];
          //[self setML_SetChargeApichargid:self.dataid[resultModel.index]];
      };
    // 自定义弹框样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    if (@available(iOS 13.0, *)) {
        customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
    } else {
        customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
    }
    //customStyle.separatorColor = setcolor(200, 200, 200, 1);
    stringPickerView.pickerStyle = customStyle;
    [stringPickerView show];
}

-(void)changexingzuo{
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    //stringPickerView.title = @"";
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSDictionary *dic in self.USSdata) {
        [muArr addObject:dic[@"name"]];
    }
    kSelf;
    stringPickerView.dataSourceArr = muArr;
       stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
           NSLog(@"%@",resultModel.value);
           weakself.xingzuo = resultModel.value;
           [weakself.tableView reloadData];
           //self.chargelabel = resultModel.value;
           //[self.tab reloadData];
          //[self setML_SetChargeApichargid:self.dataid[resultModel.index]];
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

-(void)changzhiye{
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSDictionary *dic in self.workdata) {
        [muArr addObject:dic[@"name"]];
    }
    stringPickerView.dataSourceArr = muArr;
    kSelf;
       stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
           NSLog(@"%@",resultModel.value);
           weakself.work = resultModel.value;
           [weakself.tableView reloadData];
           //self.chargelabel = resultModel.value;
           //[self.tab reloadData];
          //[self setML_SetChargeApichargid:self.dataid[resultModel.index]];
      };
    // 自定义弹框样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    if (@available(iOS 13.0, *)) {
        customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
    } else {
        customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
    }
    //customStyle.separatorColor = setcolor(200, 200, 200, 1);
    stringPickerView.pickerStyle = customStyle;
    [stringPickerView show];
}


#pragma mark --changchengshi-----
-(void)changchengshi{
//    [self getStagesDataSource];

    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentLinkage;
    stringPickerView.title = nil;
    stringPickerView.dataSourceArr = [self getStagesDataSource];
    stringPickerView.numberOfComponents = 2;
    kSelf;
    stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
//        self.cityStr = resultModelArr.value;
        // 1.选择的索引
        NSMutableArray *selectIndexs = [[NSMutableArray alloc]init];
        // 2.选择的值
        NSString *selectValue = @"";
        NSMutableArray *nmarray = [NSMutableArray array];
//        for (BRResultModel *model in resultModelArr) {
        if (resultModelArr.count) {
            BRResultModel *model = [resultModelArr lastObject];
            [selectIndexs addObject:@(model.index)];
            //selectValue = [NSString stringWithFormat:@"%@ %@", selectValue, model.value];
            NSLog(@"%@----%@",selectValue,model.value);
            [nmarray addObject:model.value];
        }
//        }
        
//        weakself.city = [nmarray componentsJoinedByString:@","];
        if (nmarray.count) {
            weakself.city = [nmarray lastObject];
        }
        [weakself.tableView reloadData];
    };
  
    
    
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    if (@available(iOS 13.0, *)) {
        customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
    } else {
        customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
    }
    //customStyle.separatorColor = setcolor(200, 200, 200, 1);
    stringPickerView.pickerStyle = customStyle;
    [stringPickerView show];
}

#pragma mark ----
- (NSArray <BRResultModel *>*)getStagesDataSource {
    NSMutableArray *listModelArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in self.cityData) {
        BRResultModel *model = [[BRResultModel alloc]init];
        model.parentKey = @"-1";
        model.parentValue = @"";
        if (![dic[@"name"] isEqual:[NSNull null]]) {
            model.key = dic[@"name"];
            model.value = dic[@"name"];
            [listModelArr addObject:model];
        }
        for (NSDictionary *dict in dic[@"childrens"]) {
            BRResultModel *model1 = [[BRResultModel alloc]init];
            model1.parentKey = dic[@"name"];
            model1.parentValue = dic[@"name"];
            model1.key = dic[@"childrens"];
            model1.value = dict[@"name"];
            [listModelArr addObject:model1];
        }
    }
    return [listModelArr copy];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return kisCH?7:3;
    } else {
        return kisCH?2:1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.row == 0 && indexPath.section == 0)) {
        ML_MineHeadTableViewCell *cell = [[ML_MineHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[ML_MineHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ML_ScreenWidth, 0, 0);
        if (self.headimg) {
            cell.headimg.image = self.headimg;
        } else {
            
            NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
            NSString *ss = [NSString stringWithFormat:@"%@%@",basess,self.iconstr];
            [cell.headimg sd_setImageWithURL:[NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"Slice 46"]];
        }
        return cell;
    } else if((indexPath.row == 1 || (indexPath.row == 2 && kisCH)) && indexPath.section == 0){
        
        ML_MineNameTableViewCell *cell = [[ML_MineNameTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[ML_MineNameTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ML_ScreenWidth, 0, 0);
        if (indexPath.row == 1) {
            cell.titlelabel.text = Localized(@"昵称", nil);
            cell.subtitlelabel.text = self.namestr;
        }else{
            cell.titlelabel.text = Localized(@"电话号码", nil);
            cell.subtitlelabel.text = self.phonestr;
            cell.titlelabel.hidden = YES;
            cell.subtitlelabel.hidden = YES;
            cell.selectimg.hidden = YES;
            
            
                for (UIView *view in cell.contentView.subviews) {
                    if (view.tag >= 11100) {
                        
                        [view removeFromSuperview];
                        break;
                    }
                }
                UILabel *titlelabel2 = [[UILabel alloc]initWithFrame:CGRectMake(32, 0, 75, 45)];
            titlelabel2.text = Localized(@"电话号码", nil);
            titlelabel2.tag = 11100;
                titlelabel2.textAlignment = NSTextAlignmentLeft;
            titlelabel2.font = [UIFont boldSystemFontOfSize:14];
                titlelabel2.textColor = [UIColor colorFromHexString:@"#333333"];
                [cell.contentView addSubview:titlelabel2];
                
                UILabel *label = [[UILabel alloc] init];
                label.frame = CGRectMake(CGRectGetMaxX(titlelabel2.frame), titlelabel2.y, ML_ScreenWidth - 90,45);
                label.textColor = [UIColor colorFromHexString:@"#999999"];
                label.text = self.phonestr;
            label.tag = 11100;
                label.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:label];

//            if (([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue] || ![[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender boolValue])
//                && [self.typevideo isEqualToString:Localized(@"视频认证", nil)]) {
                
            if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue] || [self.typevideo isEqualToString:Localized(@"视频认证", nil)]) {
                UILabel *titlelabel3 = [[UILabel alloc]initWithFrame:CGRectMake(32, CGRectGetMaxY(titlelabel2.frame), 50, 45)];
                titlelabel3.text = @"微信号";
                titlelabel3.tag = 11100;
                titlelabel2.textAlignment = NSTextAlignmentLeft;
                titlelabel3.font = [UIFont boldSystemFontOfSize:14];
                titlelabel3.textColor = [UIColor colorFromHexString:@"#000000"];
                [cell.contentView addSubview:titlelabel3];
                
                UILabel *label2 = [[UILabel alloc] init];
                label2.frame = CGRectMake(CGRectGetMaxX(titlelabel3.frame),titlelabel3.y, 0,45);
                label2.textColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
                label2.text = @"（必填）";
                label2.tag = 11100;
                label2.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:label2];
                
                UILabel *bottomsubtitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), label2.y, 120, 45)];
                bottomsubtitlelabel.text = [self.wxStr length]?self.wxStr:@"请输入微信号码";
                bottomsubtitlelabel.userInteractionEnabled = YES;
                bottomsubtitlelabel.tag = 11100;
                //bottomsubtitlelabel.backgroundColor = UIColor.blueColor;
                bottomsubtitlelabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
                bottomsubtitlelabel.textColor = [UIColor colorFromHexString:@"#999999"];
                UITapGestureRecognizer *bottomtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomClicktttt)];
                [bottomsubtitlelabel addGestureRecognizer:bottomtap];
                [cell.contentView addSubview:bottomsubtitlelabel];
                
                UIImageView *selectimg = [[UIImageView alloc]initWithFrame:CGRectMake(ML_ScreenWidth -14-32, bottomsubtitlelabel.y , 14, 45)];
                selectimg.tag = 11100;
                selectimg.contentMode = UIViewContentModeScaleAspectFit;
                selectimg.image = [UIImage imageNamed:@"icon_jinru_14_ccc_nor"];
                [cell.contentView addSubview:selectimg];
                
            }
        }
        return cell;
    } else if ((indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || (indexPath.row == 2 && !kisCH)) && indexPath.section == 0){
        ML_MineSexSelectTableViewCell *cell = [[ML_MineSexSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[ML_MineSexSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ML_ScreenWidth, 0, 0);
        if (indexPath.row == 3 || (indexPath.row == 2 && !kisCH)) {
            cell.titlelabel.text = Localized(@"生日", nil);
            cell.subtitlelabel.text = self.birthdaystr;
            cell.bottomtitlelabel.text = Localized(@"性别", nil);
            cell.bottomselectimg.hidden = YES;
            if ([self.sexstr isEqualToString:@"1"]) {
                cell.bottomsubtitlelabel.text = Localized(@"男", nil);
            }else{
                cell.bottomsubtitlelabel.text = Localized(@"女", nil);
            }
            kSelf;
            [cell setTopBlock:^{
                [weakself changeAge];
            }];
//            [cell setBottomBlock:^{
//                [self changeSex];
//            }];
        }else if (indexPath.row == 4){
            cell.titlelabel.text = Localized(@"身高", nil);
            if ([self.height isEqualToString:@""]) {
                cell.subtitlelabel.text = Localized(@"请选择身高", nil);
            }else{
                cell.subtitlelabel.text = self.height;
            }
            
            cell.bottomtitlelabel.text = Localized(@"体重", nil);
            if ([self.weight isEqualToString:@""]) {
                cell.bottomsubtitlelabel.text = Localized(@"请选择体重", nil);
            }else{
                cell.bottomsubtitlelabel.text = self.weight;
            }
            kSelf;
            [cell setTopBlock:^{
                [weakself changHeight];
            }];
            [cell setBottomBlock:^{
                [weakself changeWeight];
            }];
        }else if(indexPath.row == 5){
            cell.titlelabel.text = Localized(@"城市", nil);
            if (![[self.cityDic allKeys] count]) {
                cell.subtitlelabel.text = Localized(@"请选择城市", nil);
            }else{
                cell.subtitlelabel.text = self.cityDic[@"name"];
            }
            if ([self.city length]) {
                cell.subtitlelabel.text = self.city;
            }
            
            cell.bottomtitlelabel.text = Localized(@"职业", nil);
            if (![[self.proDic allKeys] count]) {
                cell.bottomsubtitlelabel.text = Localized(@"请选择职业", nil);
            }else{
                cell.bottomsubtitlelabel.text = self.proDic[@"name"];
            }
            
            if ([self.work length]) {
                cell.bottomsubtitlelabel.text = self.work;
            }
            
            kSelf;
            [cell setTopBlock:^{
                [weakself changchengshi];
            }];
            [cell setBottomBlock:^{
                [weakself changzhiye];
            }];
            
        }else{
            cell.titlelabel.text = Localized(@"情感", nil);
            if (![[self.emDic allKeys] count]) {
                cell.subtitlelabel.text = Localized(@"请选择情感", nil);
            }else{
                cell.subtitlelabel.text = self.emDic[@"name"];
            }
            
            if ([self.love length]) {
                cell.subtitlelabel.text = self.love;
            }
            
            cell.bottomtitlelabel.text = Localized(@"星座", nil);
            if (![[self.ussDic allKeys] count]) {
                cell.bottomsubtitlelabel.text = Localized(@"请选择星座", nil);
            }else{
                cell.bottomsubtitlelabel.text = self.ussDic[@"name"];
            }
            
            if ([self.xingzuo length]) {
                cell.bottomsubtitlelabel.text = self.xingzuo;
            }
            
            kSelf;
            [cell setTopBlock:^{
                [weakself changqinggan];
            }];
            [cell setBottomBlock:^{
                [weakself changexingzuo];
            }];
        }
        return cell;
    } else if(indexPath.row == 0 && indexPath.section == 1) {
        ML_MinegexingTableViewCell *cell = [[ML_MinegexingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[ML_MinegexingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.persionSignstr.length) {
            cell.indextitlelabel.text = [NSString stringWithFormat:@"%ld/30", self.persionSignstr.length];
            cell.textView.text = self.persionSignstr;
        }
        kSelf;
        [cell setTextviewStrBlock:^(NSString * _Nonnull textViewStr) {
            NSLog(@"输入的内容--%@",textViewStr);
            weakself.persionSignstr = textViewStr;
        }];
        return cell;
    } else if(indexPath.row == 1 && indexPath.section == 1) {
        MLMineXingxiangTableViewCell *cell = [[MLMineXingxiangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[MLMineXingxiangTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (self.labelArray.count == 0) {
            //cell.subtitlelabel.text = @"";
            cell.titlmessage.hidden = NO;
        }else{
            
            for (UIView *view in cell.bgview.subviews) {
                [view removeFromSuperview];
            }
            
            cell.titlmessage.hidden = YES;
            cell.subtitlelabel.text =  [NSString stringWithFormat:@"%lu/3",(unsigned long)self.labelArray.count];
            NSMutableArray *tolAry = [NSMutableArray new];//图片数组
            for (int i = 0; i < self.labelArray.count; i ++) { //self.labelearray
                self.bianqianbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.bianqianbtn setTitle:self.labelArray[i][@"name"] forState:UIControlStateNormal];
                [self.bianqianbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.bianqianbtn.layer.backgroundColor = kGetColor(@"ff6fb3").CGColor;
                self.bianqianbtn.titleLabel.font = [UIFont systemFontOfSize:13];
                self.bianqianbtn.layer.masksToBounds = YES;
                self.bianqianbtn.layer.cornerRadius = 16;
                        //btn.imageEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
                [cell.bgview addSubview:self.bianqianbtn];
                [tolAry addObject:self.bianqianbtn];
            }

            if (self.labelArray.count == 1) {
                [self.bianqianbtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.bgview.mas_left).mas_offset(16);
                    make.centerY.mas_equalTo(cell.bgview.mas_centerY).mas_offset(-5);
                    make.width.mas_equalTo(85);
                    make.height.mas_equalTo(30);
                }];
            } else {
                [tolAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:2 leadSpacing:1 tailSpacing:1];
                [tolAry mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(@0);
                    make.height.equalTo(@30);
                }];
            }
        }

        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aCell"];
    return cell;
}

- (void)bottomClicktttt
{
    ML_WxNumVC *vc = [ML_WxNumVC new];
    kSelf;
    vc.returnBlock = ^(NSString * _Nonnull showText) {
        weakself.wxStr = showText;
        [weakself.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6){
//            if (indexPath.row == 2 && ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]|| ![[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender boolValue]) && [self.typevideo isEqualToString:Localized(@"视频认证", nil)]) {
            if (indexPath.row == 2 &&
                ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue] ||
                [self.typevideo isEqualToString:Localized(@"视频认证", nil)])) {
                return 103;
            }
            return 58;
        }
        return 0;
    } else {
    
        return 100;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kSelf;
    
    if (indexPath.row == 0 && indexPath.section == 0) {
//         [self upimageLoad];
     } else if(indexPath.row == 1 && indexPath.section == 0){
         MLMineNmaechangeViewController *vc = [[MLMineNmaechangeViewController alloc]init];
         [vc setReturnBlock:^(NSString * _Nonnull showText) {
             
             if (![weakself.namestr isEqualToString:showText]) {
                 weakself.isGai = YES;
             }
                 
             weakself.namestr = showText;
             [weakself.tableView reloadData];
         }];
         [self.navigationController pushViewController:vc animated:YES];
    } else if((indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7) && indexPath.section == 0){
        
    } else if(indexPath.row == 1 && indexPath.section == 1){
        __block MLMineXingxiangViewController *vc = [[MLMineXingxiangViewController alloc]init];
//        NSMutableArray *lableLib = [NSMutableArray array];
        NSMutableArray *nameArr = [NSMutableArray array];
        for (NSDictionary *dic in self.labelArray) {
//            [lableLib addObject:dic[@"id"]];
            [nameArr addObject:dic[@"name"]];
        }
        [nameArr enumerateObjectsUsingBlock:^(NSString *textlabel, NSUInteger idx, BOOL * _Nonnull stop) {
            [vc.dataid addObject:textlabel];
        }];
        
        [vc setReturnBlock:^(NSArray * _Nonnull bianqianArray, NSMutableArray *dicArr) {
//            self.lableLib = idArr;
            [weakself.labelArray removeAllObjects];
            weakself.labelArray = dicArr;
//            kSelf2;
//            [bianqianArray enumerateObjectsUsingBlock:^(NSString *textlabel, NSUInteger idx, BOOL * _Nonnull stop) {
//                [weakself2.labelArray addObject:textlabel];
                
//                [weakself.tableView reloadData];
                NSLog(@"3333333");
//            }];
            NSLog(@"回传值---%lu",(unsigned long)bianqianArray);
            [weakself.tableView reloadData];
           // self.labelArray = bianqianArray;
        }];
        [self.navigationController pushViewController:vc animated:YES];
      }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ML_ScreenWidth, 5)];
        view.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        
        return 5;
    }
}

//-(void)upimageLoad{
//    kSelf;
//    [ZZQAvatarPicker startSelected:^(UIImage * _Nonnull image) {
//        NSLog(@"image-----%@",image);
//        if (!image) {
//            return;
//        }
//        weakself.headimg = image;
//        
//        
//        [weakself.tableView reloadData];
//        
//        [SVProgressHUD showWithStatus:Localized(@"上传中...", nil)];
//        kSelf2;
//        ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc] initWithfileName:[NSString stringWithFormat:@"%@_file", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId] dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[weakself giveformatter] checkSum:[weakself shaData] extra:[weakself jsonStringForDictionary]];
//        [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
//            NSLog(@"%@",response);
//            
//            
//            kSelf3;
//            [ML_CommonApi  uploadImages:@[image] dic:response.data[@"sts"] block:^(NSString * _Nonnull url) {
//                
//                weakself3.iconstr = url;
//                
//                [SVProgressHUD dismiss];
//            }];
//            
//            
//        } error:^(MLNetworkResponse *response) {
//            
//            [SVProgressHUD dismiss];
//            
//
//            
//        } failure:^(NSError *error) {
//            
//            [SVProgressHUD dismiss];
//            
//        }];
//        
//        
//       }];
//}

- (void)ML_backClickklb_la
{
//    BOOL ma = NO;
//    for (NSDictionary *dic in self.potos) {
//        if ([dic[@"isFirst"] intValue] == 1) {
//            ma = YES;
//            break;
//        }
//    }
//    if (!ma) {
//        kplaceToast(@"至少要保留一张封面图");
//        return;
//    }
    
    if (self.isGai) {
        
        UIAlertController *laVC = [UIAlertController alertControllerWithTitle:Localized(@"提示" , nil) message:Localized(@"是否需要保存本次编辑再退出？", nil)  preferredStyle:UIAlertControllerStyleAlert];
        kSelf;
        [laVC addAction:Localized(@"保存", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [weakself baoInfo];
            
//            [weakself.navigationController popViewControllerAnimated:YES];
            [self tuiClick];
        }];
        
        [laVC addAction:Localized(@"放弃", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            [weakself.navigationController popViewControllerAnimated:YES];
            [self tuiClick];
        }];
        
        [[UIViewController topShowViewController] presentViewController:laVC animated:YES completion:nil];
    } else {
        [self tuiClick];
    }
}

- (void)tuiClick
{
    if ([self.typevideo isEqualToString:Localized(@"视频认证", nil)]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    } else {
        [super ML_backClickklb_la];
    }
}

- (void)baoInfo
{
    
    
    NSMutableDictionary *muPDic = [NSMutableDictionary dictionary];
    
    if (self.potos.count) {
        
        [muPDic setValue:self.potos forKey:@"potos"];
    }
    if (self.labelArray.count) {
        
        [muPDic setValue:self.labelArray forKey:@"labelArray"];
    }
    if ([self.persionVideo length] || [self.persionVideo isEqualToString:@""]) {
        
        [muPDic setValue:self.persionVideo forKey:@"persionVideo"];
    }
    
    if ([self.xingzuo length]) {
        [muPDic setValue:self.xingzuo forKey:@"xingzuo"];
    }
    
    if ([self.work length]) {
        [muPDic setValue:self.work forKey:@"work"];
    }
    
    if ([self.love length]) {
        [muPDic setValue:self.love forKey:@"love"];
    }
    
//    if ([self.city containsString:@","]) {
//
//        [muPDic setValue:self.city forKey:@"city"];
//
//    }
    if ([self.city length]) {
        
        [muPDic setValue:self.city forKey:@"city"];
       
    }
    
    if ([self.height length]) {
        [muPDic setValue:self.height forKey:@"height"];
    }
    
    if ([self.weight length]) {
        [muPDic setValue:self.weight forKey:@"weight"];
    }
    
    if ([self.videpath length]) {
        [muPDic setValue:self.videpath forKey:@"videpath"];
    }
    if ([self.namestr length]) {
        [muPDic setValue:self.namestr forKey:@"namestr"];
    }
    if ([self.phonestr length]) {
        [muPDic setValue:self.phonestr forKey:@"phonestr"];
    }
    
    if ([self.persionSignstr length]) {
        [muPDic setValue:self.persionSignstr forKey:@"persionSign"];
    }
    
    if ([self.birthdaystr length]) {
        [muPDic setValue:self.birthdaystr forKey:@"birthdaystr"];
    }
    
    if ([self.sexstr length]) {
        [muPDic setValue:self.sexstr forKey:@"sexstr"];
    }
    
    
//    if ([self.shipingStr length]) {
//        [muPDic setValue:self.shipingStr forKey:@"shipingStr"];
//    }
    
    NSData *data = [self returnDataWithDictionary:muPDic];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"info_edit"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reGif" object:nil];
    NSLog(@"dealloc");
}

- (NSData *)returnDataWithDictionary:(NSDictionary*)dict
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"talkData"];
    [archiver finishEncoding];
    return data;
}

//NSData 转字典:
// NSData转dictonary
- (NSDictionary*)returnDictionaryWithDataPath:(NSData*)data
{

    //  NSData* data = [[NSMutableData alloc]initWithContentsOfFile:path]; 拿路径文件
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSDictionary* myDictionary = [unarchiver decodeObjectForKey:@"talkData"];
    [unarchiver finishDecoding];
    return myDictionary;
}

@end
