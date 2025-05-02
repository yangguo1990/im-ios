//
//  ML_TixianWayCollectionViewCell.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/10.
//

#import "ML_TixianWayCollectionViewCell.h"
#import "UIViewController+CurrentShowVC.h"
#import "FYBandingController.h"

@implementation ML_TixianWayCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.withDrawIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.withDrawIcon];
        [self.withDrawIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(32*mWidthScale);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(16*mWidthScale);
        }];
        
        self.withDrawName = [[UILabel alloc]initWithFrame:CGRectZero];
        self.withDrawName.font = [UIFont systemFontOfSize:12];
        self.withDrawName.textColor = kGetColor(@"000000");
        [self.contentView addSubview:self.withDrawName];
        [self.withDrawName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.withDrawIcon.mas_right).offset(10*mWidthScale);
            make.top.mas_equalTo(self.withDrawIcon.mas_top);
            make.height.mas_equalTo(16*mHeightScale);
        }];
        
        self.withDrawinfo = [[UILabel alloc]initWithFrame:CGRectZero];
        self.withDrawinfo.font = [UIFont systemFontOfSize:10];
        self.withDrawinfo.textColor = kGetColor(@"666666");
        [self.contentView addSubview:self.withDrawinfo];
        [self.withDrawinfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.withDrawIcon.mas_right).offset(10*mWidthScale);
            make.bottom.mas_equalTo(self.withDrawIcon.mas_bottom);
            make.height.mas_equalTo(16*mHeightScale);
        }];
        
        self.selectIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.selectIV];
        [self.selectIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(18*mWidthScale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-16*mWidthScale);
        }];
        
        self.bindBT = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.bindBT];
        [self.bindBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(52*mWidthScale);
            make.height.mas_equalTo(20*mHeightScale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-16*mWidthScale);
        }];
        
        self.bindBT.layer.cornerRadius = 10*mHeightScale;
        self.bindBT.layer.masksToBounds = YES;
        [self.bindBT setTitle:@"去绑定" forState:UIControlStateNormal];
        self.bindBT.backgroundColor = kGetColor(@"ac65f7");
        [self.bindBT setTitleColor:kGetColor(@"ffffff") forState:UIControlStateNormal];
        self.bindBT.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.bindBT addTarget:self action:@selector(bindBTclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)bindBTclick:(UIButton*)sender{
    UIViewController *currentVC = [UIViewController topShowViewController];
    FYBandingController *vc = [FYBandingController new];
    vc.type = self.type;
    [currentVC.navigationController pushViewController:vc animated:YES];
    [self.payView removeFromSuperview];
}



@end
