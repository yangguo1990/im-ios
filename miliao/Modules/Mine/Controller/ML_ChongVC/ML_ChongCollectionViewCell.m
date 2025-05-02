//
//  ML_ChongCollectionViewCell.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/10.
//

#import "ML_ChongCollectionViewCell.h"
#import "UIButton+ML.h"
@interface ML_ChongCollectionViewCell ()
@property(nonatomic,strong)UIImageView *topIV;
@property(nonatomic,strong)UIImageView *backGroundIV;
@property(nonatomic,strong)UIButton *coinBt;
@property(nonatomic,strong)UILabel *songLabel;
@property(nonatomic,strong)UILabel *moneylabel;
@end

@implementation ML_ChongCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    UIImageView *backGroundIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:backGroundIV];
    backGroundIV.layer.cornerRadius = 12*mWidthScale;
    backGroundIV.layer.masksToBounds = YES;
    self.backGroundIV = backGroundIV;
    [backGroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    
    UIImageView *topIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:topIV];
    self.topIV = topIV;
    [topIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(50*mWidthScale);
        make.height.mas_equalTo(16*mHeightScale);
    }];
    
    UIButton *coinBt = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:coinBt];
    [coinBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(topIV.mas_bottom).offset(5);
        make.height.mas_equalTo(40*mHeightScale);
    }];
    [coinBt setTitleColor:kGetColor(@"000000") forState:UIControlStateNormal];
    coinBt.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [coinBt setImage:kGetImage(@"coin") forState:UIControlStateNormal];
    coinBt.enabled = NO;
    self.coinBt = coinBt;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = kGetColor(@"fee4f1");
    label.layer.cornerRadius = 8*mHeightScale;
    label.layer.masksToBounds = YES;
    label.textColor = kGetColor(@"ff6fb3");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    self.songLabel = label;
    [self.contentView addSubview:label];
    [self.songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24*mWidthScale);
        make.right.mas_equalTo(-24*mWidthScale);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectZero];
    money.textColor = kGetColor(@"ff6fb3");
    money.font = [UIFont boldSystemFontOfSize:16];
    money.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:money];
    self.moneylabel = money;
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(label.mas_bottom).offset(20*mHeightScale);
        make.height.mas_equalTo(21*mHeightScale);
    }];
}


- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    if ([dataDic[@"hot"] intValue] == 1) {
        self.topIV.image = kGetImage(@"Slice 601");
    } else if ([dataDic[@"hot"] intValue] == 2) {
        self.topIV.image = kGetImage(@"Slice 602");
    } else if ([dataDic[@"hot"] intValue] == 3) {
        self.topIV.image = kGetImage(@"Slice 603");
    }
    [self.coinBt setTitle:[NSString stringWithFormat:@"%@", dataDic[@"coin"]] forState:UIControlStateNormal];
    [self.coinBt setIconInRightWithSpacing:5];
    self.moneylabel.text = [NSString stringWithFormat:@"￥%@",dataDic[@"amount"]];
    if ([[ML_AppUserInfoManager sharedManager].currentLoginUserData.identity boolValue]) {
        self.songLabel.text = [NSString stringWithFormat:@"%@%ld%@", Localized(@"额外赠送", nil), [dataDic[@"aliapyGivenCoin"] integerValue] + [dataDic[@"vipGivenCoin"] integerValue], Localized(@"金币", nil)];
        
        
        if ([dataDic[@"aliapyGivenCoin"] integerValue] + [dataDic[@"vipGivenCoin"] integerValue] > 0) {
            self.songLabel.hidden = NO;
        } else {
            self.songLabel.hidden = YES;
        }
        
    } else {
        self.songLabel.text = [NSString stringWithFormat:@"%@%ld%@", Localized(@"额外赠送", nil), [dataDic[@"aliapyGivenCoin"] integerValue], Localized(@"金币", nil)];
        if ([dataDic[@"aliapyGivenCoin"] integerValue]) {
            self.songLabel.hidden = NO;
        } else {
            self.songLabel.hidden = YES;
        }
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        [self.coinBt setTitleColor:kGetColor(@"ffffff") forState:UIControlStateNormal];
        self.moneylabel.textColor = kGetColor(@"ffffff");
        self.backGroundIV.image = kGetImage(@"chongCellBG");
    }else{
        [self.coinBt setTitleColor:kGetColor(@"000000") forState:UIControlStateNormal];
        self.moneylabel.textColor = kGetColor(@"ff6fb3");
        self.backGroundIV.image = nil;
        self.backGroundIV.backgroundColor = kGetColor(@"f8f8f8");
    }
}
@end
