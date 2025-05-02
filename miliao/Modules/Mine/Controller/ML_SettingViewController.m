//
//  ML_SettingViewController.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_SettingViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDImageCache.h>
#import "ML_SettingTableViewCell.h"
#import "ML_SettingtitleTableViewCell.h"
#import "ML_SettingSwichTableViewCell.h"
#import "ML_BlackViewController.h"
#import "ML_AgreementViewController.h"
#import "ML_HelpViewController.h"
#import "NSString+ML_MineVersion.h"
#import "UIAlertView+NTESBlock.h"
#import "ML_NewestVersionApi.h"
#import "ML_GetChargeApi.h"
#import "ML_SetChargeApi.h"
#import "ML_SetDNDApi.h"
#import "ML_SetWxApi.h"
#import "ML_SetLocalApi.h"
#import "MLLoginViewController.h"
#import "ML_LanguageSelectViewController.h"
#import "UIViewController+MLHud.h"
#import "MLZhuxiaoShowView.h"
#import "MLlogoffApi.h"
#import "ML_SetPrivacyApi.h"
#import "MLSettingAccountViewController.h"
#import "TZImagePickerController.h"
#import "BRPickerView.h"
#import "FUManager.h"
#import "FULiveModel.h"
#import "FUBeautyController.h"
#import "MLNewestVersionShowView.h"
#import "SiLiaoBack-Swift.h"
@interface ML_SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *dataid;
@property (nonatomic,strong)NSArray *ML_celltitleArray;

@property (nonatomic,copy)NSString *chargelabel;
@property (nonatomic,strong)UITableView *tab;
@property (nonatomic,strong)NSDictionary *versionDict;
@property (nonatomic,strong)MLZhuxiaoShowView *zhuxiaoview;
@property (nonatomic,strong)UIView *NmaskView;
@property (nonatomic,strong)UILabel *cachelabel;
@property (nonatomic,copy)NSString *cachestr;

@end

@implementation ML_SettingViewController

-(NSArray *)ML_celltitleArray{
    
    if (_ML_celltitleArray == nil) {
        
        if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) {
            _ML_celltitleArray = @[Localized(@"开启同城", nil), Localized(@"显示微信", nil), Localized(@"账号设置", nil),  Localized(@"黑名单", nil),Localized(@"通话价格", nil),Localized(@"设置美颜参数", nil),Localized(@"帮助", nil), Localized(@"隐私协议", nil),Localized(@"清理缓存", nil),@"检查更新"];
        }else{

                _ML_celltitleArray = @[Localized(@"账号设置", nil),Localized(@"黑名单", nil),Localized(@"设置美颜参数", nil),Localized(@"帮助", nil),Localized(@"隐私协议", nil),Localized(@"清理缓存", nil),@"检查更新"];

        }
        
        if (!kisCH) {
            NSMutableArray *muArr = [NSMutableArray arrayWithArray:_ML_celltitleArray];
            [muArr insertObject:Localized(@"语言", nil) atIndex:2];
            
            _ML_celltitleArray = muArr;
        }
        
    }
    return _ML_celltitleArray;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}
-(NSMutableArray *)dataid{
    if (_dataid == nil) {
        _dataid = [NSMutableArray array];
    }
    return _dataid;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self versionApi];

}

//获取价格列表--
-(void)giveML_GetChargeApi{
    ML_GetChargeApi *api = [[ML_GetChargeApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"heheh-----%@",[ML_AppUserInfoManager sharedManager].currentLoginUserData.charge);

        [response.data[@"charges"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.data addObject:[NSString stringWithFormat:@"%@",dict[@"charge"]]];
            [self.dataid addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
        }];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
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
        }else{
            [self showMessage:@"设置异常"];
        }
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

//获取版本
-(void)versionApi{
    ML_NewestVersionApi *api = [[ML_NewestVersionApi alloc]initWithtype:@"1" extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"版本更新----%@",response);
        self.versionDict = response.data[@"version"];
    } error:^(MLNetworkResponse *response) {
    } failure:^(NSError *error) {
    }];
}

//设置勿扰模式
-(void)setML_SetDNDApidnd:(NSString *)dnd btn:(UIButton *)btn{
    ML_SetDNDApi *api = [[ML_SetDNDApi alloc]initWithdnd:@(![dnd boolValue]) extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"设置勿扰模式---%@",response.data);
        UserInfoData *userInfoData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        if ([userInfoData.dnd isEqualToString:@"1"]) {
            userInfoData.dnd = @"0";
            btn.selected = NO;
        }else{
            userInfoData.dnd = @"1";
            btn.selected = YES;
        }
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = userInfoData;
        [self.tab reloadData];
        [self showMessage:Localized(@"设置成功", nil)];
    } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

