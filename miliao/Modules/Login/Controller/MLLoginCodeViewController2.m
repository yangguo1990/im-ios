//
//  MLLoginCodeViewController2.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLLoginCodeViewController2.h"
#import <Masonry/Masonry.h>
#import "MLCodeMessageViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "MLCodeApi.h"
#import "UIViewController+MLHud.h"
//#import "MLLoginApi.h"
#import "MLTabbarViewController.h"
#import "MLFriendModelViewController.h"
#import "ML_RequestManager.h"
#import "UIButton+ML.h"
#import "ML_QuhaoCell.h"
#import "HY_AdViewController.h"
#import "MLNavViewController.h"
@interface MLLoginCodeViewController2 ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIButton *diquBtn;
@property (nonatomic,strong) UIImageView *tbgView;
@property (nonatomic,strong) UIView *viewC;
@property (nonatomic,copy)NSString *phoneStr;
@property (nonatomic,strong)UITextField  *txtAccount;
@property (nonatomic,strong)NSArray  *dataArr;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,assign)NSInteger seRow;
@end

@implementation MLLoginCodeViewController2

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

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isEnablePanGesture = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    self.ML_backBtn.hidden = !self.isPresent;
    UILabel *tlabel = [[UILabel alloc]init];
    tlabel.text = @"Hello!";
    tlabel.textAlignment = NSTextAlignmentLeft;
    tlabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    tlabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [self.view addSubview:tlabel];
    [tlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(28);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(124);
    }];

    
    UILabel *mlabel = [[UILabel alloc]init];
    if (kisCH) {
        mlabel.text = @"欢迎来到思聊交友";
    } else {
        mlabel.text = Localized(@"欢迎来到Meeting", nil);
    }
    mlabel.textAlignment = NSTextAlignmentLeft;
    mlabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    mlabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [self.view addSubview:mlabel];
    [mlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(28);
        make.top.mas_equalTo(tlabel.mas_bottom).mas_offset(4);
    }];

    UIView *view = [[UIView alloc] init];
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 25;
    view.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.3000].CGColor;
    [self.view addSubview:view];
    self.viewC = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.top.mas_equalTo(mlabel.mas_bottom).mas_offset(32);
        make.height.mas_equalTo(53);
    }];
    
    
    UIButton *namelabel = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 40, 53)];
    namelabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [namelabel addTarget:self action:@selector(diquClick:) forControlEvents:UIControlEventTouchUpInside];
    [namelabel setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    [namelabel setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateSelected];
    namelabel.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [view addSubview:namelabel];
    self.diquBtn = namelabel;
    [self.diquBtn setIconInRightWithSpacing:(5)];
    
        UITextField  *txtAccount = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 130, 53)];
    txtAccount.textColor = [UIColor blackColor];
        [txtAccount setDelegate:self];
    [txtAccount setPlaceholder:Localized(self.isEm?@"请输入你的邮箱":@"请输入手机号", nil)];
        // 设置文本对齐
        [txtAccount setTextAlignment:NSTextAlignmentLeft];
    [txtAccount setKeyboardType:self.isEm?UIKeyboardTypeDefault:UIKeyboardTypeNumberPad];
        [view addSubview: txtAccount];
        self.txtAccount = txtAccount;
