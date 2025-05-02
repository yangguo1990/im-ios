//
//  MLMineFaceViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLMineFaceViewController.h"
#import "MLMineFaceTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "MLFaceViewController.h"
#import "MLFaceRenzhengViewController.h"
//#import "PKRecordShortVideoViewController.h"
#import "MLRenzhengWebViewController.h"
#import "MLGetRealAuditInfoApi.h"
#import "MLFaceRenResultViewController.h"
#import "ML_getUploadToken.h"
#import "MLGetAuditInfoApi.h"
#import "MLGetEmLibApi.h"
#import "MLGetProLibApi.h"
#import "MLGetAreaLibApi.h"
#import "MLGetUSSLibApi.h"
#import "MLSaveAuditInfoApi.h"
#import "ML_MineEditViewController.h"
#import <WebKit/WebKit.h>
#import "CMVideoRecordView.h"
#import "MLGetNewAuditInfoApi.h"
#import "MLMineHostRenzhengViewController.h"

@interface MLMineFaceViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,strong)UIView *graview;

@property (nonatomic, assign)BOOL isTi;
@property (nonatomic,copy)NSString *handIdCardStr;
@property (nonatomic,copy)NSString *idCardReverseStr;
@property (nonatomic,copy)NSString *idCardFrontStr;

@property (nonatomic,copy)NSString *namestr;
@property (nonatomic,assign)NSInteger isFirst_index;
@property (nonatomic,copy)NSString *sexstr;
@property (nonatomic,copy)NSString *birthdaystr;
@property (nonatomic,copy)NSString *phonestr;
@property (nonatomic,copy)NSString *persionSignstr;
@property (nonatomic,copy)NSString *genderstr;
@property (nonatomic,copy)NSString *iconstr;
@property (nonatomic,strong)NSMutableArray *potos;
@property (nonatomic,copy)NSString *persionVideo;
@property (nonatomic,copy)NSString *video;
@property (nonatomic,copy)NSString *height;
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
@property (nonatomic,strong)NSArray *lableLib;
@property (nonatomic,strong)NSMutableArray *workdata;
@property (nonatomic,strong)NSMutableArray *cityData;
@property (nonatomic,strong)NSDictionary *userDict;

@property (nonatomic,copy)NSString *shipingStr;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,strong)UIButton *enterbtn;
@property (nonatomic,strong)NSDictionary *renDict;

@property (nonatomic,assign)BOOL isOpen;


@end

@implementation MLMineFaceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self giveMLGetNewAuditInfoApi];
    
 
    self.isTi = NO;
    
}


-(void)giveMLGetNewAuditInfoApi{
    
    MLGetNewAuditInfoApi *api = [[MLGetNewAuditInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSLog(@"%@",response.data);
        self.renDict = response.data;
        [self.tablview reloadData];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
    }];
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.genderstr = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender?:@"";
    
    self.view.backgroundColor = kGetColor(@"f8f8f8");
    self.ML_navView.backgroundColor = UIColor.clearColor;
    self.ML_titleLabel.text = Localized(@"我的认证", nil);
    [self setUpMyUI];
    self.isOpen = NO;

}

