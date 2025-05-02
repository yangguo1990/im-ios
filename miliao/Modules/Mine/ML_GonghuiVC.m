//
//  FYBandingController.m
//  FanyouApp
//
//  Created by Wei942 on 2021/4/2.
//

#import "ML_GonghuiVC.h"
#import "UIImage+ML.h"
#import "ML_GonghuiCell.h"
#import "ML_RequestManager.h"
@interface ML_GonghuiVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong)UIScrollView *crView;
@property (nonatomic,strong)UITextField *textField11;
@property (nonatomic,strong)UITextField *textField10;
@property (nonatomic,strong)UITextField *textField9;
@property (nonatomic,strong)UITextField *textField7;
@end

@implementation ML_GonghuiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.ML_titleLabel.text = Localized(@"申请工会", nil);
    
    self.crView = [[UIScrollView alloc] init];
    [self.view addSubview:self.crView];
    
    
    UILabel *t9 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, ML_ScreenWidth - 32, 25)];
    t9.textColor = [UIColor colorWithHexString:@"#333333"];
    t9.font = kGetFont(18);
    t9.textAlignment = NSTextAlignmentLeft;
    t9.text = Localized(@"申请人姓名：", nil);
    [self.crView addSubview:t9];
    
    UITextField *textField9 = [[UITextField alloc] initWithFrame:CGRectMake(t9.x, CGRectGetMaxY(t9.frame) + 10, t9.width, 40)];
    textField9.placeholder = Localized(@"请输入公会申请者姓名", nil);
    textField9.textAlignment = NSTextAlignmentLeft;
//    textField9.clearsOnBeginEditing = YES;
    textField9.delegate = self;
    textField9.returnKeyType = UIReturnKeyDone;
    [self.crView addSubview:textField9];
    self.textField9 = textField9;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(textField9.frame), ML_ScreenWidth - 32, 0.5)];
    view1.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [self.crView addSubview:view1];
    
    
    UILabel *t10 = [[UILabel alloc] initWithFrame:CGRectMake(t9.x, CGRectGetMaxY(textField9.frame) + 10, t9.width, t9.height)];
    t10.textColor = [UIColor colorWithHexString:@"#333333"];
    t10.textAlignment = NSTextAlignmentLeft;
    t10.font = kGetFont(18);
    t10.text = Localized(@"联系方式：", nil);;
    [self.crView addSubview:t10];
    
    UITextField *textField10 = [[UITextField alloc] initWithFrame:CGRectMake(t10.x, CGRectGetMaxY(t10.frame) + 10, t9.width, 40)];
    textField10.placeholder = Localized(@"请输入微信或电话", nil);
    textField10.textAlignment = NSTextAlignmentLeft;
//    textField9.clearsOnBeginEditing = YES;
    textField10.delegate = self;
    textField10.returnKeyType = UIReturnKeyDone;
    [self.crView addSubview:textField10];
    self.textField10 = textField10;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(textField10.frame), ML_ScreenWidth - 32, 0.5)];
    view2.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [self.crView addSubview:view2];
    
    
    UILabel *t11 = [[UILabel alloc] initWithFrame:CGRectMake(t9.x, CGRectGetMaxY(textField10.frame) + 10, t9.width + 50, t10.height)];
    t11.textColor = [UIColor colorWithHexString:@"#333333"];
    t11.textAlignment = NSTextAlignmentLeft;
    t11.font = kGetFont(18);
    t11.text = Localized(@"公会名称：", nil);;
    [self.crView addSubview:t11];
    
    UITextField *textField11 = [[UITextField alloc] initWithFrame:CGRectMake(t9.x, CGRectGetMaxY(t11.frame) + 10, t9.width, textField10.height)];
    textField11.placeholder = Localized(@"请输入公会名称", nil);
    textField11.textAlignment = NSTextAlignmentLeft;
//    textField9.clearsOnBeginEditing = YES;
    textField11.delegate = self;
    textField11.returnKeyType = UIReturnKeyDone;
    [self.crView addSubview:textField11];
    self.textField11 = textField11;
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(textField11.frame), ML_ScreenWidth - 32, 0.5)];
    view3.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [self.crView addSubview:view3];
    
    
    UILabel *t7 = [[UILabel alloc] initWithFrame:CGRectMake(t9.x, CGRectGetMaxY(textField11.frame) + 10, t9.width, t9.height)];
    t7.textColor = [UIColor colorWithHexString:@"#333333"];
    t7.textAlignment = NSTextAlignmentLeft;
    t7.text = Localized(@"主播人数：", nil);
    t7.font = kGetFont(18);
    [self.crView addSubview:t7];
    
    UITextField *textField7 = [[UITextField alloc] initWithFrame:CGRectMake(t9.x, CGRectGetMaxY(t7.frame) + 10, t9.width, textField10.height)];
    textField7.placeholder = Localized(@"请输入你的主播人数", nil);
    textField7.textAlignment = NSTextAlignmentLeft;
//    textField9.clearsOnBeginEditing = YES;
    textField7.delegate = self;
    textField7.keyboardType = UIKeyboardTypePhonePad;
    [self.crView addSubview:textField7];
    self.textField7 = textField7;
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(textField7.frame), ML_ScreenWidth - 32, 0.5)];
    view4.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    [self.crView addSubview:view4];
    
    
    self.crView.frame = CGRectMake(0, ML_NavViewHeight + 24, self.view.width, self.view.height - ML_NavViewHeight - 24 - ML_NavViewHeight);
    [self.crView setContentSize:CGSizeMake(0, CGRectGetMaxY(textField7.frame)+30)];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, ML_ScreenHeight - 45 - kBottomSafeAreaHeight, ML_ScreenWidth - 30, 54)];
    [btn1 addTarget:self action:@selector(onDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:Localized(@"确认申请", nil) forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"#ffffff"]  forState:UIControlStateNormal];
    [btn1 setBackgroundColor:kZhuColor];
    btn1.layer.cornerRadius = btn1.height / 2;
    btn1.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.view addSubview:btn1];
    
    
    UILabel *t8 = [[UILabel alloc] initWithFrame:CGRectMake(t9.x, CGRectGetMaxY(textField7.frame) + 10, t9.width, 30)];
    t8.textColor = [UIColor colorWithHexString:@"#FF0000"];
    t8.textAlignment = NSTextAlignmentLeft;
    t8.numberOfLines = 0;
    t8.font = kGetFont(12);
    t8.text = Localized(@"注：主播人数是指公会旗下主播数量，请真实填写，以免造成 不必要的损失", nil);;
    [self.crView addSubview:t8];
    
}

- (void)onDoneBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![self.textField9.text length] ||! [self.textField10.text length] || ![self.textField11.text length] || ![self.textField7.text length]) {
        kplaceToast(@"每项都必须填写，别空着喔~");
        return;
    }
    
    
    sender.userInteractionEnabled = NO;
    [SVProgressHUD show];
    
    kSelf;
    
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"applicantName" : self.textField9.text?:@"", @"contact" : self.textField10.text?:@"", @"channelName" : self.textField11.text?:@"", @"hostNum" : self.textField7.text?:@""} urlStr:@"host/saveGuildAudit"];
    
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
         
         [SVProgressHUD dismiss];
         kplaceToast(@"提交成功，等待审核!");
         
         [weakself.navigationController popViewControllerAnimated:YES];
         
    } error:^(MLNetworkResponse *response) {
        
        sender.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        sender.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        
    }];
    
}





@end
