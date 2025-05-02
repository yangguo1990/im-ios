//
//  ZMPayItemView.m
//  SiLiaoBack
//
//  Created by tg on 2023/8/13.
//

#import "ZMPayItemView.h"


@interface ZMPayItemView ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation ZMPayItemView



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
    [self addSubview:self.selectBtn];
    
    CGFloat h = 45;
    self.icon.frame = CGRectMake(0, 5, 36, 36);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@(h));
    }];
}

- (UIImageView *)icon{
    if (_icon) return _icon;
    _icon = [UIImageView new];
    
    return _icon;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_gouxuan_16_selCC"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_gouxuan_16_sel"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selectBtn;
}

- (void)selectAction:(UIButton *)button{
    if (!button.selected) {
        if (self.selectBlock){
            self.selectBlock(button.tag);
        }
    }
}

- (void)refreshViewWithIcon:(NSString *)icon title:(NSString *)title tag:(NSInteger )tag{
    [self.icon sd_setImageWithURL:kGetUrlPath(icon)];
    self.titleLab.text = title;
    
    self.selectBtn.tag = tag;
}

- (void)setSelected:(BOOL)selected{
    self.selectBtn.selected = selected;
}



@end