- (void)setUpMyUI{
    
    BOOL ismale = [ML_AppUserInfoManager sharedManager].currentLoginUserData.gender.boolValue;
    
    UIImageView *topIv = [[UIImageView alloc]initWithFrame:CGRectZero];
    topIv.image = kGetImage(@"renzhenTop");
    [self.view addSubview:topIv];
    [topIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(276*mHeightScale);
    }];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:label];
    label.text = @"我的认证";
    label.textColor = kGetColor(@"000000");
    label.font = [UIFont boldSystemFontOfSize:24];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(113*mHeightScale);
        make.height.mas_equalTo(36*mHeightScale);
    }];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:label1];
    label1.text = @"完善认证，点亮图标，更易被信任";
    label1.textColor = kGetColor(@"666666");
    label1.font = [UIFont boldSystemFontOfSize:12];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(155*mHeightScale);
        make.height.mas_equalTo(18*mHeightScale);
    }];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:label2];
    label2.text = @"申请条件";
    label2.textColor = kGetColor(@"000000");
    label2.font = [UIFont boldSystemFontOfSize:16];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(224*mHeightScale);
        make.height.mas_equalTo(24*mHeightScale);
    }];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:view1];
    view1.backgroundColor = UIColor.whiteColor;
    view1.layer.cornerRadius = 28*mWidthScale;
    view1.layer.masksToBounds = YES;
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(160*mHeightScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(264*mHeightScale);
    }];

    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectZero];
    if (ismale) {
        icon.image = kGetImage(@"renzhengNan");
    }else{
        icon.image = kGetImage(@"jibenIcon");
    }
   
    [view1 addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(64*mWidthScale);
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(16*mHeightScale);
    }];
    UILabel *viewName = [[UILabel alloc]initWithFrame:CGRectZero];
    [view1 addSubview:viewName];
    viewName.font = [UIFont boldSystemFontOfSize:16];
    viewName.textColor = kGetColor(@"000000");
    if (ismale) {
        viewName.text = @"实名认证";
    }else{
        viewName.text = @"基础身份认证";
    }
    
    [viewName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(10*mWidthScale);
        make.top.mas_equalTo(icon.mas_top);
        make.height.mas_equalTo(32*mHeightScale);
    }];
    
    UILabel *viewName1 = [[UILabel alloc]initWithFrame:CGRectZero];
    [view1 addSubview:viewName1];
    viewName1.font = [UIFont boldSystemFontOfSize:12];
    viewName1.textColor = kGetColor(@"a9a9ab");
    viewName1.text = @"你需要先进行相关资料完善";
    [viewName1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(10*mWidthScale);
        make.bottom.mas_equalTo(icon.mas_bottom);
        make.height.mas_equalTo(32*mHeightScale);
    }];
    
    UIButton * jibenBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [view1 addSubview:jibenBt];
    if (ismale) {
        [jibenBt setTitle:@"立即认证" forState:UIControlStateNormal];
        [jibenBt addTarget:self action:@selector(shimingRZ:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [jibenBt setTitle:@"去完成" forState:UIControlStateNormal];
        [jibenBt addTarget:self action:@selector(jibenClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [jibenBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [jibenBt setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
    jibenBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [jibenBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.bottom.mas_equalTo(-10*mHeightScale);
        make.height.mas_equalTo(48*mHeightScale);
    }];
   
 /**真人认证**/
    if (![[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender isEqualToString:@"1"]) {
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:view2];
        view2.backgroundColor = UIColor.whiteColor;
        view2.layer.cornerRadius = 28*mWidthScale;
        view2.layer.masksToBounds = YES;
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(343*mWidthScale);
            make.height.mas_equalTo(160*mHeightScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(440*mHeightScale);
        }];
        
        UIImageView *icon2 = [[UIImageView alloc]initWithFrame:CGRectZero];
        icon2.image = kGetImage(@"jibenIcon");
        [view2 addSubview:icon2];
        [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(64*mWidthScale);
            make.left.mas_equalTo(16*mWidthScale);
            make.top.mas_equalTo(16*mHeightScale);
        }];
        UILabel *viewName2 = [[UILabel alloc]initWithFrame:CGRectZero];
        [view2 addSubview:viewName2];
        viewName2.font = [UIFont boldSystemFontOfSize:16];
        viewName2.textColor = kGetColor(@"000000");
        viewName2.text = @"真人主播认证";
        [viewName2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon2.mas_right).offset(10*mWidthScale);
            make.top.mas_equalTo(icon2.mas_top);
            make.height.mas_equalTo(32*mHeightScale);
        }];
        
        UILabel *viewName3 = [[UILabel alloc]initWithFrame:CGRectZero];
        [view2 addSubview:viewName3];
        viewName3.font = [UIFont boldSystemFontOfSize:12];
        viewName3.textColor = kGetColor(@"a9a9ab");
        viewName3.text = @"认证后可接视频,发私信赚取收益";
        [viewName3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon2.mas_right).offset(10*mWidthScale);
            make.bottom.mas_equalTo(icon2.mas_bottom);
            make.height.mas_equalTo(32*mHeightScale);
        }];
        
        UIButton * zhuboBt = [[UIButton alloc]initWithFrame:CGRectZero];
        [view2 addSubview:zhuboBt];
        [zhuboBt setTitle:@"立即认证" forState:UIControlStateNormal];
        [zhuboBt setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [zhuboBt setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
        zhuboBt.titleLabel.font = [UIFont systemFontOfSize:16];
        [zhuboBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16*mWidthScale);
            make.right.mas_equalTo(-16*mWidthScale);
            make.bottom.mas_equalTo(-10*mHeightScale);
            make.height.mas_equalTo(48*mHeightScale);
        }];
        [zhuboBt addTarget:self action:@selector(zhuboClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


- (void)zhuboClick:(UIButton*)sender{
    //真人主播认证
    if ([self.dict[@"host"] integerValue] == 0) {
        
        if ([self.renDict[@"code"] integerValue] == 2 || [self.renDict[@"code"] integerValue] == -1) {
            [self setupShwoUI];
        }else{
            MLMineHostRenzhengViewController *vc = [[MLMineHostRenzhengViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
      
    }else{
        MLGetRealAuditInfoApi *api = [[MLGetRealAuditInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            //NSLog(@"%@",response.data);
            if ([response.data[@"msg"] isEqualToString:@"未认证"]) {
                MLFaceRenzhengViewController *vc = [[MLFaceRenzhengViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                MLFaceRenResultViewController *vc = [[MLFaceRenResultViewController alloc]init];
                vc.result = @"认证结果";
                vc.msg = response.data[@"msg"];
                [self.navigationController pushViewController:vc animated:YES];
                   }
                } error:^(MLNetworkResponse *response) {
                } failure:^(NSError *error) {
                }];
    }
}

- (void)jibenClick:(UIButton*)sender{
    //基本认证
    ML_MineEditViewController *vc = [[ML_MineEditViewController alloc]init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shimingRZ:(UIButton *)sender{
    MLGetRealAuditInfoApi *api = [[MLGetRealAuditInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        //NSLog(@"%@",response.data);
        if ([response.data[@"msg"] isEqualToString:@"未认证"]) {
            MLFaceRenzhengViewController *vc = [[MLFaceRenzhengViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MLFaceRenResultViewController *vc = [[MLFaceRenResultViewController alloc]init];
            vc.result = @"认证结果";
            vc.msg = response.data[@"msg"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } error:^(MLNetworkResponse *response) {
           
    } failure:^(NSError *error) {
        
    }];
}

//获取认证信息----
-(void)giveMLGetAuditInfoApi{
    MLGetAuditInfoApi *api = [[MLGetAuditInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        
        NSLog(@"获取认证信息--%@",response.data);
        NSDictionary *userDict = response.data[@"auditInfo"];
        self.persionSignstr = userDict[@"persionSign"];
        self.cityDic = userDict[@"city"];
        self.proDic = userDict[@"pro"];
        self.emDic = userDict[@"em"];
        self.ussDic = userDict[@"uss"];
        self.height = [NSString stringWithFormat:@"%@", userDict[@"height"]];
        self.weight = [NSString stringWithFormat:@"%@", userDict[@"weight"]];
        self.namestr = userDict[@"name"];
        self.sexstr = [NSString stringWithFormat:@"%@",userDict[@"gender"]];
        self.birthdaystr = userDict[@"birthday"];
        self.phonestr = userDict[@"phone"];
        self.potos = [NSMutableArray arrayWithArray:userDict[@"potos"]];
        
        
        self.persionVideo = userDict[@"persionVideo"]?:@"";
        self.iconstr = userDict[@"icon"];

        
        [userDict[@"lables"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.labelArray addObject:dict[@"name"]];
        }];
        
        
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
}

//xingzuo
-(void)giveMLGetUSSLibApi{
    MLGetUSSLibApi *api = [[MLGetUSSLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [response.data[@"uusLib"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            //[self.USSdata addObject:dict];
        }];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

//qinggan
-(void)giveMLGetEmLibApi{
    MLGetEmLibApi *api = [[MLGetEmLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [response.data[@"emLib"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.qinggandata addObject:dict];
        }];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

//zhiye
-(void)giveMLGetProLibApi{
    MLGetProLibApi *api = [[MLGetProLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [response.data[@"proLib"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.workdata addObject:dict];
        }];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

//chengshi
-(void)giveMLGetAreaLibApi{
    MLGetAreaLibApi *api = [[MLGetAreaLibApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

        self.cityData = response.data[@"areaLibToCity"];
        } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

-(void)setupUI{
    self.tablview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablview.delegate = self;
    self.tablview.backgroundColor = [UIColor whiteColor];
    self.tablview.dataSource = self;
    self.tablview.tableFooterView = [UIView new];
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tablview];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ML_NavViewHeight);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
        
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLMineFaceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
      if(cell == nil) {
          cell =[[MLMineFaceTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
          cell.backgroundColor = [UIColor whiteColor];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
    
    if ([self.dict[@"host"] integerValue] == 0) {
        cell.type = MLMineFaceTableViewCellface;
    }else{
        cell.type = MLMineFaceTableViewCellhost;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dict[@"host"] integerValue] == 0) {
        
        if ([self.renDict[@"code"] integerValue] == 2 || [self.renDict[@"code"] integerValue] == -1) {
            [self setupShwoUI];
        }else{
            MLMineHostRenzhengViewController *vc = [[MLMineHostRenzhengViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
      
    }else{
        MLGetRealAuditInfoApi *api = [[MLGetRealAuditInfoApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            //NSLog(@"%@",response.data);
            if ([response.data[@"msg"] isEqualToString:@"未认证"]) {
                MLFaceRenzhengViewController *vc = [[MLFaceRenzhengViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                MLFaceRenResultViewController *vc = [[MLFaceRenResultViewController alloc]init];
                vc.result = @"认证结果";
                vc.msg = response.data[@"msg"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } error:^(MLNetworkResponse *response) {
               
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)setupShwoUI{
    UIView *graview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    graview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5000];
    //graview.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [self.view.window addSubview:graview];
    self.graview = graview;

    UIImageView *bgimg = [[UIImageView alloc]init];
    //bgimg.contentMode = UIViewContentModeScaleAspectFit;
    bgimg.userInteractionEnabled = YES;
    bgimg.image = [UIImage imageNamed:@"Grouprenzhengporbg"];
    [graview addSubview:bgimg];
    [bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(graview.mas_left).mas_offset(33);
        make.right.mas_equalTo(graview.mas_right).mas_offset(-33);
        make.centerY.mas_equalTo(graview.mas_centerY);
        make.height.mas_equalTo(425);
    }];
    
    UIImageView *bgheadimg = [[UIImageView alloc]init];
    //bgheadimg.contentMode = UIViewContentModeScaleAspectFit;
    //bgheadimg.image = [UIImage imageNamed:@"Grouprenzhengporbg"];
    [bgimg addSubview:bgheadimg];
    [bgheadimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(bgimg);
        make.height.mas_equalTo(56);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = Localized(@"真人主播认证协议", nil);
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [bgheadimg addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgheadimg.mas_centerX);
        make.top.mas_equalTo(bgheadimg.mas_top).mas_offset(25);
    }];
    //

    UIButton *cancelbtn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 66 - 40, 10, 30, 30)];
    [bgimg addSubview:cancelbtn2];
//    [cancelbtn2 setTitleColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelbtn2 setImage:kGetImage(@"Group 395") forState:UIControlStateNormal];
    cancelbtn2.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [cancelbtn2 addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *enterbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterbtn.layer.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    enterbtn.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [enterbtn setTitle:Localized(@"同意并继续", nil) forState:UIControlStateNormal];
    enterbtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    enterbtn.enabled = NO;
    enterbtn.layer.cornerRadius = 20;
    [enterbtn addTarget:self action:@selector(enterClick) forControlEvents:UIControlEventTouchUpInside];

    [bgimg addSubview:enterbtn];
    self.enterbtn = enterbtn;
    [enterbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bgimg.mas_bottom).mas_offset(-18);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(bgimg.mas_centerX);
    }];

    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbtn setTitleColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelbtn setTitle:Localized(@"不同意", nil) forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:cancelbtn];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(enterbtn.mas_top).mas_offset(-12);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(17);
        make.centerX.mas_equalTo(bgimg.mas_centerX);
    }];

    self.webView = [[WKWebView alloc] init];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.delegate = self;
    self.webView.UIDelegate = self;
 
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MlRealCertificationHtml]]];
    [bgimg addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgimg.mas_left).mas_offset(18);
        make.right.mas_equalTo(bgimg.mas_right).mas_offset(-18);
        make.top.mas_equalTo(bgheadimg.mas_bottom);
        make.bottom.mas_equalTo(cancelbtn.mas_top).mas_offset(-8);
    }];
}

#pragma mark - scrollView协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        float webviewheigth = 421 - 56 - 54 - 37;
        float diffence = scrollView.contentSize.height - scrollView.contentOffset.y;
        NSLog(@"%f--%f--%f",diffence,scrollView.contentSize.height,scrollView.contentOffset.y);
    if (scrollView.contentSize.height == 0 || webviewheigth == diffence) {
        return;
    }

            self.enterbtn.enabled = YES;
            self.enterbtn.layer.backgroundColor = kZhuColor.CGColor;

}

-(void)cancelClick{
    [self.graview removeFromSuperview];
}

-(void)enterClick{
    
    [self.graview removeFromSuperview];
    [self buildVideoController];
}

- (void)buildVideoController
{
    
    CMVideoRecordView *vc = [[CMVideoRecordView alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSString *)videoCachedPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = @"video_verify";
    NSString *path = [paths[0] stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"mp4"]];
    return path;
}


- (void)didFinishRecordingToOutputFilePath:(NSString *)outputFilePath
{
    if (self.isTi) {
        return;
    }
    
    if (!outputFilePath) {
        kplaceToast(@"视频路径不存在！");
        return;
    }
    self.isTi = YES;
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:outputFilePath];
    

    [SVProgressHUD show];
    
    kSelf;
    ML_getUploadToken *tokenapi = [[ML_getUploadToken alloc] initWithfileName:[NSString stringWithFormat:@"%@_file", [ML_AppUserInfoManager sharedManager].currentLoginUserData.userId]?:@"" dev:@"" token:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
    [tokenapi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response);
        
        
        kSelf2;
        [ML_CommonApi  uploadImages:@[data] dic:response.data[@"sts"] block:^(NSString * _Nonnull url) {
            
            [SVProgressHUD dismiss];
            [weakself2 saveClickWithUrlStr:url];
            
        }];
        
        
    } error:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
        

        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
    }];
    
    
}


-(void)saveClickWithUrlStr:(NSString *)url{
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        ML_MineEditViewController *vc = [[ML_MineEditViewController alloc]init];
        vc.typevideo = Localized(@"视频认证", nil);
        vc.videpath = url;
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}



@end
