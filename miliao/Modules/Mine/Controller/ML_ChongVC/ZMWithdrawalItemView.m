//
//  ZMWithdrawalItemView.m
//  SiLiaoBack
//
//  Created by tg on 2023/8/14.
//

#import "ZMWithdrawalItemView.h"

@interface ZMWithdrawalItemView ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *accIcon;

@property (nonatomic, strong) UIButton *bindBtn;

@end

@implementation ZMWithdrawalItemView



- (instancetype)init{
    self = [super init];
    [self setupView];
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView{
    [self addSubview:self.icon];
    [self addSubview:self.titleLab];
    [self addSubview:self.bindBtn];
    [self addSubview:self.accIcon];
    
    
    self.icon.frame = CGRectMake(0, 5, 36, 36);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accIcon.mas_left);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.accIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@24);
    }];
}

- (UIImageView *)icon{
    if (_icon) return _icon;
    _icon = [UIImageView new];
    
    return _icon;
}
- (UIImageView *)accIcon{
    if (_accIcon) return _accIcon;
    _accIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back_24_FFF_nor-3"]];
    
    return _accIcon;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}


- (UIButton *)bindBtn{
    if (!_bindBtn) {
        _bindBtn = [[UIButton alloc] init];
        _bindBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_bindBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_bindBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        [_bindBtn setTitle:@"未绑定" forState:UIControlStateNormal];
        [_bindBtn setTitle:@"已绑定" forState:UIControlStateSelected];
        _bindBtn.userInteractionEnabled = NO;
    }
    return _bindBtn;
}


- (void)refreshViewWithIcon:(NSString *)icon title:(NSString *)title bind:(BOOL)bind{
    self.icon.image = [UIImage imageNamed:icon];
    self.titleLab.text = title;
    
    self.bindBtn.selected = bind;
}



- (void)setSelected:(BOOL)selected{
    self.bindBtn.selected = selected;
}


@end
