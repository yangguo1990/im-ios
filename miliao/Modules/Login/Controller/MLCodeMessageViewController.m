//
//  MLCodeMessageViewController.m
//  miliao
//
//  Created by apple on 2022/8/23.
//

#import "MLCodeMessageViewController.h"
#import <Masonry/Masonry.h>
#import <CRBoxInputView/CRBoxInputView.h>
#import <JKCountDownButton/JKCountDownButton.h>
#import<CommonCrypto/CommonDigest.h>
#import "MLCodeApi.h"
#import "MLLoginApi.h"
#import "MLUserMessageViewController.h"
#import "MLTabbarViewController.h"
#import "MLFriendModelViewController.h"
#import "MLNavViewController.h"
#import "SiLiaoBack-Swift.h"
@interface MLCodeMessageViewController ()

@property (nonatomic,strong)JKCountDownButton *countDownCode;
@property (nonatomic,copy)NSString *codestr;
@property (nonatomic,strong)UILabel *textlabelindex;

@end

@implementation MLCodeMessageViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self giveMLCodeApi];
    [self becomeFirstResponder];
}

-(void)giveMLCodeApi{
}

//手机验证码登录------
-(void)giveMLLoginApi{
    if (self.isEm) {
        
        
           kSelf;
           MLLoginApi *api = [[MLLoginApi alloc] initWithtype:@"4" thirdId:self.phonestr accessToken:@"" code:self.codestr dev:@"" yiToken:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
           [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {
                   NSLog(@"登录----%@--%@--%@",response.data,response.msg,response.status);
       //        [weakself.loginView cancelclick];
   
               [SVProgressHUD dismiss];
               if (response.data[@"user"]) { //有填写 无填写
                   UserInfoData * currentData = [UserInfoData mj_objectWithKeyValues:response.data[@"user"]];
                   currentData.domain = response.data[@"domain"]?:@"";
                   currentData.thirdId = response.data[@"thirdId"]?:@"";
                   [ML_AppUserInfoManager sharedManager].currentLoginUserData = currentData;
//                   if([response.data[@"trait"] boolValue] == 1){
                       MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
   
                           [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
 
               }  else if ([response.status intValue] == 20){
   
   
               } else if ([response.status intValue] == 0){
                   MLUserMessageViewController *vc = [[MLUserMessageViewController alloc]init];
                   vc.phonestr = response.data[@"thirdId"];
                   vc.type = @"thirdId";
   
//                   [weakself.navigationController pushViewController:vc animated:YES];
                   MLNavViewController *navVC = [[MLNavViewController alloc] initWithRootViewController:vc];
                   [[AppDelegate shareAppDelegate] setupRootViewController:navVC];
               }
           } error:^(MLNetworkResponse *response) {
   
               [SVProgressHUD dismiss];
               NSLog(@"登录----%@--%@--%@",response.data,response.msg,response.status);
           } failure:^(NSError *error) {
               [SVProgressHUD dismiss];
   
           }];
        
        return;
    }
     
     
    
    MLLoginApi *api = [[MLLoginApi alloc]initWithtype:@"0" thirdId:self.phonestr accessToken:@"" code:self.codestr dev:@"" yiToken:@"" nonce:(NSNumber *)[NSString stringWithFormat:@"%.4d", (arc4random() % 10000)] currTime:[self giveformatter] checkSum:[self shaData] extra:[self jsonStringForDictionary]];
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


        //                if([response.data[@"trait"] boolValue] == 1){
                        MLTabbarViewController *mainTab = [[MLTabbarViewController alloc] init];
        //                    KEY_WINDOW.window.rootViewController = mainTab;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AppDelegate shareAppDelegate] setupRootViewController:mainTab];
                    });
                }else{
                    //rtc登录失败
                    [SVProgressHUD showInfoWithStatus:@"IM登录失败"];
                }
            }];

        } else {
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
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"登录失败:%@",error.localizedDescription]];
        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.ML_navView.hidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.ML_backBtn setImage:kGetImage(@"icon_back_24_FFF_nor_1") forState:UIControlStateNormal];
    
    self.codestr = @"";
    UILabel *tlabel = [[UILabel alloc]init];
    tlabel.text = Localized(@"请输入验证码", nil);
    tlabel.textAlignment = NSTextAlignmentLeft;
    tlabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    tlabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [self.view addSubview:tlabel];
    [tlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(28);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(124);
    }];
    
    UILabel *mlabel = [[UILabel alloc]init];
    mlabel.text = [NSString stringWithFormat:@"%@ %@",Localized(@"验证码已发送至", nil), self.phonestr];
    mlabel.textAlignment = NSTextAlignmentLeft;
    mlabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    mlabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.view addSubview:mlabel];
    [mlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(28);
        make.top.mas_equalTo(tlabel.mas_bottom).mas_offset(4);
    }];
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.cellBgColorNormal = [UIColor whiteColor];
    cellProperty.cellBgColorSelected = [UIColor whiteColor];
    cellProperty.cellBorderColorNormal = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    //cellProperty.cellBorderColorNormal = UIColor.redColor;
    //cellProperty.cellBorderColorSelected = [UIColor colorWithRed:255/255.0 green:70/255.0 blue:62/255.0 alpha:1];
    cellProperty.cellBorderColorSelected = UIColor.blackColor;

    cellProperty.cornerRadius = 5;
    cellProperty.borderWidth = 1;
    
    CRBoxInputView *boxInputView = [[CRBoxInputView alloc] init];
    boxInputView.boxFlowLayout.itemSize = CGSizeMake(50, 66);
    boxInputView.customCellProperty = cellProperty;
    //boxInputView.backgroundColor = UIColor.redColor;
    boxInputView.mainCollectionView.scrollEnabled = NO;
    boxInputView.keyBoardType = UIKeyboardTypeNumberPad;
    [boxInputView loadAndPrepareViewWithBeginEdit:YES];
    boxInputView.ifNeedCursor = NO;
    boxInputView.textContentType = UITextContentTypeOneTimeCode;
    [self.view addSubview:boxInputView];
    boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        NSLog(@"text:------%@", text);
        self.codestr = text;
        if (self.codestr.length == 4) {
            [self giveMLLoginApi];
        }
    };
    // 方法2, 普通的只读属性
    //NSLog(@"textValue:%@", boxInputView.textValue);
    // 清空
    [boxInputView clearAllWithBeginEdit:YES]; // BeginEdit:清空后是否自动启用编辑模式
    [self.view addSubview:boxInputView];
    [boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-70);
        make.top.mas_equalTo(mlabel.mas_bottom).mas_offset(28);
        make.height.mas_equalTo(66);
    }];
    
    
    UILabel *textlabelindex = [[UILabel alloc]init];
    textlabelindex.text = Localized(@"重新发送", nil);
    textlabelindex.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    textlabelindex.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.view addSubview:textlabelindex];
    self.textlabelindex = textlabelindex;
    [textlabelindex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(27);
        make.top.mas_equalTo(boxInputView.mas_bottom).mas_offset(22);
    }];
        
    _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [_countDownCode startCountDownWithSecond:60];
    //[_countDownCode setTitleColor:[UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:1]
                         //forState:UIControlStateNormal];
    [_countDownCode setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _countDownCode.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _countDownCode.enabled = NO;
    [_countDownCode countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            self->_countDownCode.enabled = YES;
            NSLog(@"7777");
        self.textlabelindex.hidden = YES;
        [self->_countDownCode mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
            return Localized(@"重新获取", nil);;
    }];
    [self.view addSubview:_countDownCode];
    [_countDownCode countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        NSLog(@"88888");
        [self->_countDownCode mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
        }];
        self.textlabelindex.hidden = NO;
        self.countDownCode.enabled = NO;
        [self->_countDownCode startCountDownWithSecond:60];
        [self giveMLCodeApi];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            self->_countDownCode.enabled = YES;
            NSLog(@"6666");
            self.textlabelindex.hidden = YES;
            [self->_countDownCode mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(80);
            }];
            return Localized(@"重新获取", nil);;
        }];
    }];

    [_countDownCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textlabelindex.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(textlabelindex.mas_centerY).mas_offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(26);
    }];
        
}










@end
