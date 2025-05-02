//
//  MLHomeOnlineBottomView.m
//  miliao
//
//  Created by apple on 2022/11/15.
//

#import "MLHomeOnlineBottomView.h"
#import <Masonry/Masonry.h>
#import "Colours/Colours.h"
#import "UIAlertView+NTESBlock.h"
#import "ML_RequestManager.h"
#import "MLMineFaceViewController.h"
@interface MLHomeOnlineBottomView()


@end


@implementation MLHomeOnlineBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self setUp];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onlineTap)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

#pragma mark -


- (void)setUp{
    
    UIImageView *onlineImg = [[UIImageView alloc]init];
    onlineImg.image = [UIImage imageNamed:@"pop_up_online_pairing"];//
    [self addSubview:onlineImg];
    [onlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self);
//        make.right.mas_equalTo(self.mas_right);
//        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-32);
//        make.width.mas_equalTo(160);
//        make.height.mas_equalTo(48);
    }];

//    UIImageView *onboyImg = [[UIImageView alloc]init];
//    onboyImg.contentMode = UIViewContentModeScaleAspectFill;
//    onboyImg.layer.masksToBounds = YES;
//    onboyImg.layer.cornerRadius = 9;
//    onboyImg.layer.borderWidth = 0.5;
//    onboyImg.layer.borderColor = [kGetColor(@"#ffffff") CGColor]; // 边框
//    onboyImg.image = [UIImage imageNamed:@"Ellipse 24"];
//    [onlineImg addSubview:onboyImg];
//    [onboyImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(onlineImg.mas_left).mas_offset(6);
//        make.centerY.mas_equalTo(onlineImg.mas_centerY);
//        make.width.mas_equalTo(18);
//        make.height.mas_equalTo(18);
//    }];
//
//    UIImageView *ongirlImg = [[UIImageView alloc]init];
//    ongirlImg.contentMode = UIViewContentModeScaleAspectFill;
//    ongirlImg.layer.masksToBounds = YES;
//    ongirlImg.layer.cornerRadius = 9;
//    ongirlImg.layer.borderWidth = 0.5;
//    ongirlImg.layer.borderColor = [kGetColor(@"#ffffff") CGColor]; // 边框
//    ongirlImg.image = [UIImage imageNamed:@"Ellipse 24"];
//    [onlineImg addSubview:ongirlImg];
//    [ongirlImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(onboyImg.mas_right).mas_offset(4);
//        make.centerY.mas_equalTo(onlineImg.mas_centerY);
//        make.width.mas_equalTo(18);
//        make.height.mas_equalTo(18);
//    }];
//
//    UILabel *tnameLabel = [[UILabel alloc]init];
//    tnameLabel.text = Localized(@"在线配对", nil);
//    tnameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
//    tnameLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
//    [onlineImg addSubview:tnameLabel];
//    [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(ongirlImg.mas_right).mas_offset(9);
//        make.bottom.mas_equalTo(ongirlImg.mas_centerY).mas_offset(0);
//    }];
//
//
//    UILabel *tonameLabel = [[UILabel alloc]init];
//    tonameLabel.text = Localized(@"遇见有趣的人", nil);
//    tonameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
//    tonameLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
//    [onlineImg addSubview:tonameLabel];
//    [tonameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(ongirlImg.mas_right).mas_offset(9);
//        make.top.mas_equalTo(ongirlImg.mas_centerY).mas_offset(0);
//    }];
    
    //
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn addTarget:self action:@selector(guanClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:kGetImage(@"icon_guanbi_24_FFF_nor") forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.height.mas_equalTo(12*mHeightScale);
    }];
    
}

-(void)onlineTap{
    
    if (![[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue] && [[ML_AppUserInfoManager sharedManager].currentLoginUserData.gender intValue] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localized(@"认证成为主播才能进行在线匹配哦！", nil) message:nil delegate:nil cancelButtonTitle:Localized(@"取消", nil) otherButtonTitles:Localized(@"确定", nil), nil];
        [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
            switch (alertIndex) {
                case 1:
                {
                    [SVProgressHUD show];
                   [ML_RequestManager requestPath:@"user/getUserSimpleInfo" parameters:@{@"token":[ML_AppUserInfoManager sharedManager].currentLoginUserData.token} doneBlockWithSuccess:^(NSDictionary * _Nonnull responseObject) {
                        NSDictionary *hostdict = responseObject[@"data"][@"user"];
                       
                       [SVProgressHUD dismiss];
                        MLMineFaceViewController *vc = [[MLMineFaceViewController alloc]init];
                        vc.dict = hostdict;
                        [[UIViewController topShowViewController].navigationController pushViewController:vc animated:YES];


                   } failure:^(NSError * _Nonnull error) {
                       
                       [SVProgressHUD dismiss];

                   }];
                    
                    break;
                }
                default:
                    break;
            }
        }];
        
        return;
    }
    
    self.sure_block();
}

- (void)guanClick:(UIButton *)btn
{
    [btn.superview removeFromSuperview];
}


@end