//        [txtAccount mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(view.mas_left).mas_offset(100);
//            make.right.mas_equalTo(view.mas_right).mas_offset(-20);
//            make.centerY.mas_equalTo(namelabel.mas_centerY);
//            make.height.mas_equalTo(25);
//    }];
    
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
    [self.view addSubview:btn];
    self.btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
        make.height.mas_equalTo(53);
    }];
    
    if (kisCH) {
        
        [self.diquBtn setTitle:@"+86" forState:UIControlStateNormal];
    } else if (!self.isEm){
        
        [ML_RequestManager requestGetPath:@"base/countryMobilePrefixList" parameters:nil doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
            
            if ([responseObject[@"code"] intValue] == 0) {
                
                self.dataArr = responseObject[@"data"][@"result"];
                
                if (self.dataArr.count && [self.dataArr isKindOfClass:[NSArray class]]) {
                    
                    
                    [namelabel setImage:[UIImage imageNamed:@"Sliceirow40"] forState:UIControlStateSelected];
                    [namelabel setImage:[UIImage imageNamed:@"Sliceirow40down"] forState:UIControlStateNormal];
                    
                    [namelabel setTitle:[NSString stringWithFormat:@"+%@", [self.dataArr firstObject][@"mobile_prefix"]] forState:UIControlStateSelected];
                    [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", [self.dataArr firstObject][@"mobile_prefix"]] forState:UIControlStateNormal];

                    CGSize size = [[self.diquBtn currentTitle] sizeWithFont:self.diquBtn.titleLabel.font maxSize:CGSizeMake(150, 30)];
                    self.diquBtn.frame = CGRectMake(10, 0, size.width + 20, 53);
                    self.txtAccount.frame = CGRectMake(CGRectGetMaxX(self.diquBtn.frame)+ 10, 0, self.viewC.width - size.width - 60, 53);
                    [self.diquBtn setIconInRight];
                    
                }
            } else {
                
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    } else {
        self.diquBtn.frame = CGRectMake(10, 0, 60, 53);
        [self.diquBtn setTitle:@"Email：" forState:UIControlStateNormal];
    }
 }

- (void)diquClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (!self.dataArr.count) {
        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(27, 265, ML_ScreenWidth - 27 *2, ML_ScreenHeight - 265 - 70)];
        bgview.image = [UIImage imageNamed:@"Slice 57"];
        bgview.userInteractionEnabled = YES;
        [self.view addSubview:bgview];
        self.tbgView = bgview;
//
//        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.viewC.mas_bottom).mas_offset(12);
//            make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
//            make.right.mas_equalTo(self.view.mas_right).mas_offset(-27);
//            make.bottom.mas_equalTo(self.view).mas_offset(74);
//        }];
        
        
        UITableView *tablview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ML_ScreenWidth - 27 *2 - 5, bgview.height - 30) style:UITableViewStylePlain];
        tablview.backgroundColor = UIColor.clearColor;
        tablview.delegate = self;
        tablview.dataSource = self;
        [bgview addSubview:tablview];
        self.tablview = tablview;
//        [tablview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(0);
//            make.bottom.mas_equalTo(bgview).mas_offset(0);
//            make.top.mas_equalTo(bgview).mas_offset(15);
//        }];
        
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
    
    [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", self.dataArr[self.seRow][@"mobile_prefix"]] forState:UIControlStateNormal];
    [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", self.dataArr[self.seRow][@"mobile_prefix"]] forState:UIControlStateSelected];
 
    [tableView reloadData];
    [self.tbgView removeFromSuperview];
    self.diquBtn.selected = NO;
    
    
    CGSize size = [[self.diquBtn currentTitle] sizeWithFont:self.diquBtn.titleLabel.font maxSize:CGSizeMake(150, 30)];
    self.diquBtn.frame = CGRectMake(10, 0, size.width + 20, 53);
    [self.diquBtn setIconInRight];
    
    self.txtAccount.frame = CGRectMake(CGRectGetMaxX(self.diquBtn.frame)+ 10, 0, self.viewC.width - size.width - 60, 53);
    
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
      if (strLength  <=  11 ) {
            [self.btn setEnabled:YES];
            self.phoneStr = text;
            [self.btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.btn.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:1/255.0 alpha:1.0].CGColor;
        }else{
            [self.btn setEnabled:NO];
            [self.btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            self.btn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
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
            [SVProgressHUD dismiss];
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
        
        if(self.phoneStr.length < 7) {
    //            [SVProgressHUD showErrorWithStatus:Localized(@"请输入验证码", nil)];
            kplaceToast(Localized(@"请输入合法手机号", nil));
            return;
        }
        
        if (!kisCH && ![self.phoneStr containsString:@"+"]) {
            self.phoneStr = [NSString stringWithFormat:@"%@ %@", [self.diquBtn currentTitle], self.phoneStr];
        }
        ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"phone" : self.phoneStr, @"op" : @"login"} urlStr:@"base/sendCode"];
        
        [SVProgressHUD show];
        kSelf;
        [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
            [SVProgressHUD dismiss];
            MLCodeMessageViewController *vc = [[MLCodeMessageViewController alloc]init];
            vc.phonestr = weakself.phoneStr;
            vc.type = @"thirdId";
            [weakself.navigationController pushViewController:vc animated:YES];
            
            
        } error:^(MLNetworkResponse *response) {
            self.btn.enabled  = YES;
            
        } failure:^(NSError *error) {
            self.btn.enabled  = YES;
            
        }];
    }
    
}

@end
