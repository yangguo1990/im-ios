//
//  MLChangePhoneViewController.m
//  miliao
//
//  Created by apple on 2022/11/2.
//

#import "MLChangePhoneViewController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import "MLchangphoneSettingViewController.h"

@interface MLChangePhoneViewController ()

@end

@implementation MLChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ML_titleLabel.text = Localized(@"绑定手机号", nil);
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIImageView *bgimg = [[UIImageView alloc]init];
    bgimg.image = [UIImage imageNamed:@"changePhone"];
    [self.view addSubview:bgimg];
    [bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(124*mHeightScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(288*mWidthScale);
        make.height.mas_equalTo(200*mHeightScale);
    }];

    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    
    label.text = [NSString stringWithFormat:@"%@ %@",Localized(@"您当前的手机号:", nil), [ML_AppUserInfoManager sharedManager].currentLoginUserData.phone];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.mas_equalTo(self.view.mas_left).mas_offset(52);
        make.top.mas_equalTo(bgimg.mas_bottom).mas_offset(50);
        make.centerX.mas_equalTo(bgimg.mas_centerX);
    }];
    
    UILabel *bottomlabel = [[UILabel alloc] init];
    bottomlabel.numberOfLines = 0;
    NSMutableAttributedString *bottomstring = [[NSMutableAttributedString alloc] initWithString:Localized(@"更换手机号后，个人其他信息保持不变", nil)attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    bottomlabel.attributedText = bottomstring;
    bottomlabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    bottomlabel.textAlignment = NSTextAlignmentCenter;
    bottomlabel.alpha = 1.0;
    [self.view addSubview:bottomlabel];
    [bottomlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgimg.mas_centerX);
        make.top.mas_equalTo(label.mas_bottom).mas_offset(16);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.layer.backgroundColor = kZhuColor.CGColor;
//    btn.layer.cornerRadius = 8;
    [btn setBackgroundImage:kGetImage(@"buttonBG") forState:UIControlStateNormal];
    [btn setTitle:Localized(@"更换手机号", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(730*mHeightScale);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-16);
        make.height.mas_equalTo(48*mHeightScale);
    }];

}

-(void)btnClick{
    NSLog(@"shezhi");
    MLchangphoneSettingViewController *vc = [[MLchangphoneSettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