//设置是否显示微信
-(void)setML_SetShowWxApidnd:(NSString *)wxShow btn:(UIButton *)btn{
    ML_SetWxApi *api = [[ML_SetWxApi alloc]initWithdnd:@(![wxShow boolValue]) extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"设置是否显示---%@",response.data);
        UserInfoData *userInfoData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
        if ([userInfoData.wxShow isEqualToString:@"1"]) {
            userInfoData.wxShow = @"0";
            btn.selected = NO;
        }else{
            userInfoData.wxShow = @"1";
            btn.selected = YES;
        }
        [ML_AppUserInfoManager sharedManager].currentLoginUserData = userInfoData;
        [self.tab reloadData];
        [self showMessage:Localized(@"设置成功", nil)];
    } error:^(MLNetworkResponse *response) {
        } failure:^(NSError *error) {
        }];
}

//设置同城模式
-(void)setML_SetLocalApilocal:(NSString *)local btn:(UIButton *)btn{
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) { //主播
            ML_SetLocalApi *api = [[ML_SetLocalApi alloc]initWithlocal:@(![local boolValue]) extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                NSLog(@"设置同城模式---%@",response.data);
                
                UserInfoData *userInfoData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
                if ([userInfoData.local isEqualToString:@"1"]) {
                    userInfoData.local = @"0";
                    btn.selected = NO;
                }else{
                    userInfoData.local = @"1";
                    btn.selected = YES;
                }
                
                [ML_AppUserInfoManager sharedManager].currentLoginUserData = userInfoData;
                
                [self.tab reloadData];
            } error:^(MLNetworkResponse *response) {
            } failure:^(NSError *error) {
            }];

    }else{ //用户
            ML_SetPrivacyApi *privacyApi = [[ML_SetPrivacyApi alloc]initWithprivacy:@(![[ML_AppUserInfoManager sharedManager].currentLoginUserData.privacy boolValue]) extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
            [privacyApi networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                    NSLog(@"设置隐私模式---%@",response.data);
                
                UserInfoData *userInfoData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
                
                if ([userInfoData.privacy isEqualToString:@"1"]) {
                    userInfoData.privacy = @"0";
                    btn.selected = NO;
                }else{
                    userInfoData.privacy = @"1";
                    btn.selected = YES;
                }
                
                [ML_AppUserInfoManager sharedManager].currentLoginUserData = userInfoData;
                
                [self.tab reloadData];
            } error:^(MLNetworkResponse *response) {
            } failure:^(NSError *error) {
                NSLog(@"99999999");
            }];
        }
   }


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.ML_titleLabel.text = Localized(@"设置", @"");
//    [[NSBundle bundleWithPath:LanguagePath] localizedStringForKey:(key) value:nil table:@"Language"];

    self.ML_titleLabel.text = Localized(@"设置", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    //self.chargelabel = self.dict[@"charge"];

    UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
    self.chargelabel = [NSString stringWithFormat:@"%@", currentData.charge];
    
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host isEqualToString:@"1"]) {
        [self giveML_GetChargeApi];
    }
}

