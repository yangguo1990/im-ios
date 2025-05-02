//
//  ML_kaitongTopCollectionViewCell.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/6.
//

#import "ML_kaitongTopCollectionViewCell.h"

@implementation ML_kaitongTopCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIImageView *backIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:backIV];
    self.backIV = backIV;
    [backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(321*mWidthScale);
        make.height.mas_equalTo(144*mHeightScale);
    }];
}
@end
