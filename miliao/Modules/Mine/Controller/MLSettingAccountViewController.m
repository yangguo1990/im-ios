//
//  MLSettingAccountViewController.m
//  miliao
//
//  Created by apple on 2022/11/2.
//

#import "MLSettingAccountViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "ML_SettingtitleTableViewCell.h"
#import "UIViewController+MLHud.h"
#import <WebKit/WebKit.h>
#import "MLChangePhoneViewController.h"
#import "MLZhuxiaoShowView.h"
#import "MLlogoffApi.h"
#import "MLchangphoneSettingViewController.h"
#import "ML_CommonApi2.h"
#import "UIAlertView+NTESBlock.h"
#import "ML_ChangePassViewController.h"
@interface MLSettingAccountViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)NSArray *ML_celltitleArray;
@property (nonatomic,strong)NSArray *ML_celltitleArray2;
@property (nonatomic,strong)UITableView *tab;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,strong)UIButton *enterbtn;
@property (nonatomic,strong)UIView *graview;
@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic,strong)MLZhuxiaoShowView *zhuxiaoview;
@property (nonatomic,strong)UIView *NmaskView;
@end

@implementation MLSettingAccountViewController

-(NSArray *)ML_celltitleArray{
    if (_ML_celltitleArray == nil) {
        
    }
    return _ML_celltitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = Localized(@"账号设置", nil);
    self.view.backgroundColor = UIColor.whiteColor;
        
        _ML_celltitleArray = @[Localized(@"绑定手机号", nil),@"重置密码", Localized(@"账号注销", nil)];
        _ML_celltitleArray2 = @[[ML_AppUserInfoManager sharedManager].currentLoginUserData.phone?:@"", @"",@""];
    
    [self setupUI];
    
}

