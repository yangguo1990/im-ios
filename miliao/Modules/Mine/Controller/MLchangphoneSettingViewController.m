//
//  MLchangphoneSettingViewController.m
//  miliao
//
//  Created by apple on 2022/11/2.
//

#import "MLchangphoneSettingViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "MLInTiePhoneApi.h"
#import "UIViewController+MLHud.h"
#import "UIButton+ML.h"
#import "ML_RequestManager.h"
#import "ML_QuhaoCell.h"

@interface MLchangphoneSettingViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong)UITextField *phonefield;
@property (nonatomic,strong)UITextField *codefield;
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UIButton *codebtn;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIButton *diquBtn;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)UIImageView *tbgView;
@property (nonatomic,strong)UITableView *tablview;
@property (nonatomic,assign)NSInteger seRow;
@end

@implementation MLchangphoneSettingViewController



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
    self.diquBtn.frame = CGRectMake(10, 0, size.width + 40, 53);
    [self.diquBtn setIconInRight];
    self.phonefield.frame = CGRectMake(CGRectGetMaxX(self.diquBtn.frame)+ 10, 0, ML_ScreenWidth - 32 - size.width - 50, 53);
}


- (void)diquClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (!self.dataArr.count) {
        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(27, 300, ML_ScreenWidth - 27 *2, ML_ScreenHeight - 265 - 70 - 35)];
        bgview.image = [UIImage imageNamed:@"Slice 57"];
        bgview.userInteractionEnabled = YES;
        [self.view addSubview:bgview];
        self.tbgView = bgview;

        
        
        UITableView *tablview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ML_ScreenWidth - 27 *2 - 5, bgview.height - 20) style:UITableViewStylePlain];
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



