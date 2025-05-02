//
//  ML_DuiCollectionViewCell.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/10.
//

#import "ML_DuiCollectionViewCell.h"

@interface ML_DuiCollectionViewCell ()
@property(nonatomic,strong)UIImageView *backGroundIV;
@property(nonatomic,strong)UIImageView *coinIV;
@property(nonatomic,strong)UILabel *coinLabel;
@property(nonatomic,strong)UILabel *jifenLabel;
@end
@implementation ML_DuiCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backGroundIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.backGroundIV];
    [self.backGroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    self.backGroundIV.layer.cornerRadius = 8*mWidthScale;
    self.backGroundIV.layer.masksToBounds = YES;
    
    self.coinIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.coinIV];
    [self.coinIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(8*mWidthScale);
        make.width.height.mas_equalTo(40*mWidthScale);
    }];
    self.coinIV.image = kGetImage(@"wxCoin");
    
    self.coinLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.coinLabel];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coinIV.mas_right).offset(10*mWidthScale);
        make.top.mas_equalTo(self.coinIV.mas_top);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    self.coinLabel.textColor = kGetColor(@"000000");
    self.coinLabel.font = [UIFont boldSystemFontOfSize:18];
    
    self.jifenLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.jifenLabel];
    [self.jifenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coinIV.mas_right).offset(10*mWidthScale);
        make.bottom.mas_equalTo(self.coinIV.mas_bottom);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    self.jifenLabel.textColor = kGetColor(@"a9a9ab");
    self.jifenLabel.font = [UIFont systemFontOfSize:12];
}


-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.host boolValue]){
        self.coinLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"amount"]];
    }else{
        self.coinLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"coin"]];
    }
    
    self.jifenLabel.text = [NSString stringWithFormat:@"积分:%@", dataDic[@"credit"]];
}


- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.coinLabel.textColor = kGetColor(@"ffffff");
        self.jifenLabel.textColor = kGetColor(@"ffffff");
        self.backGroundIV.image = kGetImage(@"duiCellBack");
    }else{
        self.coinLabel.textColor = kGetColor(@"000000");
        self.jifenLabel.textColor = kGetColor(@"a9a9ab");
        self.backGroundIV.image = nil;
        self.backGroundIV.backgroundColor = kGetColor(@"f8f8f8");
    }
}
@end