-(void)setupUI{
    self.tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.backgroundColor = UIColor.whiteColor;
    self.tab.tableFooterView = [UIView new];
    self.tab.separatorInset=UIEdgeInsetsMake(0,16, 0, 15);
    //[self.tab setSeparatorColor:[UIColor colorFromHexString:@"#F7F7F7"]];  //设置分割线为蓝色

    [self.view addSubview: self.tab];
    [self.tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarMLMargin);
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ML_celltitleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ML_SettingtitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    if(!cell) {
        cell = [[ML_SettingtitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.nameLabel.text = self.ML_celltitleArray[indexPath.row];
    cell.subnameLabel.text = self.ML_celltitleArray2[indexPath.row];
    cell.subnameLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    if (indexPath.row == self.ML_celltitleArray.count-1) {
        cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.size.width, 0, 0);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if ([self.ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"绑定手机号", nil)]) {
        if ([self.ML_celltitleArray2[indexPath.row] length]) {
            
            MLChangePhoneViewController *vc = [[MLChangePhoneViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            MLchangphoneSettingViewController *vc = [[MLchangphoneSettingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
 
    } else if ([self.ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"账号注销", nil)]) {
        [self setupShwoUI];
 
    } else if ([self.ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"绑定邮箱", nil)]) {

        if ([self.ML_celltitleArray2[indexPath.row] length]) {
            
            MLChangePhoneViewController *vc = [[MLChangePhoneViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            MLchangphoneSettingViewController *vc = [[MLchangphoneSettingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
     
    } else if ([self.ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"绑定Google", nil)]) {
    
        
    } else if ([self.ML_celltitleArray[indexPath.row] isEqualToString:Localized(@"绑定Facebook", nil)]) {
        
    }else if ([self.ML_celltitleArray[indexPath.row] isEqualToString:@"重置密码"]){
        ML_ChangePassViewController *change = [[ML_ChangePassViewController alloc]initWithNibName:@"ML_ChangePassViewController" bundle:nil];
        [self.navigationController pushViewController:change animated:YES];
    }
    
    
}

-(void)jiebangClickWithStr:(NSString *)str{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"确定", nil), nil];
    [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
        switch (alertIndex) {
            case 1:
            {
                kSelf;
                ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"type" :  @([str isEqualToString:Localized(@"确定需要解绑Facebook吗？", nil)])} urlStr:@"band/userUnBand"];
                [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

                    
                    kSelf2;
                    ML_CommonApi2 *api2 = [[ML_CommonApi2 alloc] initWithPDic:nil urlStr:@"/band/getUserBandInfo"];
                    [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                        [SVProgressHUD dismiss];
                        
                        kplaceToast(@"解绑成功");
                        weakself2.ML_celltitleArray2 = @[response.data[@"phone"]?:@"", response.data[@"email"]?:@"", response.data[@"google"]?:@"", response.data[@"google"]?:@"", response.data[@"phone"]?:@"", @""];
                      
                        [weakself.tab reloadData];
                        
                    } error:^(MLNetworkResponse *response) {

                    } failure:^(NSError *error) {
                      
                        
                    }];
                    
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

- (void)bangWithPdic:(NSDictionary *)pDic
{
    
    [SVProgressHUD show];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:pDic urlStr:@"/band/userInTie"];

    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
    

        kSelf2;
        ML_CommonApi2 *api2 = [[ML_CommonApi2 alloc] initWithPDic:nil urlStr:@"/band/getUserBandInfo"];
        [api2 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            [SVProgressHUD dismiss];
            
            kplaceToast(@"绑定成功");
            weakself2.ML_celltitleArray2 = @[response.data[@"phone"]?:@"", response.data[@"email"]?:@"", response.data[@"google"]?:@"", response.data[@"google"]?:@"", response.data[@"phone"]?:@"", @""];
            [weakself.tab reloadData];
            
        } error:^(MLNetworkResponse *response) {

        } failure:^(NSError *error) {
          
            
        }];
        

    } error:^(MLNetworkResponse *response) {

        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
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
    bgimg.image = [UIImage imageNamed:@"zhuxiaoaccountbg"];
    [graview addSubview:bgimg];
    [bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(graview.mas_left).mas_offset(33);
        make.right.mas_equalTo(graview.mas_right).mas_offset(-33);
        make.centerY.mas_equalTo(graview.mas_centerY);
        make.height.mas_equalTo(425);
    }];
    
    UIImageView *bgheadimg = [[UIImageView alloc]init];
    bgheadimg.userInteractionEnabled = YES;
    [bgimg addSubview:bgheadimg];
    [bgheadimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(bgimg);
        make.height.mas_equalTo(56);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = Localized(@"账号注销须知", nil);
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [bgheadimg addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgheadimg.mas_centerX);
        make.top.mas_equalTo(bgheadimg.mas_top).mas_offset(25);
    }];

    UIButton *deletbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deletbtn setBackgroundImage:[UIImage imageNamed:@"cancelzhuxiao"] forState:UIControlStateNormal];
    [deletbtn addTarget:self action:@selector(deletbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgheadimg addSubview:deletbtn];
    [deletbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgheadimg.mas_top).mas_offset(11);
        make.right.mas_equalTo(bgheadimg.mas_right).mas_offset(-11);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *enterbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterbtn.layer.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    enterbtn.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [enterbtn setTitle:Localized(@"同意注销", nil) forState:UIControlStateNormal];
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
    self.webView.scrollView.delegate = self;
    self.webView.UIDelegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
//    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
//    [self.webView loadHTMLString:headerString baseURL:[NSURL URLWithString:@"https://mlhtml-test.dhxwlkj.com/logoffPolicy"]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MlLogoffPolicyhtml]]];
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
        if (diffence < webviewheigth + 10) {
            self.enterbtn.enabled = YES;
            self.enterbtn.layer.backgroundColor = kZhuColor.CGColor;
        }else{
            self.enterbtn.layer.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
            self.enterbtn.enabled = NO;
    }
}

-(void)cancelClick{
    [self.graview removeFromSuperview];
}

-(void)enterClick{
    NSLog(@"同意注销");
    [self showZhuxiao];
    [self.graview removeFromSuperview];
}

-(void)deletbtnClick{
    [self.graview removeFromSuperview];
}


-(void)showZhuxiao{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.NmaskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.NmaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    self.zhuxiaoview = [MLZhuxiaoShowView alterViewWithTitle:Localized(@"操作提示", nil) content:Localized(@"注销后该账号的所有数据都无法恢复，是否确定注销该账号？", nil) sure:Localized(@"放弃注销", nil) cancel:Localized(@"确定注销", nil)  sureBtClcik:^{
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isJi"];
           NSLog(Localized(@"确定注销", nil));
        MLlogoffApi *api = [[MLlogoffApi alloc]initWithtoken:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token extra:[self jsonStringForDictionary]];
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            NSLog(@"注销账号---%@",response.data);
                   } error:^(MLNetworkResponse *response) {
                   } failure:^(NSError *error) {
                   }];
        
           [self.NmaskView removeFromSuperview];
        
       } cancelClick:^{

           NSLog(@"放弃注销....");
           [self.NmaskView removeFromSuperview];

       }];
     [self.NmaskView addSubview:self.zhuxiaoview];
     [window addSubview:self.NmaskView];
}

@end