- (void)viewDidLoad {
    [super viewDidLoad];

    //self.navigationItem.title = Localized(@"账号设置", nil);
    self.ML_titleLabel.text = Localized(@"绑定手机号", nil);
    self.view.backgroundColor = UIColor.whiteColor;

    UIImageView *bgimg = [[UIImageView alloc]init];
    [bgimg setImage:kGetImage(@"changePhone")];
    bgimg.contentMode = UIViewContentModeScaleAspectFill;
    bgimg.layer.cornerRadius = bgimg.frame.size.width / 2;
    bgimg.layer.masksToBounds = YES;
    [self.view addSubview:bgimg];
    self.headImg = bgimg;
    [bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(124*mHeightScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(288*mWidthScale);
        make.height.mas_equalTo(200*mHeightScale);
    }];
    [bgimg layoutIfNeeded];

    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",Localized(@"您当前的手机号:", nil), [ML_AppUserInfoManager sharedManager].currentLoginUserData.phone]
    attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    label.attributedText = string;
//    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.alpha = 1.0;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.mas_equalTo(self.view.mas_left).mas_offset(52);
        make.top.mas_equalTo(bgimg.mas_bottom).mas_offset(50);
        make.centerX.mas_equalTo(bgimg.mas_centerX);
    }];
    
    UILabel * newLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:newLabel];
    newLabel.font = [UIFont systemFontOfSize:14];
    newLabel.textColor = kGetColor(@"999999");
    newLabel.textAlignment = NSTextAlignmentCenter;
    newLabel.text = @"更换手机号后,个人其他信息保持不变";
    [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(5*mHeightScale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    
    UIView *bottomBackView = [[UIView alloc]initWithFrame:CGRectZero];
    bottomBackView.backgroundColor = UIColor.whiteColor;
    bottomBackView.layer.cornerRadius = 16*mHeightScale;
    bottomBackView.layer.masksToBounds = YES;
    bottomBackView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(newLabel.mas_bottom).offset(20*mHeightScale);
        make.width.mas_equalTo(343*mWidthScale);
        make.height.mas_equalTo(190*mHeightScale);
    }];
    
    UIButton * phone = [[UIButton alloc]initWithFrame:CGRectZero];
    [bottomBackView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15*mWidthScale);
        make.width.mas_equalTo(80*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    [phone setImage:kGetImage(@"phontBt") forState:UIControlStateNormal];
    [phone setTitle:@"手机号码" forState:UIControlStateNormal];
    [phone setTitleColor:kGetColor(@"999999") forState:UIControlStateNormal];
    phone.titleLabel.font = [UIFont systemFontOfSize:12];
 
    UIView *phoneView = [[UIView alloc]init];
    phoneView.backgroundColor = kGetColor(@"f8f8f8");
    phoneView.layer.cornerRadius = 18*mWidthScale;
    phoneView.layer.masksToBounds = YES;
//    phoneView.layer.borderColor = [UIColor colorWithRed:204/255 green:204/255 blue:204/255 alpha:0.1].CGColor;
//    phoneView.layer.borderWidth = 0.5;
    [bottomBackView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(phone.mas_bottom).offset(5*mHeightScale);
        make.height.mas_equalTo(46*mHeightScale);
    }];
    
    UIButton *labe = [[UIButton alloc] init];
    labe.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [labe addTarget:self action:@selector(diquClick:) forControlEvents:UIControlEventTouchUpInside];
    [labe setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    [labe setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateSelected];
    labe.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [phoneView addSubview:labe];
    self.diquBtn = labe;
    [self.diquBtn setIconInRightWithSpacing:(5)];
    
    
    [ML_RequestManager requestGetPath:@"base/countryMobilePrefixList" parameters:nil doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
        
        if ([responseObject[@"code"] intValue] == 0) {
            
            self.dataArr = responseObject[@"data"][@"result"];
            
            if (self.dataArr.count && [self.dataArr isKindOfClass:[NSArray class]]) {
                
                
                [labe setImage:[UIImage imageNamed:@"Sliceirow40"] forState:UIControlStateSelected];
                [labe setImage:[UIImage imageNamed:@"Sliceirow40down"] forState:UIControlStateNormal];
                
                [labe setTitle:[NSString stringWithFormat:@"+%@", [self.dataArr firstObject][@"mobile_prefix"]] forState:UIControlStateSelected];
                [self.diquBtn setTitle:[NSString stringWithFormat:@"+%@", [self.dataArr firstObject][@"mobile_prefix"]] forState:UIControlStateNormal];

                CGSize size = [[self.diquBtn currentTitle] sizeWithFont:self.diquBtn.titleLabel.font maxSize:CGSizeMake(150, 30)];
                self.diquBtn.frame = CGRectMake(10, 0, size.width + 40, 53);
                self.phonefield.frame = CGRectMake(CGRectGetMaxX(labe.frame)+ 10, 0, ML_ScreenWidth - 32 - size.width - 50, 53);
                [self.diquBtn setIconInRight];
                
            }
        } else {
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
    UITextField *phonefield = [[UITextField alloc]init];
    phonefield.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    phonefield.placeholder = Localized(@"请输入新手机号", nil);
    phonefield.textAlignment = NSTextAlignmentLeft;
    phonefield.delegate = self;
    phonefield.tag = 1000;
    phonefield.keyboardType = UIKeyboardTypeNumberPad;
    phonefield.leftViewMode = UITextFieldViewModeAlways;
    [phoneView addSubview:phonefield];
    self.phonefield = phonefield;

    UIButton * yzm = [[UIButton alloc]initWithFrame:CGRectZero];
    [bottomBackView addSubview:yzm];
    [yzm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*mWidthScale);
        make.top.mas_equalTo(phoneView.mas_bottom).offset(15*mHeightScale);
        make.width.mas_equalTo(80*mWidthScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    [yzm setTitle:@"验证码" forState:UIControlStateNormal];
    [yzm setTitleColor:kGetColor(@"999999") forState:UIControlStateNormal];
    [yzm setImage:kGetImage(@"passW") forState:UIControlStateNormal];
    yzm.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    UIView *codeview = [[UIView alloc]init];
    codeview.backgroundColor = kGetColor(@"f8f8f8");
    codeview.layer.cornerRadius = 18*mWidthScale;
    codeview.layer.masksToBounds = YES;
    [bottomBackView addSubview:codeview];
    [codeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(yzm.mas_bottom).offset(5*mHeightScale);
        make.height.mas_equalTo(46*mHeightScale);
            
    }];

    UITextField *codefield = [[UITextField alloc]init];
    codefield.font = [UIFont systemFontOfSize:15];
    codefield.placeholder = Localized(@"请输入验证码", nil);
    codefield.keyboardType = UIKeyboardTypeNumberPad;
    codefield.delegate = self;
    codefield.tag = 2000;
    [codeview addSubview:codefield];
    self.codefield = codefield;
    [codefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(230*mWidthScale);
        make.centerY.mas_equalTo(codeview.mas_centerY);
        make.height.mas_equalTo(46*mHeightScale);
    }];

    self.codebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codebtn setTitle:Localized(@"| 获取验证码", nil) forState:UIControlStateNormal];
    self.codebtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [self.codebtn setTitleColor:kGetColor(@"ff6fb3") forState:UIControlStateNormal];
    [self.codebtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    [codeview addSubview:self.codebtn];
    [self.codebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(codefield.mas_right);
        make.top.bottom.mas_equalTo(0);
       
    }];

    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.btn setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
//    self.btn.enabled = NO;
    [self.btn setTitle:Localized(@"更换手机号", nil) forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(730*mHeightScale);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.height.mas_equalTo(48*mHeightScale);
    }];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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

    return YES;
}
-(void)btnClick{
    NSLog(@"shezhi");
    
    
    if(self.phonefield.text.length < 7) {
//            [SVProgressHUD showErrorWithStatus:Localized(@"请输入验证码", nil)];
        kplaceToast(Localized(@"请输入合法手机号", nil));
        return;
    }
    
    
    
    if (![self.codefield.text length]) {
        [self showMessage:Localized(@"验证码不能为空", nil)];
        return;
    }
    
    NSString *phoneStr = [NSString stringWithFormat:@"%@ %@", [self.diquBtn currentTitle], self.phonefield.text];
    
    MLInTiePhoneApi *api = [[MLInTiePhoneApi alloc]initWithcode:self.codefield.text extra:[self jsonStringForDictionary] token:[ML_AppUserInfoManager sharedManager].currentLoginUserData.token phone:phoneStr];
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data);
        NSLog(@"更换手机号------");
        if ([response.status integerValue] == 0) {
            
            ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:nil urlStr:@"login/logout"];
            [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    kplaceToast(Localized(@"更换手机号成功！", nil));
                });
            } error:^(MLNetworkResponse *response) {

            } failure:^(NSError *error) {
                
            }];
            
        }
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)startTime{

    
    if(self.phonefield.text.length < 7) {
//            [SVProgressHUD showErrorWithStatus:Localized(@"请输入验证码", nil)];
        kplaceToast(Localized(@"请输入合法手机号", nil));
        return;
    }
    
    
  __block int timeout= 60; //倒计时时间
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
  dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
  dispatch_source_set_event_handler(_timer, ^{
    if(timeout<=0){ //倒计时结束，关闭
      dispatch_source_cancel(_timer);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.codebtn setTitle:Localized(@"获取验证码", nil) forState:UIControlStateNormal];
        [self.codebtn setTitleColor:kZhuColor forState:UIControlStateNormal];
        self.codebtn.userInteractionEnabled = YES;
          self.codebtn.layer.borderColor = [UIColor colorWithRed:131/255 green:93/255 blue:255/255 alpha:0.1].CGColor;
          self.codebtn.layer.borderWidth = 0.5;
          self.codebtn.layer.cornerRadius = 3;
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [self.codebtn setTitle:[NSString stringWithFormat:@"%@ %d%@",Localized(@"重新发送", nil), timeout, @"s"] forState:UIControlStateNormal];
          [self.codebtn setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
        self.codebtn.clipsToBounds = YES;
        [UIView commitAnimations];
        self.codebtn.userInteractionEnabled = NO;
      });
      timeout--;
    }
  });
    [self giveCodeMessage];
  dispatch_resume(_timer);

}



-(void)viewDidLayoutSubviews{
    self.headImg.layer.cornerRadius = self.headImg.frame.size.width / 2;
    self.headImg.layer.masksToBounds = YES;
    [self.headImg layoutIfNeeded];
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField.tag == 1000) {
        NSLog(@"手机号---%@",textField.text);
        self.phonefield.text = textField.text;
    }else{
        NSLog(@"验证码---%@",textField.text);
        self.codefield.text = textField.text;
    }
}

-(void)giveCodeMessage{
    
    if(self.phonefield.text.length < 7) {
//            [SVProgressHUD showErrorWithStatus:Localized(@"请输入验证码", nil)];
        kplaceToast(Localized(@"请输入合法手机号", nil));
        return;
    }
    
    NSString *phoneStr = [NSString stringWithFormat:@"%@ %@", [self.diquBtn currentTitle], self.phonefield.text];
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"phone" : phoneStr, @"op" : @"bind"} urlStr:@"base/sendCode"];
    kSelf;
    [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
        NSLog(@"%@",response.data);
        NSLog(Localized(@"获取验证码", nil));
    } error:^(MLNetworkResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}







@end

