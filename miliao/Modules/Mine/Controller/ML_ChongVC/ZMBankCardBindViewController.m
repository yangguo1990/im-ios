//
//  ZMBankCardBindViewController.m
//  SiLiaoBack
//
//  Created by tg on 2023/8/14.
//

#import "ZMBankCardBindViewController.h"
#import "FYPlaceholderTextField.h"
#import "ML_CommonApi2.h"

@interface ZMBankCardBindViewController ()

@property (weak, nonatomic) IBOutlet FYPlaceholderTextField *cardNo;
@property (weak, nonatomic) IBOutlet FYPlaceholderTextField *cardName;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (nonatomic, assign) BOOL isOK;              // 是否查到银行
@property (weak, nonatomic) IBOutlet UIButton *fy_doneBtn;


@end

@implementation ZMBankCardBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorHex(0xEDEDED);
    
    self.cardNo.placeholderColor = UIColorHex(0xCCCCCD);
    self.cardName.placeholderColor = UIColorHex(0xCCCCCD);
    
//    [self ML_setUpCustomNavklb_la];
    self.ML_titleLabel.text = @"绑定银行卡";
    
    
    self.fy_doneBtn.layer.cornerRadius = 20;
    self.fy_doneBtn.layer.masksToBounds = YES;
//    [self.fy_doneBtn setBackgroundImage:kZhuColor forState:UIControlStateNormal];
    self.fy_doneBtn.backgroundColor = kLineVColor;
    
    self.fy_doneBtn.enabled = NO;

    if (self.aliInfos.bankNo) {
        self.cardNo.text = self.aliInfos.bankNo;
        self.cardName.text = self.aliInfos.banUserName;
        self.bankNameLab.text = self.aliInfos.bankName;
    }

}

- (IBAction)textFeildChange:(UITextField *)sender {
    if (sender.text.length >= 16) {
        [SVProgressHUD show];
        ML_CommonApi2 *api = [[ML_CommonApi2 alloc] initWithPDic:@{@"bankNo" : self.cardNo.text} urlStr:@"base/retrievalBankNo"];
        
        kSelf;
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            
            NSDictionary *data = response.data;
            if (data[@"bankName"]) {
                NSString *bankName = data[@"bankName"];
                if (bankName.length > 0) {
                    weakself.isOK = YES;
                    weakself.fy_doneBtn.enabled = YES;
                    weakself.fy_doneBtn.backgroundColor = kZhuColor;
                    weakself.bankNameLab.text = data[@"bankName"];
                } else {
                    weakself.isOK = NO;
                    weakself.bankNameLab.text = @"**银行";
                }
            } else {
                weakself.isOK = NO;
                weakself.bankNameLab.text = @"**银行";
            }
            [SVProgressHUD dismiss];
        } error:^(MLNetworkResponse *response) {
            weakself.isOK = NO;
            weakself.bankNameLab.text = @"**银行";
            weakself.fy_doneBtn.enabled = NO;
            weakself.fy_doneBtn.backgroundColor = kLineVColor;
            [SVProgressHUD showErrorWithStatus:@"请输入正确的银行卡号"];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            weakself.isOK = NO;
            weakself.fy_doneBtn.enabled = NO;
            weakself.fy_doneBtn.backgroundColor = kLineVColor;
            weakself.bankNameLab.text = @"**银行";
            [SVProgressHUD showErrorWithStatus:@"请输入正确的银行卡号"];
            [SVProgressHUD dismiss];
        }];
        
    } else {
        self.isOK = NO;
        self.fy_doneBtn.enabled = NO;
        self.fy_doneBtn.backgroundColor = kLineVColor;
        self.bankNameLab.text = @"**银行";
        [SVProgressHUD showErrorWithStatus:@"请输入正确的银行卡号"];
    }
}


- (IBAction)onDoneBtn:(UIButton *)sender {
    if (self.isOK == NO || [self.bankNameLab.text isEqualToString:@"**银行"]) {
        [self.view endEditing:YES];
        kplaceToast(@"未查询到正确的银行卡信息");
        return;
    }
    [SVProgressHUD show];
    ML_CommonApi *api3 = [[ML_CommonApi alloc] initWithPDic:@{@"type":@"1",
                                                              @"payNo" : self.cardNo.text,
                                                              @"payName" : self.cardName.text,
                                                              @"bankName" : self.bankNameLab.text,
                                                              
                                                            } urlStr:@"user/bindingWay"];
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
