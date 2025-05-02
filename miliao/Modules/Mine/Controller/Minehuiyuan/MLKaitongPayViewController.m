//
//  MLKaitongPayViewController.m
//  miliao
//
//  Created by apple on 2022/9/27.
//

#import "MLKaitongPayViewController.h"
#import <Masonry/Masonry.h>
#import "FriendTableViewCell.h"
#import "MLMineHuiyuanPayTableViewCell.h"
#import "ML_GanqingApi.h"
#import <Colours/Colours.h>
#import "MLGetbuyVipApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ML_PayManager.h"
#import "WXApi.h"
#import "WXPayTools.h"
#import "WKWebViewController.h"
#import "ML_RequestManager.h"


@interface MLKaitongPayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) UITableView *tab;
@property (nonatomic,strong)NSMutableArray *bannersArray;
@property (nonatomic,strong)NSMutableArray *itemimgArray;
@property (nonatomic,strong)NSMutableArray *itemtitleArray;
@property (nonatomic,strong)UILabel *phonetext;
@property (nonatomic,assign)NSInteger index;

@end

@implementation MLKaitongPayViewController


-(NSArray *)itemtitleArray{
    if (_itemtitleArray == nil && !self.appleType) {
        NSMutableArray *arr = [NSMutableArray new];
        if (self.wxPay) {
            [arr addObject:@"微信支付"];
        }
        if (self.aliPay) {
            [arr addObject:@"支付宝"];
        }
        if (self.cardPay) {
            [arr addObject:@"银行卡支付"];
        }
        _itemtitleArray = [NSMutableArray arrayWithArray:arr];
    }
    return _itemtitleArray;
 }


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
}
- (void)setPaylist:(NSArray *)paylist{
    _paylist = paylist;
    for (NSDictionary *dic in paylist) {
        if([dic[@"clickType"]intValue]==1){
            self.index = [dic[@"clickType"]intValue];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.ML_titleLabel.text = Localized(@"订单确认", nil);
    self.ML_navView.backgroundColor = UIColor.clearColor;

    [self setupUI];
    
    self.itemimgArray = [NSMutableArray new];
    
    for (NSString *title in self.itemtitleArray) {
        if ([title isEqualToString:@"微信支付"]) {
            [self.itemimgArray addObject:@"icon_weixin_26_nor"];
        } else if ([title isEqualToString:@"支付宝"]) {
            [self.itemimgArray addObject:@"icon_zhifubao_26_nor"];
        } else {
            [self.itemimgArray addObject:@"bank_card"];
        }
    }
    
}

-(void)setupUI{
    
//    UILabel *messagelabel = [[UILabel alloc]init];
//    messagelabel.numberOfLines = 0;
//    messagelabel.text = Localized(@"选择开通/续费项目", nil);
//    messagelabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//    messagelabel.textColor = [UIColor colorFromHexString:@"#333333"];
//    [self.view addSubview:messagelabel];
//    [messagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
//        if (!kisCH) {
//            
//            make.right.mas_equalTo(-150);
//            make.height.mas_equalTo(40);
//            make.top.mas_equalTo(self.view.mas_top).mas_offset(76 + 35 + 30);
//        } else {
//            make.top.mas_equalTo(self.view.mas_top).mas_offset(76 + 35);
//        }
//    }];
//    
//    UILabel *phonetext = [[UILabel alloc]init];
//    if ([self.dict[@"validMonth"] intValue] >= 100) {
//        phonetext.text = Localized(@"永久有效", nil);
//    } else {
//        phonetext.text = [NSString stringWithFormat:@"%@%@%@", Localized(@"有效期使用", nil), self.dict[@"validMonth"], Localized(@"个月", nil)];
//    }
//    phonetext.textAlignment = NSTextAlignmentCenter;
//    phonetext.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//    phonetext.textColor = [UIColor colorFromHexString:@"#666666"];
//    [self.view addSubview:phonetext];
//    [phonetext mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(messagelabel.mas_centerY);
//        make.right.mas_equalTo(self.view.mas_right).mas_offset(-18);
//    }];
//    self.phonetext = phonetext;
    
    UIImageView *bgview = [[UIImageView alloc]init];
    
    bgview.image = kGetImage(@"TopBackZuanshi");
//    bgview.layer.masksToBounds = YES;
//    bgview.layer.cornerRadius = 8;
//    bgview.layer.borderWidth = 0.5;
//    bgview.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    [self.view addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(300*mHeightScale);
    }];
    
    UIImageView *topimgView =[[UIImageView alloc]init];
    topimgView.contentMode = UIViewContentModeScaleAspectFill;
    topimgView.layer.masksToBounds = YES;
//    [topimgView sd_setImageWithURL:kGetUrlPath(self.dict[@"icon"]) placeholderImage:nil];
//    topimgView.hidden = YES;
    [bgview addSubview:topimgView];
    [topimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(101*mHeightScale);
        make.centerX.mas_equalTo(bgview.mas_centerX);
        make.width.mas_equalTo(321*mWidthScale);
        make.height.mas_equalTo(144*mHeightScale);
    }];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.numberOfLines = 0;
    nameLabel.text = [NSString stringWithFormat:@"%@%@", Localized(@"开通", nil), self.dict[@"name"]];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [bgview addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(43*mWidthScale);
        make.top.mas_equalTo(169*mHeightScale);
        make.height.mas_equalTo(18*mHeightScale);
    }];
   
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(topimgView.mas_centerX);
//        make.top.mas_equalTo(topimgView.mas_bottom).mas_offset(2);
//    }];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 100, 100, 40)];
    //titleLabel.text = @"¥198";
    titleLabel.text = [NSString stringWithFormat:@"¥%@",self.dict[@"amount"]];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor colorFromHexString:@"#666666"];
    [bgview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(48*mWidthScale);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(48*mHeightScale);
    }];
    

    
