//
//  ML_MineBottomReusableView.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/6.
//

#import "ML_MineBottomReusableView.h"

@implementation ML_MineBottomReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(58*mHeightScale);
        make.height.mas_equalTo(64*mHeightScale);
    }];
    imageView.image = kGetImage(@"mineBack");
}
@end
