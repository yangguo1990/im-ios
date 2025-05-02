//
//  MLLoginCodeViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLLoginCodeViewController.h"
#import <Masonry/Masonry.h>
#import "MLCodeMessageViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "MLCodeApi.h"
#import "UIViewController+MLHud.h"
#import "MLLoginApi.h"
#import "MLTabbarViewController.h"
#import "MLFriendModelViewController.h"
#import "ML_RequestManager.h"
#import "UIButton+ML.h"
#import "ML_QuhaoCell.h"
#import "HY_AdViewController.h"
#import "MLNavViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "SiLiaoBack-Swift.h"
#import "MLUserMessageViewController.h"
@interface MLLoginCodeViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,JXCategoryViewDelegate>
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIButton *diquBtn;
@property (nonatomic,strong) UIImageView *tbgView;
@property (nonatomic,strong) UIView *viewC;
@property (nonatomic,copy)NSString *phoneStr;
@property (nonatomic,strong)UITextField  *txtAccount;
@property (nonatomic,strong)NSArray  *dataArr;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,assign)NSInteger seRow;
@property (nonatomic,strong)UITextField *passtf;
@property (nonatomic,strong)UIButton *codelogin;
@property (nonatomic,strong)UIButton *passlogin;
@property (nonatomic,strong)UIButton *passBt;
@property (nonatomic,strong)JXCategoryTitleView *categoryView;
@property (nonatomic,assign)NSInteger index;
@end

@implementation MLLoginCodeViewController

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    self.index = index;
    if (index == 0) {
        [self.passBt setTitle:@"  验证码" forState:UIControlStateNormal];
        self.passtf.rightViewMode = UITextFieldViewModeAlways;
        self.passtf.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:kGetColor(@"999999")}];
    }else{
        [self.passBt setTitle:@"  密码" forState:UIControlStateNormal];
        self.passtf.rightViewMode = UITextFieldViewModeNever;
        self.passtf.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:kGetColor(@"999999")}];
    }
}

- (void)ML_backClickklb_la
{
//    [[AppDelegate shareAppDelegate] setupRootViewController:[]];
    
    MLNavViewController *nav = [[MLNavViewController alloc]initWithRootViewController:[[HY_AdViewController alloc]init]];
    [AppDelegate shareAppDelegate].window.rootViewController = nav;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.txtAccount  becomeFirstResponder];
    self.btn.enabled  = YES;
}

- (void)eyeBtClick:(UIButton*)sender{
    // 获取验证码
    self.phoneStr = [NSString stringWithFormat:@"%@ %@", [self.diquBtn currentTitle], self.txtAccount.text];
//        }
    
    if(self.phoneStr.length < 7) {
//            [SVProgressHUD showErrorWithStatus:Localized(@"请输入验证码", nil)];
        kplaceToast(Localized(@"请输入手机号", nil));
        return;
    }
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"phone" : self.phoneStr, @"op" : @"login"} urlStr:@"base/sendCode"];
    
    [SVProgressHUD show];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        [SVProgressHUD dismiss];
        kplaceToast(@"验证码已发送,请注意查收");
        
    } error:^(MLNetworkResponse *response) {
        kplaceToast(response.msg);
        
    } failure:^(NSError *error) {
        kplaceToast(error.localizedDescription);
        
    }];
}

