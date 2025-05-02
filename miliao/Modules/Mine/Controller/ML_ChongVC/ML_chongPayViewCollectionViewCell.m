//
//  ML_chongPayViewCollectionViewCell.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/10.
//

#import "ML_chongPayViewCollectionViewCell.h"

@interface ML_chongPayViewCollectionViewCell ()
@property(nonatomic,strong)UIImageView *payicon;
@property(nonatomic,strong)UIImageView *backIV;
@property(nonatomic,strong)UILabel *payName;
@end

@implementation ML_chongPayViewCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.backIV.layer.cornerRadius = 12*mWidthScale;
        self.backIV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backIV];
        [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        UIImageView * payIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.payicon = payIcon;
        [self.contentView addSubview:payIcon];
        [payIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(32*mWidthScale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(12*mWidthScale);
        }];
        
        self.payName = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.payName];
        [self.payName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.payicon.mas_right).offset(10*mWidthScale);
            make.height.mas_equalTo(22*mHeightScale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.payName.font = [UIFont systemFontOfSize:16];
        
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [self.payicon sd_setImageWithURL:kGetUrlPath(dataDic[@"logo"])];
    self.payName.text = dataDic[@"name"];
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.payName.textColor = kGetColor(@"ffffff");
        self.backIV.image = kGetImage(@"chongCellBG");
    }else{
        self.payName.textColor = kGetColor(@"000000");
        self.backIV.image = nil;
        self.backIV.backgroundColor = kGetColor(@"f8f8f8");
    }
    
    
    
}

@end
