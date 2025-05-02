//
//  FYBandingController.m
//  FanyouApp
//
//  Created by Wei942 on 2021/4/2.
//

#import "FYBandingController.h"
#import "FYPlaceholderTextField.h"
#import "UIImage+ML.h"

@interface FYBandingController ()
@property (weak, nonatomic) IBOutlet UIImageView *topBack;
@property (weak, nonatomic) IBOutlet UIImageView *payWayIV;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet FYPlaceholderTextField *nameTF;
@property (weak, nonatomic) IBOutlet FYPlaceholderTextField *shenfenNo;

@property (weak, nonatomic) IBOutlet FYPlaceholderTextField *phoneTF;
@property (weak, nonatomic) IBOutlet FYPlaceholderTextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *fy_doneBtn;

@property (assign, nonatomic) NSInteger i;

@end

@implementation FYBandingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_navView.backgroundColor = UIColor.clearColor;
    [self.topBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(88*mHeightScale);
    }];
    
    [self.payWayIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(104*mHeightScale);
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(80*mHeightScale);
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payWayIV.mas_left);
        make.top.mas_equalTo(self.payWayIV.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(22*mHeightScale);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payWayIV.mas_left);
        make.top.mas_equalTo(self.payWayIV.mas_bottom).offset(100*mHeightScale);
        make.height.mas_equalTo(22*mHeightScale);
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payWayIV.mas_left);
        make.top.mas_equalTo(self.payWayIV.mas_bottom).offset(190*mHeightScale);
        make.height.mas_equalTo(22*mHeightScale);
    }];
    
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payWayIV.mas_left);
        make.top.mas_equalTo(self.payWayIV.mas_bottom).offset(280*mHeightScale);
        make.height.mas_equalTo(22*mHeightScale);
    }];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(self.label1.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(40*mHeightScale);
    }];
    
    [self.shenfenNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(self.label1.mas_bottom).offset(100*mHeightScale);
        make.height.mas_equalTo(40*mHeightScale);
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(self.label1.mas_bottom).offset(190*mHeightScale);
        make.height.mas_equalTo(40*mHeightScale);
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(self.label1.mas_bottom).offset(280*mHeightScale);
        make.height.mas_equalTo(40*mHeightScale);
    }];
    
    [self.fy_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(48*mHeightScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(-30*mHeightScale);
    }];
   
    
//    [self ML_setUpCustomNavklb_la];
    if (self.type == 1) {
        self.ML_titleLabel.text = @"绑定支付宝";
        self.label3.text = @"支付宝账号";
        self.payWayIV.image = kGetImage(@"alipay");
    }else{
        self.ML_titleLabel.text = @"绑定微信";
        self.label3.text = @"微信账号";
        self.payWayIV.image = kGetImage(@"wxpay");
    }
    
    
    
    self.fy_doneBtn.layer.cornerRadius = 24;
    self.fy_doneBtn.layer.masksToBounds = YES;
//    [self.fy_doneBtn setBackgroundImage:kZhuColor forState:UIControlStateNormal];
//    self.fy_doneBtn.backgroundColor = kZhuColor;
    self.fy_doneBtn.enabled = NO;
    
    NSDictionary *aliPayDic = self.baoDic[@"aliPay"];
    if ([aliPayDic[@"no"] length]) {
        self.phoneTF.text = aliPayDic[@"no"];
        self.codeTF.text = aliPayDic[@"name"];
    }
}

- (IBAction)textFeildChange:(UITextField *)sender {
    self.fy_doneBtn.enabled = (self.phoneTF.text.length && self.codeTF.text.length&&self.nameTF.text.length&&self.shenfenNo.text.length);
    if (sender == self.phoneTF) {
    }
    else {

    }
}

- (IBAction)onDoneBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    [SVProgressHUD show];
    NSString *phone = [self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *name = self.codeTF.text?:@"";

    
    ML_CommonApi *api3 = [[ML_CommonApi alloc] initWithPDic:@{@"type" : @"1", @"payNo" : phone, @"payName" : name} urlStr:@"user/bindingWay"];
    kSelf;
    [api3 networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [weakself.navigationController popViewControllerAnimated:YES];
        kplaceToast(@"绑定成功");
        
        [SVProgressHUD dismiss];
    } error:^(MLNetworkResponse *response) {
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
    
}


@end