- (void)changeWay:(UIButton*)sender{
    if(sender.selected)return;
    self.codelogin.selected = !self.codelogin.selected;
    self.passlogin.selected = !self.passlogin.selected;
    if(self.codelogin.selected){
        self.passtf.hidden = YES;
        [self.btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        self.passtf.hidden = NO;
        [self.btn setTitle:@"登录" forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ML_navView.hidden =YES;
//    self.isEnablePanGesture = NO;
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImage.image = kGetImage(@"loginBG");
    [self.view addSubview:backImage];
    /**最后再加吧**/
//    UIImageView *helloIv = [[UIImageView alloc]initWithFrame:CGRectMake(28*mWidthScale, 124*mHeightScale, 100*mWidthScale, 31*mHeightScale)];
    
    
    UIView *btBack = [[UIView alloc]initWithFrame:CGRectMake(16*mWidthScale, 269*mHeightScale, 343*mWidthScale, 509*mHeightScale)];
    btBack.backgroundColor = UIColor.whiteColor;
    btBack.layer.cornerRadius = 20*mWidthScale;
    btBack.layer.masksToBounds = YES;
    [self.view addSubview:btBack];
    
    
    self.categoryView = [[JXCategoryTitleView alloc]init];
    //self.categoryView.titles = @[@"黄金VIP", @"铂金VIP",@"钻石VIP"];
    self.categoryView.backgroundColor = kGetColor(@"f8f8f8");
    self.categoryView.titles = @[@"验证码登录",@"账号密码登录"];
    self.categoryView.titleColor = kGetColor(@"999999");
    self.categoryView.titleFont = [UIFont systemFontOfSize:14];
    self.categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:14];
    //self.categoryView.userInteractionEnabled = YES;
    //self.categoryView.cellSpacing = 28;
    self.categoryView.titleSelectedColor = kGetColor(@"000000");
    self.categoryView.defaultSelectedIndex = 0;
    //self.categoryView.titleColorGradientEnabled = NO;
    //self.categoryView.titleLabelZoomScale = 1.3;
    self.categoryView.titleLabelVerticalOffset = 0;
    //self.categoryView.contentScrollView = self.listContainerView.scrollView;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kGetColor(@"ff6fb3");
    //lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorWidth = 30;
    lineView.indicatorHeight = 5;
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
    
    JXCategoryIndicatorImageView *imageLineView = [[JXCategoryIndicatorImageView alloc] init];
    imageLineView.indicatorImageView.image = kGetImage(@"CategoryBack");
    imageLineView.indicatorImageView.contentMode = UIViewContentModeScaleToFill;
    imageLineView.indicatorImageViewSize = CGSizeMake(210*mWidthScale, 46*mHeightScale);
//    lineView.indicatorColor = kZhuColor;
    imageLineView.indicatorWidth = JXCategoryViewAutomaticDimension;
//    imageLineView.indicatorWidth = 20*mWidthScale;
//    imageLineView.indicatorHeight = 30*mHeightScale;
//    imageLineView.indicatorImageView.frame = CGRectMake(-10, 0, 182*mWidthScale+20, 46*mHeightScale);
    
    
    self.categoryView.indicators = @[lineView,imageLineView];
    self.categoryView.delegate = self;
    
    [btBack addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(-50);
        make.right.mas_equalTo(60);
        make.height.mas_equalTo(46*mHeightScale);
    }];
    
    self.ML_backBtn.hidden = !self.isPresent;

    UIButton *phontBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [phontBt setImage:kGetImage(@"phontBt") forState:UIControlStateNormal];
    [phontBt setTitle:@" 手机号码" forState:UIControlStateNormal];
    [phontBt setTitleColor:kGetColor(@"999999") forState:UIControlStateNormal];
    phontBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [btBack addSubview:phontBt];
    [phontBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.top.mas_equalTo(self.categoryView.mas_bottom).offset(20*mHeightScale);
        make.width.mas_equalTo(80*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    
    

    UIView *view = [[UIView alloc] init];

    view.layer.cornerRadius = 18*mWidthScale;

    view.layer.backgroundColor = kGetColor(@"f8f8f8").CGColor;
    [btBack addSubview:view];
    self.viewC = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btBack.mas_left).mas_offset(16*mWidthScale);
        make.right.mas_equalTo(btBack.mas_right).mas_offset(-16*mWidthScale);
        make.top.mas_equalTo(phontBt.mas_bottom).offset(10*mHeightScale);
        make.height.mas_equalTo(46*mHeightScale);
    }];
    
    
    UIButton *namelabel = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 40, 46*mHeightScale)];
    namelabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [namelabel addTarget:self action:@selector(diquClick:) forControlEvents:UIControlEventTouchUpInside];
    [namelabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [namelabel setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateSelected];
    namelabel.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [view addSubview:namelabel];
    self.diquBtn = namelabel;
    [self.diquBtn setIconInRightWithSpacing:10];
    
    UITextField  *txtAccount = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 130, 46*mHeightScale)];
    txtAccount.textColor = [UIColor blackColor];
        [txtAccount setDelegate:self];
    txtAccount.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:kGetColor(@"999999")}];
        // 设置文本对齐
        [txtAccount setTextAlignment:NSTextAlignmentLeft];
    [txtAccount setKeyboardType:self.isEm?UIKeyboardTypeDefault:UIKeyboardTypeNumberPad];
        [view addSubview: txtAccount];
        self.txtAccount = txtAccount;

    UIButton *passBt = [[UIButton alloc]initWithFrame:CGRectZero];
    self.passBt = passBt;
    [passBt setImage:kGetImage(@"passW") forState:UIControlStateNormal];
    [passBt setTitle:@"  验证码" forState:UIControlStateNormal];
    [passBt setTitleColor:kGetColor(@"999999") forState:UIControlStateNormal];
    passBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [btBack addSubview:passBt];
    [passBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phontBt.mas_left);
        make.top.mas_equalTo(view.mas_bottom).offset(20*mHeightScale);
        make.width.mas_equalTo(80*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    
    
    
    UITextField *passtf = [[UITextField alloc]initWithFrame:CGRectZero];
    UIView *leftv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20*mWidthScale, 46*mHeightScale)];
    leftv.backgroundColor = [UIColor clearColor];
    passtf.leftView = leftv;
    passtf.leftViewMode = UITextFieldViewModeAlways;
    passtf.textColor = [UIColor blackColor];
