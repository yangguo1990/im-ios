//
//  ML_editeImageCollectionViewCell.m
//  SiLiaoBack
//
//  Created by 童巍 on 2025/4/11.
//

#import "ML_editeImageCollectionViewCell.h"
@interface ML_editeImageCollectionViewCell ()
@property(nonatomic,strong)UIImageView *backIV;

@end
@implementation ML_editeImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.backIV];
        [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        self.backIV.image = kGetImage(@"addImage");
        self.shanBt = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.shanBt];
        [self.shanBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.width.height.mas_equalTo(22*mWidthScale);
        }];
        [self.shanBt setBackgroundImage:kGetImage(@"shan") forState:UIControlStateNormal];
        [self.shanBt addTarget:self action:@selector(shanchu) forControlEvents:UIControlEventTouchUpInside];
        
        self.fengBt = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.fengBt];
        [self.fengBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(56*mWidthScale);
            make.height.mas_equalTo(16*mHeightScale);
            make.left.mas_equalTo(8*mWidthScale);
            make.bottom.mas_equalTo(-10*mHeightScale);
        }];
        self.fengBt.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
        [self.fengBt setTitle:@"设置封面" forState:UIControlStateNormal];
        [self.fengBt setTitleColor:kGetColor(@"ffffff") forState:UIControlStateNormal];
        self.fengBt.titleLabel.font = [UIFont systemFontOfSize:10];
        self.fengBt.layer.cornerRadius = 8*mHeightScale;
        self.fengBt.layer.masksToBounds = YES;
        [self.fengBt addTarget:self action:@selector(shezhi:) forControlEvents:UIControlEventTouchUpInside];
        self.contentView.layer.cornerRadius = 10*mWidthScale;
        self.contentView.layer.masksToBounds = YES;
        
        self.fengLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.fengLabel];
        self.fengLabel.textColor = UIColor.whiteColor;
        self.fengLabel.text = @"封面";
        self.fengLabel.font = [UIFont systemFontOfSize:10];
        self.fengLabel.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
        [self.fengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(30*mWidthScale);
            make.height.mas_equalTo(15*mHeightScale);
        }];
        
        
    }
    return self;
}

- (void)shezhi:(UIButton*)sender{
    for (NSDictionary *dic in self.photos) {
        [dic setValue:@(self.index) forKey:@"isFirst"];
    }
    self.fengBt.hidden = YES;
    self.fengLabel.hidden = NO;
    self.cellBolock();
}

- (void)shanchu{
    [self.photos removeObject:self.dataDic];
    self.backIV.image = kGetImage(@"addImage");
    self.shanBt.hidden = YES;
    self.fengBt.hidden = YES;
    self.cellBolock();
}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSLog(@"datadic is %@",dataDic);
    [self.backIV sd_setImageWithURL:kGetUrlPath(dataDic[@"icon"]) placeholderImage:kGetImage(@"addImage")];
    if (self.index == [dataDic[@"isFirst"] integerValue]) {
        self.fengBt.hidden = YES;
        self.fengLabel.hidden = NO;
    }else{
        self.fengBt.hidden = NO;
        self.fengLabel.hidden = YES;
    }
}
@end