-(void)setupUI{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.backgroundColor = kGetColor(@"ff3232").CGColor;
    btn.layer.cornerRadius = 25;
    [btn setTitle:Localized(@"退出登录", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarMLMargin);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];
    
    self.tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.backgroundColor = UIColor.whiteColor;
    self.tab.tableFooterView = [UIView new];
//    self.tab.separatorInset=UIEdgeInsetsMake(0,16, 0, 15);
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.tab setSeparatorColor:[UIColor colorFromHexString:@"#F7F7F7"]];  //设置分割线为蓝色

    [self.view addSubview: self.tab];
    [self.tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16*mWidthScale);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16*mWidthScale);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight);
        make.bottom.mas_equalTo(btn.mas_top).mas_offset(-10);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ML_celltitleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"账号设置", nil)]) { //主播
        ML_SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
            if(!cell) {
            cell = [[ML_SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.backgroundColor = [UIColor whiteColor];
           }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = self.ML_celltitleArray[indexPath.row];
        return cell;
    } else if (indexPath.row == 0 || (indexPath.row == 1 && [[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue])) {
            ML_SettingSwichTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"swichcell"];
                if(!cell) {
                    cell = [[ML_SettingSwichTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"swichcell"];
                    cell.backgroundColor = [UIColor whiteColor];
               }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.text = self.ML_celltitleArray[indexPath.row];
            
            UserInfoData * currentData = [ML_AppUserInfoManager sharedManager].currentLoginUserData;
           if (indexPath.row == 0) {//勿扰模式  主播
               if ([currentData.local intValue] == 0) {
                   cell.setnetbtn.selected = YES;
               }else{
                   cell.setnetbtn.selected = NO;
               }
              [cell setSwichBlock:^(NSInteger index,UIButton *btn) {
               [self setML_SetLocalApilocal:currentData.local btn:btn];
              }];
            } else {//设置是否显示微信
                
                cell.setnetbtn.selected = [currentData.wxShow boolValue];
                
                [cell setSwichBlock:^(NSInteger index,UIButton *btn) {
                    [self setML_SetShowWxApidnd:currentData.wxShow btn:btn];
                }];
                
            }
            return cell;
        } else if ((indexPath.row == 10 && [[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]) || indexPath.row == 9 || [self.ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"通话价格", nil)] || indexPath.row == 8 || (indexPath.row == 9 && [[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue])){
            ML_SettingtitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"titlecell"];
                if(!cell) {
                cell = [[ML_SettingtitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titlecell"];
                    cell.backgroundColor = [UIColor whiteColor];
               }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.text = self.ML_celltitleArray[indexPath.row];
            cell.subnameLabel.text = @"";
            if ([cell.nameLabel.text isEqualToString:@"检查更新"]) {
                
                NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                cell.subnameLabel.text = [NSString stringWithFormat:@"V%@", localVersion];
            } else
            if([cell.nameLabel.text isEqualToString:Localized(@"通话价格", nil)]){
                cell.subnameLabel.text = [NSString stringWithFormat:@"%@%@/%@", [ML_AppUserInfoManager sharedManager].currentLoginUserData.charge, Localized(@"金币", nil), Localized(@"分钟", nil)];
                cell.subnameLabel.textColor = kZhuColor;
            } else{
                if ([self.cachestr isEqualToString:@"0.00M"]) {
                    cell.subnameLabel.text = self.cachestr;
                }else{
                    cell.subnameLabel.text = [NSString stringWithFormat:@"%.2fM", [self getCacheSize] * 1000];
                }
                cell.subnameLabel.textColor = [UIColor colorFromHexString:@"#999999"];
            }
            return cell;
        } else{
            ML_SettingtitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"titlecell"];
                if(!cell) {
                cell = [[ML_SettingtitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    cell.backgroundColor = [UIColor whiteColor];
               }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.text = self.ML_celltitleArray[indexPath.row];
            cell.subnameLabel.text = @"";
            if ([cell.nameLabel.text isEqualToString:@"检查更新"]) {
                
                NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                cell.subnameLabel.text = [NSString stringWithFormat:@"V%@", localVersion];
            }
            return cell;
        }
                
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *st = _ML_celltitleArray[indexPath.row];

        if ([st isEqualToString:Localized(@"显示微信", nil)]) {
//            MLSettingAccountViewController *vc = [[MLSettingAccountViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        } else if ([st isEqualToString:Localized(@"账号设置", nil)]) {
            MLSettingAccountViewController *vc = [[MLSettingAccountViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([st isEqualToString:Localized(@"黑名单", nil)]) {
            ML_BlackViewController *vc = [[ML_BlackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([st isEqualToString:Localized(@"通话价格", nil)]){
            [self changePrice];
        }else if ([st isEqualToString:Localized(@"帮助", nil)]){
            ML_HelpViewController *vc = [[ML_HelpViewController alloc]init];
            vc.urlStr = MlHelphtml; 
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([st isEqualToString:Localized(@"隐私协议", nil)]){
            ML_AgreementViewController *vc = [[ML_AgreementViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([st isEqualToString:Localized(@"清理缓存", nil)]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: Localized(@"确定要清理缓存吗？", nil) message:nil delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"确定", nil), nil];
            kSelf;
            [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
                switch (alertIndex) {
                    case 1:
                    {
                        
                        [weakself clearCache];
                            
                        break;
                    }
                    default:
                        break;
                }
            }];
        }else if ([st isEqualToString:Localized(@"设置美颜参数", nil)]){

            
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

        }else if ([st isEqualToString:@"检查更新"]){
            [self ML_setVersionDict];
        } else if ([st isEqualToString:Localized(@"语言", nil)]) {
            
            ML_LanguageSelectViewController *vc = [[ML_LanguageSelectViewController alloc] init];
        
            [self.navigationController pushViewController:vc animated:YES];
        }
}


-(void)showZhuxiao{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.NmaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.NmaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    self.zhuxiaoview = [MLZhuxiaoShowView alterViewWithTitle:Localized(@"操作提示", nil) content:Localized(@"注销后该账号的所有数据都无法恢复，是否确定注销该账号？", nil) sure:Localized(@"确定注销", nil) cancel:Localized(@"放弃注销", nil) sureBtClcik:^{
            NSLog(@"放弃注销....");
            [self.NmaskView removeFromSuperview];
       } cancelClick:^{
              NSLog(Localized(@"确定注销", nil));
           MLlogoffApi *api = [[MLlogoffApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
           [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
               NSLog(@"注销账号---%@",response.data);
                      } error:^(MLNetworkResponse *response) {
                      } failure:^(NSError *error) {
                      }];
           
              [self.NmaskView removeFromSuperview];
       }];
     [self.NmaskView addSubview:self.zhuxiaoview];
     [window addSubview:self.NmaskView];
}

-(void)ML_setVersionDict{
    
    kSelf;
    ML_NewestVersionApi *api = [[ML_NewestVersionApi alloc]initWithtype:@"1" extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"版本更新----%@",response);
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isGeng"]) {
            localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"isGeng"];
        }
        NSString *webVersion;
        if([response.data[@"version"] isKindOfClass:[NSDictionary class]]){
            webVersion = [NSString stringWithFormat:@"%@", response.data[@"version"][@"code"]];
        }else{
            webVersion = nil;
        }
        NSInteger ss = [NSString compareVersion:webVersion to:localVersion];
        if (ss > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:webVersion forKey:@"isGeng"];
            [weakself setupnewversionview:response.data[@"version"]];
        }else{
            kplaceToast(@"没有新版本");
        }
        
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)setupnewversionview:(NSDictionary *)dict{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.NmaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.NmaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    __block MLNewestVersionShowView *versionShowView = [MLNewestVersionShowView alterVietextview:dict[@"content"] must:[dict[@"must"] boolValue] namestr:[NSString stringWithFormat:@"V%@%@",dict[@"version"], Localized(@"版本更新通知", nil)] StrblocksureBtClcik:^{
//        [self.maskView removeFromSuperview];
//        [self.versionShowView removeFromSuperview];
        //
        NSURL *url = [NSURL URLWithString:[dict[@"url"] length]?dict[@"url"]:@"itms-services:///?action=download-manifest&url=https://dahuixiong.oss-cn-shenzhen.aliyuncs.com/data/apk/ios/Info.plist"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        NSArray *arr = nil;
        NSString *s =  arr[0];
    } cancelClick:^{
//        if ([dict[@"must"] integerValue] == 1) {
//            [self showtopMessage:@"新版本已出,请速速更新" topview:self.versionShowView];
//        }else{
        [self.NmaskView removeFromSuperview];
            [versionShowView removeFromSuperview];
//        }
    }];
    [self.NmaskView addSubview:versionShowView];
    [window addSubview:self.NmaskView];
}

-(void)changePrice{
    if (!self.dataid.count) return;
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    //stringPickerView.title = @"";
    stringPickerView.dataSourceArr = self.data;
       stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
           NSLog(@"%@",resultModel.value);
           self.chargelabel = resultModel.value;
           [self.tab reloadData];
           [self setML_SetChargeApichargid:self.dataid[resultModel.index]];
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

-(void)clearCache{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[SDImageCache sharedImageCache] clearMemory];
            [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)lastObject]error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置文字
                 //self.cachelabel.text = [NSString stringWithFormat:@"计算缓存大小%f",[self getCacheSize]];
                [self showMessage:Localized(@"清除缓存完成", nil)];
                self.cachestr = @"0.00M";
                [self.tab reloadData];
                
            });
        });
    }];
}

- (CGFloat)getCacheSize {
    NSUInteger fileSize; // 以字节为单位
    NSString *myCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)lastObject];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fileInfo = [fm attributesOfItemAtPath:myCachePath error:nil];
    fileSize = fileInfo.fileSize;
   return fileSize/1024.0/1024.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    return 58;
}

-(void)btnClick{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: Localized(@"退出当前帐号？", nil) message:nil delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"确定", nil), nil];
    [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
        switch (alertIndex) {
            case 1:
            {
                ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"login/logout"];
                [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                    [UserCenter logout];
                } error:^(MLNetworkResponse *response) {

                } failure:^(NSError *error) {
                    
                }];
                break;
            }
            default:
                break;
        }
    }];
}


@end