//    if (self.page == 0) {
//        
//        nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//        nameLabel.textColor = kGetColor(@"#D09458");
//        
//        
//        bgview.image = kGetImage(@"icon_zuanshi_160");
//        
//        titleLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
//        titleLabel.textColor = [UIColor colorFromHexString:@"#D09458"];
//        
//    } else if (self.page == 1) {
//        
//        
//        nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//        nameLabel.textColor = kGetColor(@"#6C9ADD");
//        
//        bgview.image = kGetImage(@"card_vip_baijin_160");
//        
//        titleLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
//        titleLabel.textColor = [UIColor colorFromHexString:@"#6C9ADD"];
//        
//    } else if (self.page == 2) {
        
        nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        nameLabel.textColor = kGetColor(@"#8E5DE6");
        
       topimgView.image = kGetImage(@"icon_zuanshi_160");
        
        titleLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorFromHexString:@"#6126CC"];
//    }
    
    
    
    UILabel *paytitleLabel = [[UILabel alloc]init];
    paytitleLabel.text = Localized(@"选择充值方式", nil);
    paytitleLabel.textAlignment = NSTextAlignmentCenter;
    paytitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    paytitleLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.view addSubview:paytitleLabel];
    [paytitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(bgview.mas_bottom).mas_offset(28);
    }];
    paytitleLabel.hidden = self.appleType;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.layer.backgroundColor = kZhuColor.CGColor;