//    passtf.layer.borderWidth = 1;
    passtf.layer.cornerRadius = 18*mWidthScale;
    passtf.secureTextEntry = YES;
    passtf.clearButtonMode = UITextFieldViewModeWhileEditing;
//    passtf.layer.borderColor = kGetColor(@"ffe95b").CGColor;
    passtf.backgroundColor = kGetColor(@"f8f8f8");
    passtf.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:kGetColor(@"999999")}];
    [btBack addSubview:passtf];
    [passtf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.top.mas_equalTo(passBt.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(46*mHeightScale);
    }];
    
    UIButton * getCode = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120*mWidthScale, 46*mHeightScale)];
    UIView *rightv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120*mWidthScale, 46*mHeightScale)];
    [getCode setTitle:@"| 获取验证码" forState:UIControlStateNormal];
    [getCode setTitleColor:kGetColor(@"ff6fb3") forState:UIControlStateNormal];
    getCode.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightv addSubview:getCode];
    passtf.rightView = rightv;
    passtf.rightViewMode = UITextFieldViewModeAlways;
    [getCode addTarget:self action:@selector(eyeBtClick:) forControlEvents:UIControlEventTouchUpInside];
    self.passtf = passtf;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:Localized(@"获取验证码", nil) forState:UIControlStateNormal];
    btn.enabled = self.isEm;
    if (self.isEm) {
        
        [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:1/255.0 alpha:1.0].CGColor;
    } else {
        [btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    btn.layer.cornerRadius = 25;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btBack addSubview:btn];
    self.btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(412*mHeightScale);
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.height.mas_equalTo(48*mHeightScale);
    }];

    [namelabel setImage:[UIImage imageNamed:@"downP"] forState:UIControlStateNormal];
    [namelabel setTitle:@"+86" forState:UIControlStateSelected];
    
        [ML_RequestManager requestGetPath:@"base/countryMobilePrefixList" parameters:nil doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
            
            if ([responseObject[@"code"] intValue] == 0) {
                
                self.dataArr = responseObject[@"data"][@"result"];
                
                if ([self.dataArr isKindOfClass:[NSArray class]]) {
                    if (!self.dataArr.count) {
                        return;
                    }
                    
//                    [namelabel setImage:[UIImage imageNamed:@"Sliceirow40"] forState:UIControlStateSelected];
                    [namelabel setImage:[UIImage imageNamed:@"downP"] forState:UIControlStateNormal];
                    
                    [namelabel setTitle:[NSString stringWithFormat:@"+%@", [self.dataArr firstObject][@"mobile_prefix"]] forState:UIControlStateSelected];
                    [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", [self.dataArr firstObject][@"mobile_prefix"]] forState:UIControlStateNormal];

                    CGSize size = [[self.diquBtn currentTitle] sizeWithFont:self.diquBtn.titleLabel.font maxSize:CGSizeMake(150, 30)];
                    self.diquBtn.frame = CGRectMake(10, 0, size.width + 40, 53);
//                    self.txtAccount.frame = CGRectMake(CGRectGetMaxX(self.diquBtn.frame)+ 10, 0, self.viewC.width - size.width - 60, 53);
                    
                    self.txtAccount.frame = CGRectMake(CGRectGetMaxX(self.diquBtn.frame)+ 10, 0, ML_ScreenWidth - CGRectGetMaxX(self.diquBtn.frame) - 10 - 140, 53);
                    
                    [self.diquBtn setIconInRight];
                    
                }
            } else {
                
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];

 }

- (void)diquClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (!self.dataArr.count) {
        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(27, 366, ML_ScreenWidth - 27 *2, ML_ScreenHeight - 265 - 70)];
        bgview.image = [UIImage imageNamed:@"Slice 57"];
        bgview.userInteractionEnabled = YES;
        [self.view addSubview:bgview];
        self.tbgView = bgview;

        
        
        UITableView *tablview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ML_ScreenWidth - 27 *2 - 5, bgview.height - 30) style:UITableViewStylePlain];
        tablview.backgroundColor = UIColor.clearColor;
        tablview.delegate = self;
        tablview.dataSource = self;
        [bgview addSubview:tablview];
        self.tablview = tablview;

        
        [self.tablview reloadData];
    } else {
        self.diquBtn.selected = NO;
        [self.tbgView removeFromSuperview];
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ML_QuhaoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
    if(cell == nil) {
        cell =[[ML_QuhaoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"diqucell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.nameLabel.text = self.dataArr[indexPath.row][@"country"];
    cell.nameLabel2.text = self.dataArr[indexPath.row][@"mobile_prefix"];
    if (self.seRow == indexPath.row) {
        cell.nameLabel2.textColor = kZhuColor;
        cell.nameLabel.textColor = kZhuColor;
    } else {
        cell.nameLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.seRow = indexPath.row;
    
//    [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", self.dataArr[self.seRow][@"mobile_prefix"]] forState:UIControlStateNormal];
//    [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", self.dataArr[self.seRow][@"mobile_prefix"]] forState:UIControlStateSelected];
//
//    [tableView reloadData];
//    [self.tbgView removeFromSuperview];
//    self.diquBtn.selected = NO;
//
//
//    CGSize size = [[self.diquBtn currentTitle] sizeWithFont:self.diquBtn.titleLabel.font maxSize:CGSizeMake(150, 30)];
//    self.diquBtn.frame = CGRectMake(10, 0, size.width + 20, 53);
//    [self.diquBtn setIconInRight];
//
//    self.txtAccount.frame = CGRectMake(CGRectGetMaxX(self.diquBtn.frame)+ 10, 0, self.viewC.width - size.width - 60, 53);
//
//
//
    [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", self.dataArr[self.seRow][@"mobile_prefix"]] forState:UIControlStateNormal];
    [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", self.dataArr[self.seRow][@"mobile_prefix"]] forState:UIControlStateSelected];
 
    [tableView reloadData];
    [self.tbgView removeFromSuperview];
    self.diquBtn.selected = NO;
    
    
    CGSize size = [[self.diquBtn currentTitle] sizeWithFont:self.diquBtn.titleLabel.font maxSize:CGSizeMake(150, 30)];
    self.diquBtn.frame = CGRectMake(10, 0, size.width + 40, 53);
    [self.diquBtn setIconInRight];
    
//    self.txtAccount.frame = CGRectMake(CGRectGetMaxX(self.diquBtn.frame)+ 10, 0, self.viewC.width - size.width - 60, 53);
    self.txtAccount.frame = CGRectMake(CGRectGetMaxX(self.diquBtn.frame)+ 10, 0, ML_ScreenWidth - CGRectGetMaxX(self.diquBtn.frame) - 10 - 140, 53);
    
    
}


- (void)setIsEm:(BOOL)isEm
{
    _isEm = isEm;
    
    [self.txtAccount setPlaceholder:Localized(self.isEm?@"请输入你的邮箱":@"请输入手机号", nil)];
    [self.txtAccount setKeyboardType:self.isEm?UIKeyboardTypeDefault:UIKeyboardTypeNumberPad];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.isEm) {
        
        return YES;
    }
      NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
         NSLog(@"%@",textField.text);
      if (strLength  <=  11) {
            [self.btn setEnabled:YES];
            self.phoneStr = text;
           [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [self.btn setBackgroundImage:kGetImage(@"buttonBG2") forState:UIControlStateNormal];
        }else{
            [self.btn setEnabled:NO];
            [self.btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.btn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
            [self.btn setBackgroundImage:nil forState:UIControlStateNormal];
        }
//        if ([self valiMobile:text]) {
//            [self.btn setEnabled:YES];
//            self.phoneStr = text;
//            [self.btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
//            self.btn.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:1/255.0 alpha:1.0].CGColor;
//        }else{
//            [self.btn setEnabled:NO];
//            [self.btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
//            self.btn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
//        }
    return YES;
}

//- (BOOL)valiMobile:(NSString *)mobile{
//    if ([[mobile substringToIndex:1] isEqualToString:@"1"]) {
//        return YES;
//    }else{
//        [self showMessage:@"确认手机号格式"];
//        return NO;
//    }

//    if ([mobile isEqualToString:@"18811111111"] || [mobile isEqualToString:@"18822222222"] || [mobile isEqualToString:@"18855555555"]) {
//
//        return YES;
//    }
//
//    if (mobile.length != 11){
//        return NO;
//    }
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
//    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
//    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
//    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    if (([regextestmobile evaluateWithObject:mobile] == YES)
//        || ([regextestcm evaluateWithObject:mobile] == YES)
//        || ([regextestct evaluateWithObject:mobile] == YES)
//        || ([regextestcu evaluateWithObject:mobile] == YES)){
//        return YES;
//    }else{
//        return NO;
//    }
//}


-(void)btnClick{
    NSLog(@"获取验证码....");
    self.btn.enabled  = NO;
    if (self.isEm) {
        
        if (![self isValidateEmail:self.txtAccount.text?:@""]) {
            kplaceToast(@"邮箱不正确");
//            [SVProgressHUD dismiss];
            return;
        }
        
        [SVProgressHUD show];
        kSelf;
        [ML_RequestManager requestPath:@"base/sendEmailAuthCode" parameters:@{@"email" : self.txtAccount.text?:@"", @"type" : @"0"} doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] intValue] == 0) {
                
                MLCodeMessageViewController *vc = [[MLCodeMessageViewController alloc]init];
                vc.phonestr = weakself.txtAccount.text?:@"";
                vc.isEm = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
                
                
            } else {
                self.btn.enabled  = YES;
            }
            
        } failure:^(NSError * _Nonnull error) {
            self.btn.enabled  = YES;
            [SVProgressHUD dismiss];
        }];;
        
        
    } else {
        if(self.index == 0){
            //验证码登录
            if(self.phoneStr.length < 7) {
    //            [SVProgressHUD showErrorWithStatus:Localized(@"请输入验证码", nil)];
                kplaceToast(Localized(@"请输入合法手机号", nil));
                return;
            }
            
            if(!self.passtf.text.length) {
    //            [SVProgressHUD showErrorWithStatus:Localized(@"请输入验证码", nil)];
                kplaceToast(Localized(@"请输入验证码", nil));
                return;
            }
            self.phoneStr = [NSString stringWithFormat:@"%@ %@", [self.diquBtn currentTitle], self.txtAccount.text];
            
            [SVProgressHUD show];
            MLLoginApi *api = [[MLLoginApi alloc]initWithtype:@"0" thirdId:self.phoneStr accessToken:@"" code:self.passtf.text dev:@"" yiToken:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                    NSLog(@"登录----%@--%@--%@",response.data,response.msg,response.status);
                if (response.data[@"user"]) { //有填写 无填写
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response.data
                                                                               options:NSJSONWritingPrettyPrinted
                                                                                 error:nil];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [UserCenter loginByOC:jsonString completion:^(BOOL x) {
                        if(x){
                            //rtc登录成功
                            UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response.data[@"user"]];
                            currentData.domain = response.data[@"domain"]?:@"";
                            currentData.thirdId = response.data[@"thirdId"]?:@"";
                            [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                            [SVProgressHUD dismiss];

                //                if([response.data[@"trait"] boolValue] == 1){
                                MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
                //                    KEY_WINDOW.window.rootViewController = mainTab;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
                            });
                        }else{
                            //rtc登录失败
                            self.btn.enabled = YES;
                            [SVProgressHUD showInfoWithStatus:@"IM登录失败"];
                        }
                    }];

                } else {
                    [SVProgressHUD dismiss];
                    MLUserMessageViewController *vc = [[MLUserMessageViewController alloc]init];
                    vc.phonestr = response.data[@"thirdId"];
                    vc.type = @"thirdId";
        //                [self.navigationController pushViewController:vc animated:YES];
                    MLNavViewController *navVC = [[MLNavViewController alloc] initWithRootViewController:vc];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AppDelegate shareAppDelegate] setupRootViewController:navVC];
                    });
                }
 
                } error:^(MLNetworkResponse *response) {
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"登录失败:%@",response.msg]];
                    self.btn.enabled = YES;
                } failure:^(NSError *error) {
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"登录失败:%@",error.localizedDescription]];
                    self.btn.enabled = YES;
                }];
        }else{
            //密码登录
            if(self.phoneStr.length < 7) {
    //            [SVProgressHUD showErrorWithStatus:Localized(@"请输入验证码", nil)];
                kplaceToast(Localized(@"请输入合法手机号", nil));
                return;
            }
            if (!self.passtf.text.length) {
                kplaceToast(Localized(@"请输入密码", nil));
                return;
            }
            
            self.phoneStr = [NSString stringWithFormat:@"%@ %@", [self.diquBtn currentTitle], self.phoneStr];
            MLLoginApi *api = [[MLLoginApi alloc]initWithtype:@"4" thirdId:self.phoneStr accessToken:@"" code:self.passtf.text dev:@"" yiToken:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                    NSLog(@"登录----%@--%@--%@",response.data,response.msg,response.status);
                
                    if (response.data[@"user"]) { //有填写 无填写

                        UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response.data[@"user"]];
                        currentData.domain = response.data[@"domain"]?:@"";
                        currentData.thirdId = response.data[@"thirdId"]?:@"";
                        [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
                        
                        
        //                if([response.data[@"trait"] boolValue] == 1){
                            MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
        //                    KEY_WINDOW.window.rootViewController = mainTab;
                            
                           [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
        //                }else{
        //                    MLFriendModelViewController *vc = [[MLFriendModelViewController alloc]init];
        //                    //vc.phonestr = response.data[@"thirdId"];
        //                    [self.navigationController pushViewController:vc animated:YES];
        //                }
        //                UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response.data[@"user"]];
        //                currentData.domain = response.data[@"domain"]?:@"";
        //                currentData.thirdId = response.data[@"thirdId"]?:@"";
        //                [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
        //
        //                MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
        //                KEY_WINDOW.window.rootViewController = mainTab;
                    } 
                } error:^(MLNetworkResponse *response) {
                    self.btn.enabled  = YES;
                    NSLog(@"登录----%@--%@--%@",response.data,response.msg,response.status);
                } failure:^(NSError *error) {
                    self.btn.enabled  = YES;
                }];
        }
    }
    
}

@end
