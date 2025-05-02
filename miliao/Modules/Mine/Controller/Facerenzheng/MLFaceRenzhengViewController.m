//
//  MLFaceRenzhengViewController.m
//  miliao
//
//  Created by apple on 2022/9/26.
//

#import "MLFaceRenzhengViewController.h"
#import "MLSaveRealAuditInfoApi.h"
#import "MLFaceRenResultViewController.h"
#import "ML_RequestManager.h"
#import "UIViewController+MLHud.h"
#import "MLRenzhengWebViewController.h"

@interface MLFaceRenzhengViewController ()<UITextFieldDelegate>

@property (nonatomic,copy)NSString *namestr;
@property (nonatomic,copy)NSString *idcardestr;


@end

@implementation MLFaceRenzhengViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;    
    UIImageView *bgview = [[UIImageView alloc]init];
    bgview.image = kGetImage(@"bg_top");
    [self.view addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(90);
        make.top.mas_equalTo(self.view);
    }];
    
//    UILabel *tuiguangtitle = [[UILabel alloc]init];
    self.ML_titleLabel.text = @"实名认证";
    self.ML_titleLabel.textColor = [UIColor blackColor];
    self.ML_navView.backgroundColor = [UIColor clearColor];
    self.ML_rightBtn.hidden = YES;
    //[self.ML_backBtn setimg:[UIImage imageNamed:@"icon_back_24_FFF_nor-2"] forState:UIControlStateNormal];
    [self.ML_backBtn setImage:[UIImage imageNamed:@"kaitongBG"] forState:UIControlStateNormal];

    
    UILabel *tuionetitle = [[UILabel alloc]init];
    tuionetitle.text = @"实名认证";
    tuionetitle.font = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
    tuionetitle.textColor = [UIColor colorWithHexString:@"#333333"];
    tuionetitle.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:tuionetitle];
    [tuionetitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(bgview.mas_bottom).mas_offset(36);
    }];
    UILabel *tuione = [[UILabel alloc]init];
    tuione.text = @"1.你需要完成实名认证才能提现;";
    tuione.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tuione.numberOfLines = 0;
    tuione.textColor = [UIColor colorWithHexString:@"#666666"];
    tuione.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:tuione];
    [tuione mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(tuionetitle.mas_bottom).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
    }];

    UILabel *tuitwo = [[UILabel alloc]init];
    tuitwo.text = @"2.实名认证和支付宝提现账号需为同一账户;";
    tuitwo.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tuitwo.numberOfLines = 0;
    tuitwo.textColor = [UIColor colorWithHexString:@"#666666"];
    tuitwo.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:tuitwo];
    [tuitwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(tuione.mas_bottom).mas_offset(8);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);

    }];

    UILabel *tuithree = [[UILabel alloc]init];
    tuithree.text = @"3.实名认证仅用于认证,官方将对此严格保密;";
    tuithree.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tuithree.numberOfLines = 0;
    tuithree.textColor = [UIColor colorWithHexString:@"#666666"];
    tuithree.textAlignment = NSTextAlignmentLeft;
     [self.view addSubview:tuithree];
    [tuithree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(tuitwo.mas_bottom).mas_offset(8);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
    }];

    UILabel *nametitle = [[UILabel alloc]init];
    nametitle.text = @"真实姓名";
    nametitle.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    nametitle.textColor = [UIColor colorWithHexString:@"#333333"];
     [self.view addSubview:nametitle];
    [nametitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(tuithree.mas_bottom).mas_offset(49);
    }];
    
    UITextField *nametextfield = [[UITextField alloc]init];
    nametextfield.font = [UIFont systemFontOfSize:15];
    nametextfield.placeholder = @"请输入您的真实姓名";
    nametextfield.keyboardType = UIKeyboardTypeNamePhonePad;
    nametextfield.tag = 1000;
    nametextfield.delegate = self;
   //textfield.layer.cornerRadius = 20;
    //创建搜索框内的左侧搜索标志
    nametextfield.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:nametextfield];
    [nametextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-60);
        make.top.mas_equalTo(nametitle.mas_bottom).mas_offset(34);
        make.height.mas_equalTo(50);
    }];
        
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self.view addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.top.mas_equalTo(nametextfield.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *codetitle = [[UILabel alloc]init];
    codetitle.text = @"身份证号";
    codetitle.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    codetitle.textColor = [UIColor colorWithHexString:@"#333333"];
     [self.view addSubview:codetitle];
    [codetitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.top.mas_equalTo(lineview.mas_bottom).mas_offset(35);
    }];
    
    UITextField *codetextfield = [[UITextField alloc]init];
    codetextfield.font = [UIFont systemFontOfSize:15];
    codetextfield.placeholder = @"请输入您的身份证号";
    codetextfield.keyboardType = UIKeyboardTypeNamePhonePad;
    codetextfield.delegate = self;
    codetextfield.tag = 2000;
   //textfield.layer.cornerRadius = 20;
    //创建搜索框内的左侧搜索标志
    codetextfield.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:codetextfield];
    [codetextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-60);
        make.top.mas_equalTo(codetitle.mas_bottom).mas_offset(34);
        make.height.mas_equalTo(50);
    }];
        
    UIView *codelineview = [[UIView alloc]init];
    codelineview.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self.view addSubview:codelineview];
    [codelineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.top.mas_equalTo(codetextfield.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(1);
    }];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:Localized(@"提交认证", nil)  forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SSL_TabbarHeight);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
      return UIStatusBarStyleLightContent;
}

-(void)backclick{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)btnClick{
    NSLog(@"提交认证");
    if (self.namestr == nil || self.namestr == NULL || self.idcardestr == nil || self.idcardestr == NULL) {
        [self showMessage:@"请输入真实姓名和身份证号"];
        return;
    }
    NSDictionary *dict = @{
        @"userId":[ML_AppUserInfoManager sharedManager].currentLoginUserData.userId,
        @"name":self.namestr,
        @"idCard":self.idcardestr
    };
     [ML_RequestManager requestPath:@"user/saveRealAuditInfo" parameters:dict doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
         [self showMessage:responseObject[@"msg"]];
         if ([responseObject[@"data"] isEqual:[NSNull null]]) {
             return;
         }
         MLRenzhengWebViewController *vc = [[MLRenzhengWebViewController alloc]init];
//         vc.namestr = self.namestr;
//         vc.idcardestr = self.idcardestr;
         vc.certifyId = responseObject[@"data"][@"data"][@"certifyId"];
         vc.webhtml = responseObject[@"data"][@"data"][@"certifyUrl"];
         vc.namestr = self.namestr;
         vc.idcardestr = self.idcardestr;
         [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError * _Nonnull error) {
    }];
    
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField.tag == 1000) {
        NSLog(@"真实姓名---%@",textField.text);
        self.namestr = textField.text;
    }else{
        NSLog(@"身份证号---%@",textField.text);
        self.idcardestr = textField.text;
    }
}


@end
