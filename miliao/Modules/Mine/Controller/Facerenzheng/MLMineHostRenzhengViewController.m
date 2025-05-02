//
//  MLMineHostRenzhengViewController.m
//  miliao
//
//  Created by apple on 2022/11/10.
//

#import "MLMineHostRenzhengViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "UIViewController+MLHud.h"
#import "ML_RequestManager.h"
#import <AFNetworking/AFNetworking-umbrella.h>
#import "MLAESUtil.h"
#import "MLFaceRenzhengViewController.h"


@interface MLMineHostRenzhengViewController ()

@property (nonatomic,strong)UIImageView *bgimg;
@property (nonatomic,strong)UILabel *indextitlelabel;
@property (nonatomic,strong)UIButton *cancelbtn;

@end

@implementation MLMineHostRenzhengViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ML_titleLabel.text = @"认证结果";
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
}

-(void)setupUI{
    
    UIImageView *bgimg = [[UIImageView alloc]init];
    bgimg.image = [UIImage imageNamed:@"shenhezhong2"];
    [self.view addSubview:bgimg];
    self.bgimg = bgimg;
    [bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(24);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-24);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(ML_NavViewHeight + SSL_StatusBarHeight);
        make.height.mas_equalTo(211);
    }];

    UILabel *indextitlelabel = [[UILabel alloc]init];
    indextitlelabel.text = Localized(@"资料审核中!", nil);
    indextitlelabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    indextitlelabel.textColor = [UIColor colorWithHexString:@"#000000"];
    indextitlelabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:indextitlelabel];
    self.indextitlelabel = indextitlelabel;
    [indextitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgimg.mas_bottom).mas_offset(13);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
        
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"base/getContactInformation"];
         [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {


             UILabel *indextitlelabel2 = [[UILabel alloc]init];
             indextitlelabel2.text = [NSString stringWithFormat:@"%@%@", Localized(@"请添加微信：", nil), response.data[@"contactInformation"]];
             indextitlelabel2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
             indextitlelabel2.textColor = [UIColor colorWithHexString:@"#666666"];
             indextitlelabel2.textAlignment = NSTextAlignmentLeft;
             [self.view addSubview:indextitlelabel2];
             [indextitlelabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(bgimg.mas_bottom).mas_offset(50);
                 make.centerX.mas_equalTo(self.view.mas_centerX);
             }];

        } error:^(MLNetworkResponse *response) {


        } failure:^(NSError *error) {


        }];
        
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbtn setTitle:Localized(@"关闭", nil) forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [cancelbtn setTitleColor:kZhuColor forState:UIControlStateNormal];
    cancelbtn.layer.borderColor = kZhuColor.CGColor;
    cancelbtn.layer.borderWidth = 1;
    cancelbtn.layer.cornerRadius = 16;
    cancelbtn.layer.masksToBounds = YES;
    [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelbtn];
    self.cancelbtn = cancelbtn;
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(indextitlelabel.mas_bottom).mas_offset(43);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(40);
    }];
  }
    

-(void)cancelClick{
   [self.navigationController popViewControllerAnimated:YES];
}


@end