//    btn.layer.cornerRadius = 25;
    [btn setTitle:[NSString stringWithFormat:@"¥%@%@", self.dict[@"amount"], Localized(@"立即支付", nil)] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [btn setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.height.mas_equalTo(48);
    }];
    
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.scrollEnabled = NO;
    tab.backgroundColor = [UIColor whiteColor];
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tab];
    self.tab = tab;
    [tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(paytitleLabel.mas_bottom).mas_offset(21);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-20);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paylist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLMineHuiyuanPayTableViewCell *cell = [[MLMineHuiyuanPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSDictionary *dic  = self.paylist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.selectimg sd_setImageWithURL:kGetUrlPath(dic[@"logo"])];
    cell.nameLabel.text = dic[@"name"];
    if([dic[@"payWay"]intValue] == self.index){
        cell.isChecked = YES;
    }else{
        cell.isChecked = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic  = self.paylist[indexPath.row];
    self.index = [dic[@"payWay"]intValue];
    [tableView reloadData];
  }

//支付
-(void)btnClick{
    
    if (kisCH) {
        
        kSelf;
        MLGetbuyVipApi *api = [[MLGetbuyVipApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token payWay:self.appleType?@(2):(@(self.index < 2 ? self.index : 3)) vipId:[NSString stringWithFormat:@"%@",self.dict[@"id"]] extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"购买会员-----%@",response.data);
            
            if (self.appleType) {
                
                NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
                [muDic setObject:self.dict[@"pid"]?:@"" forKey:@"pid"];
                [muDic setObject:response.data[@"order"][@"orderNumber"]?:@"" forKey:@"orderNumber"];
                
                [[ML_PayManager sharedPayManager] goChongWithProduct:muDic];
                
                
                return;
            }
            
            if ([response.data[@"payPattern"] intValue] == 1) {
    //        if ([response.data[@"order"] containsString:@"http://"] || [response.data[@"order"] containsString:@"https://"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response.data[@"order"]] options:nil completionHandler:^(BOOL success) {
                                       
                }];
//                WKWebViewController *rechargeVC = [WKWebViewController new];
//                rechargeVC.Rob_euCvar_Url = response.data[@"order"];
//                [self.navigationController pushViewController:rechargeVC animated:YES];

            } else {
                
                NSDictionary *dic = response.data[@"order"];
                if (weakself.index == 0) {
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
                    NSLog(@"%@", data);
                    [WXTools doWXPay:data paySuccess:^{
                        NSLog(@"success！");
                        [ML_AppUserInfoManager shuaWithCoin:nil];
                    } payFailed:^{
                        NSLog(@"支付失败");
                    }];
                    
                } else if (weakself.index == 1) {
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:response.data[@"order"]?:@"" fromScheme:@"alisdk" callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        [ML_AppUserInfoManager shuaWithCoin:nil];
                    }];
                   
                    
                } else {
                    // NOTE: 调用支付结果开始支付
                    WKWebViewController *rechargeVC = [WKWebViewController new];
                    rechargeVC.Rob_euCvar_Url = response.data[@"order"];
                    [self.navigationController pushViewController:rechargeVC animated:YES];
                }
                
            }
            
        } error:^(MLNetworkResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
    } else {
        
        NSString *payWay = [NSString stringWithFormat:@"%ld", self.index];
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
        [ML_RequestManager requestPath2:[NSString stringWithFormat:@"%@?token=%@&payWay=%@&vipId=%@", @"vip/buyVip", [ML_AppUserInfoManager sharedManager].currentLoginUserData.token, payWay, [NSString stringWithFormat:@"%@",self.dict[@"id"]]] parameters:@{@"overseasPayDto" : @""} doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
            
            if ([responseObject[@"code"] intValue] == 0) {
              
                
                if (self.appleType) {
                    
                    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
                    [muDic setObject:self.dict[@"pid"]?:@"" forKey:@"pid"];
                    [muDic setObject:responseObject[@"data"][@"data"]?:@"" forKey:@"orderNumber"];
                    
                    [[ML_PayManager sharedPayManager] goChongWithProduct:muDic];
                    
                    
                    return;
                }
                
                if ([responseObject[@"data"][@"payPattern"] intValue] == 1) {
        //        if ([response.data[@"order"] containsString:@"http://"] || [response.data[@"order"] containsString:@"https://"]) {
                    WKWebViewController *rechargeVC = [WKWebViewController new];
                    rechargeVC.Rob_euCvar_Url = responseObject[@"data"][@"order"];
                    [self.navigationController pushViewController:rechargeVC animated:YES];

                } else {
                    
                    NSDictionary *dic = responseObject[@"data"][@"order"];
                    if (weakself.index == 0)  {
                        
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
                        } payFailed:^{
                            NSLog(@"支付失败");
                        }];
                   } else if (weakself.index == 1) {
                        
                       
                       // NOTE: 调用支付结果开始支付
                       [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"order"]?:@"" fromScheme:@"alisdk" callback:^(NSDictionary *resultDic) {
                           NSLog(@"reslut = %@",resultDic);
                           [ML_AppUserInfoManager shuaWithCoin:nil];
                       }];
                   } else {
                       WKWebViewController *rechargeVC = [WKWebViewController new];
                       rechargeVC.Rob_euCvar_Url = responseObject[@"data"][@"order"];
                       [self.navigationController pushViewController:rechargeVC animated:YES];
                   }
                }
                
            } else {
                
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end

