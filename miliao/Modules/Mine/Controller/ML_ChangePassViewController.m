//
//  ML_ChangePassViewController.m
//  SiLiaoBack
//
//  Created by 1234 on 2024/11/8.
//

#import "ML_ChangePassViewController.h"
#import "ML_CommonApi.h"
@interface ML_ChangePassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *currentTF;
@property (weak, nonatomic) IBOutlet UITextField *neTF;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;

@end

@implementation ML_ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_titleLabel.text = @"重置密码";
    self.ML_titleLabel.textColor = kGetColor(@"000000");
    self.ML_navView.backgroundColor = UIColor.clearColor;
//    self.view.backgroundColor = kGetColor(@"242424");
    UIView * currentleft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    currentleft.backgroundColor = UIColor.clearColor;
    self.currentTF.leftView = currentleft;
    self.currentTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入当前密码" attributes:@{NSForegroundColorAttributeName:kGetColor(@"8c8c8c")}];
    UIView *rightV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 34)];
    UIButton * eyeBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    eyeBt.tag = 1000;
    [eyeBt setImage:kGetImage(@"eyeOff") forState:UIControlStateNormal];
    [eyeBt setImage:kGetImage(@"eyeOn") forState:UIControlStateSelected];
    [rightV addSubview:eyeBt];
    eyeBt.center = rightV.center;
    self.currentTF.rightView = rightV;
    self.currentTF.rightViewMode = UITextFieldViewModeAlways;
    [eyeBt addTarget:self action:@selector(eyeBtClick:) forControlEvents:UIControlEventTouchUpInside];
    /**新密码**/
    UIView * neleft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    neleft.backgroundColor = UIColor.clearColor;
    self.neTF.leftView = neleft;
    self.neTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName:kGetColor(@"8c8c8c")}];
    UIView *rightV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 34)];
    UIButton * eyeBt1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    eyeBt1.tag = 1001;
    [eyeBt1 setImage:kGetImage(@"eyeOff") forState:UIControlStateNormal];
    [eyeBt1 setImage:kGetImage(@"eyeOn") forState:UIControlStateSelected];
    [rightV1 addSubview:eyeBt1];
    eyeBt1.center = rightV1.center;
    self.neTF.rightView = rightV1;
    self.neTF.rightViewMode = UITextFieldViewModeAlways;
    [eyeBt1 addTarget:self action:@selector(eyeBtClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneBT.layer.cornerRadius = self.doneBT.bounds.size.height/2;
    self.doneBT.layer.masksToBounds = YES;
    
    
    
}

- (void)eyeBtClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        if(sender.tag == 1000){
            self.currentTF.secureTextEntry = NO;
        }else{
            self.neTF.secureTextEntry = NO;
        }
        
    }else{
        if(sender.tag == 1000){
            self.currentTF.secureTextEntry = YES;
        }else{
            self.neTF.secureTextEntry = YES;
        }
        
    }
}
- (IBAction)donebtClick:(UIButton *)sender {
    
    
    [SVProgressHUD show];
    
    ML_CommonApi *api = [[ML_CommonApi alloc]initWithPDic:@{@"oldPassword":self.currentTF.text,@"newPassword":self.neTF.text} urlStr:@"/login/resetPassword"];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"response is %@",response);
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    } error:^(MLNetworkResponse *response) {
        NSLog(@"error is %@",response);
        
    } failure:^(NSError *error) {
        NSLog(@"failure is %@",error.description);
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];

}


@end
