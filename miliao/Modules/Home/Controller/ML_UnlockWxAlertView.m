//
//  ML_UnlockWxAlertView.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/7.
//

#import "ML_UnlockWxAlertView.h"
#import "UIViewController+MLHud.h"
@interface ML_UnlockWxAlertView ()
@property(nonatomic,copy)NSString* userId;
@end

@implementation ML_UnlockWxAlertView

+(ML_UnlockWxAlertView*)showWithUnlock:(BOOL)isUnlock dic:(nonnull NSDictionary *)dic userId:(NSString *)userId{
    ML_UnlockWxAlertView * alertView = [[ML_UnlockWxAlertView alloc]initWithFrame:CGRectMake(0, 0, 270*mWidthScale, 276*mHeightScale) unlock:isUnlock dic:dic userId:userId];
    
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    alertView.center = CGPointMake(ML_ScreenWidth/2, 370*mHeightScale);
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame unlock:(BOOL)isUnlock dic:(NSDictionary*)dic userId:(NSString *)userId{
    if (self = [super initWithFrame:frame]) {
        self.userId = userId;
        self.dic = dic;
        UIImageView *backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backIV.image = kGetImage(@"wxAlertBG");
        backIV.userInteractionEnabled = YES;
        [self addSubview:backIV];
        UIImageView *topIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:topIV];
        [topIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_top);
            make.width.height.mas_equalTo(80*mWidthScale);
        }];
        topIV.image = kGetImage(@"wxTop");
        
        UIImageView *iv1 = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:iv1];
        [iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(topIV.mas_centerX);
            make.top.mas_equalTo(topIV.mas_bottom).offset(10*mHeightScale);
        }];
        iv1.image = kGetImage(@"wxLabel");
        if (!isUnlock) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.top.mas_equalTo(iv1.mas_bottom).offset(10*mHeightScale);
                make.width.mas_equalTo(240*mWidthScale);
                make.height.mas_equalTo(24*mHeightScale);
            }];
            label.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
            label.layer.cornerRadius = 12*mHeightScale;
            label.layer.masksToBounds = YES;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.whiteColor;
            label.text = @"赠送金币解锁主播微信号哟~";
            
            UIImageView *coinIV = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:coinIV];
            [coinIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.width.height.mas_equalTo(80*mWidthScale);
                make.top.mas_equalTo(label.mas_bottom).offset(10*mHeightScale);
            }];
            coinIV.image = kGetImage(@"wxCoin");
            
            UILabel * coinNO = [[UILabel alloc]initWithFrame:CGRectZero];
            [self addSubview:coinNO];
            [coinNO mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.height.mas_equalTo(24*mHeightScale);
                make.top.mas_equalTo(coinIV.mas_bottom).offset(-10*mHeightScale);
                make.width.mas_equalTo(80*mWidthScale);
            }];
            coinNO.text = [NSString stringWithFormat:@"%@",self.dic[@"wxCoin"]];
            coinNO.textColor = kGetColor(@"ff6fb3");
            coinNO.font = [UIFont systemFontOfSize:10];
            coinNO.textAlignment = NSTextAlignmentCenter;
            coinNO.backgroundColor = UIColor.whiteColor;
            coinNO.layer.cornerRadius = 12*mHeightScale;
            coinNO.layer.masksToBounds = YES;
            
            UIButton * jiesuoBT = [[UIButton alloc]initWithFrame:CGRectZero];
            [self addSubview:jiesuoBT];
            [jiesuoBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(238*mWidthScale);
                make.height.mas_equalTo(48*mHeightScale);
                make.top.mas_equalTo(coinNO.mas_bottom).offset(5*mHeightScale);
            }];
            [jiesuoBT setBackgroundImage:kGetImage(@"buttonBG1") forState:UIControlStateNormal];
            [jiesuoBT setTitle:@"送礼解锁" forState:UIControlStateNormal];
            [jiesuoBT setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            jiesuoBT.titleLabel.font = [UIFont systemFontOfSize:16];
            [jiesuoBT addTarget:self action:@selector(jiesuoBtClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            [self addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16*mWidthScale);
                make.height.mas_equalTo(28*mHeightScale);
                make.top.mas_equalTo(iv1.mas_bottom).offset(20*mHeightScale);
            }];
            nameLabel.textColor = kGetColor(@"000000");
            nameLabel.font = [UIFont systemFontOfSize:20];
            nameLabel.text = self.dic[@"name"];
            UIButton *agebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            agebtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
            agebtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
            [agebtn setImage:[UIImage imageNamed:@"female"] forState:UIControlStateNormal];
            [agebtn setImage:[UIImage imageNamed:@"male"] forState:UIControlStateSelected];
            [agebtn setTitleColor:[UIColor colorWithHexString:@"#FF458E"] forState:UIControlStateNormal];
            [agebtn setTitleColor:[UIColor colorWithHexString:@"#4DA6FF"] forState:UIControlStateSelected];
            [self addSubview:agebtn];
            [agebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameLabel.mas_right).offset(2);
                make.centerY.mas_equalTo(nameLabel.mas_centerY);
                make.width.mas_equalTo(40*mWidthScale);
                make.height.mas_equalTo(16*mHeightScale);
            }];
            
            
            UIImageView *realIV = [[UIImageView alloc]init];
            realIV.image = [UIImage imageNamed:@"isreal"];
            [self addSubview:realIV];
            [realIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(agebtn.mas_right).mas_offset(5);
                make.centerY.mas_equalTo(agebtn.mas_centerY);
                make.height.mas_equalTo(12);
                make.width.mas_equalTo(32);
            }];
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectZero];
            [self addSubview:label1];
            label1.text = @"主播微信号码";
            label1.font = [UIFont systemFontOfSize:12];
            label1.textColor = kGetColor(@"666666");
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameLabel.mas_left);
                make.top.mas_equalTo(nameLabel.mas_bottom).offset(10*mHeightScale);
                make.height.mas_equalTo(12*mHeightScale);
            }];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectZero];
            [self addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label1.mas_left);
                make.right.mas_equalTo(-16*mWidthScale);
                make.top.mas_equalTo(label1.mas_bottom).offset(10*mHeightScale);
                make.height.mas_equalTo(34*mHeightScale);
            }];
            label2.text = self.dic[@"wxNo"];
            label2.textColor = kGetColor(@"1d2129");
            label2.font = [UIFont systemFontOfSize:15];
            label2.layer.borderColor = kGetColor(@"949494").CGColor;
            label2.layer.borderWidth = 0.5;
            label2.layer.cornerRadius = 8*mHeightScale;
            
            UIButton *copy = [[UIButton alloc]initWithFrame:CGRectZero];
            [self addSubview:copy];
            [copy mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(label2.mas_centerY);
                make.right.mas_equalTo(-40*mWidthScale);
                make.width.mas_equalTo(60*mWidthScale);
                make.height.mas_equalTo(16*mHeightScale);
            }];
            [copy setBackgroundImage:kGetImage(@"copy") forState:UIControlStateNormal];
            [copy addTarget:self action:@selector(copyClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton * sureBT = [[UIButton alloc]initWithFrame:CGRectZero];
            [self addSubview:sureBT];
            [sureBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(238*mWidthScale);
                make.height.mas_equalTo(48*mHeightScale);
                make.top.mas_equalTo(label2.mas_bottom).offset(20*mHeightScale);
            }];
            [sureBT setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
            [sureBT setTitle:@"确定" forState:UIControlStateNormal];
            [sureBT setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            sureBT.titleLabel.font = [UIFont systemFontOfSize:16];
            [sureBT addTarget:self action:@selector(sureBtClick) forControlEvents:UIControlEventTouchUpInside];
            
        }

        UILabel * bottomLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20*mHeightScale);
        }];
        bottomLabel.text = @"解锁主播微信号为私人行为,与平台无关";
        bottomLabel.textColor = kGetColor(@"ff0000");
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

- (void)sureBtClick{
    [self removeFromSuperview];
}

- (void)jiesuoBtClick:(UIButton*)sender{
    
    if (![self.dic[@"coinCode"] boolValue]) {
        [self removeFromSuperview];
        kplaceToast(@"金币不足");
    
        return;
    }
    ML_CommonApi *api = [[ML_CommonApi alloc] initWithPDic:@{@"toUserId" : self.userId} urlStr:@"host/unlockWechat"];
     kSelf;
     [api networkWithCompletionSuccess:^(MLNetworkResponse *response) {

         kplaceToast(@"解锁成功");
         [weakself removeFromSuperview];
         [ML_UnlockWxAlertView showWithUnlock:YES dic:self.dic userId:self.userId];
         
     } error:^(MLNetworkResponse *response) {



     } failure:^(NSError *error) {

     }];
}

- (void)copyClick:(UIButton *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.dic[@"wxNo"];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

@end
