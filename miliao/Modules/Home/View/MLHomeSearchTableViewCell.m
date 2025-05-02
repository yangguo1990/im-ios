//
//  MLHomeSearchTableViewCell.m
//  miliao
//
//  Created by apple on 2022/10/14.
//

#import "MLHomeSearchTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>

@interface MLHomeSearchTableViewCell()
@property (nonatomic,strong)UIImageView *selectimg;

@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UIButton *dashanbtn ;


@property (nonatomic,strong)UIImageView *onlineimg;

@end


@implementation MLHomeSearchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    
    UIView *bg = [[UIImageView alloc]init];
    bg.layer.cornerRadius = 8;
    bg.layer.masksToBounds = YES;
    bg.layer.borderWidth = 1;
    bg.layer.borderColor = [UIColor colorWithHexString:@"#FDE9F1"].CGColor;
    [self.contentView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.width - 32);
        make.height.mas_equalTo(82);
    }];
    
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"Ellipse 24"];
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bg.mas_left).mas_offset(10);
        make.centerY.mas_equalTo(bg.mas_centerY);
        make.width.height.mas_equalTo(50);
    }];
    
    UIImageView *onlineImg = [[UIImageView alloc]init];
    [self.contentView addSubview:onlineImg];
    self.onlineimg = onlineImg;
    [onlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.img.mas_centerX);
        make.bottom.mas_equalTo(self.img.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(48);
    }];
        
//    UIImageView *selectimg = [[UIImageView alloc]init];
//    selectimg.image = [UIImage imageNamed:@"icon_gouxuan_30_sel"];
//    [img addSubview:selectimg];
//    self.selectimg = selectimg;
//    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(30);
//        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-20);
//        make.right.mas_equalTo(img.mas_right).mas_offset(-20);
//        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-20);
//        make.right.mas_equalTo(img.mas_right).mas_offset(-20);
//    }];

    UILabel *nameLabel = [[UILabel alloc]init];
//    nameLabel.text = @"小可爱";
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_right).mas_offset(16);
        make.top.mas_equalTo(img.mas_top);
    }];
    
    UIButton *dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[dashanbtn setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
    //dashanbtn.backgroundColor = kZhuColor;
    [dashanbtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    dashanbtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [dashanbtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    dashanbtn.layer.cornerRadius = 16;
    [self.contentView addSubview:dashanbtn];
    self.dashanbtn = dashanbtn;
    [dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(73);
        make.right.mas_equalTo(bg.mas_right).mas_offset(-12);
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(img.mas_top);
    }];

//    UIButton *videobtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [videobtn setImage:[UIImage imageNamed:@"icon_shipin_18_nor"] forState:UIControlStateNormal];
//    [self.contentView addSubview:videobtn];
//    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(24);
//        make.right.mas_equalTo(dashanbtn.mas_left).mas_offset(-22);
//        make.centerY.mas_equalTo(dashanbtn.mas_centerY);
//    }];
    
    UILabel *tnameLabel = [[UILabel alloc] init];
    tnameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tnameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
    [self.contentView addSubview:tnameLabel];
    self.tnameLabel = tnameLabel;
    [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.bottom.mas_equalTo(img.mas_bottom);
        make.right.mas_equalTo(bg.mas_right).mas_offset(-150);
    }];

    UIView *lineview = [[UIView alloc]init];
    lineview.hidden = YES;
    lineview.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
    [self.contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(nameLabel.mas_left);
    }];
    
//    UILabel *adrrnameLabel = [[UILabel alloc]init];
//    adrrnameLabel.text = @"10km";
//    adrrnameLabel.textAlignment = NSTextAlignmentCenter;
//    adrrnameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
//    adrrnameLabel.textColor = [UIColor colorFromHexString:@"#FF666666"];
//    [self.contentView addSubview:adrrnameLabel];
//    [adrrnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(agebtn.mas_right).mas_offset(6);
//        make.centerY.mas_equalTo(agebtn.mas_centerY);
//    }];

}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
    NSString *ss = [NSString stringWithFormat:@"%@%@",basess,dict[@"icon"]];
    [_img sd_setImageWithURL:[NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
    
    if ([dict[@"online"] integerValue] == 1) {
        self.onlineimg.image = AppDelegate.shareAppDelegate.busyImage;
    }else if ([dict[@"online"] integerValue] == 2){
        self.onlineimg.image = [UIImage imageNamed:@"Sliceliao52"];
    }else if ([dict[@"online"] integerValue] == 3){
        self.onlineimg.image = kGetImage(@"label_online");
    }else if (dict[@"online"] != nil && [dict[@"online"] integerValue] == 0) {
        self.onlineimg.image = AppDelegate.shareAppDelegate.offlineImage;
    }else {
        self.onlineimg.image = nil;
    }
    
    if (![dict[@"name"] length]) {
        self.nameLabel.text = @"";
    }else{
       self.nameLabel.text = dict[@"name"];
        if (self.nameLabel.text.length > 8) {
            NSString *str1 = [self.nameLabel.text substringToIndex:8];//截取掉下标5之前的字符串
            self.nameLabel.text = [NSString stringWithFormat:@"%@...",str1];
        }else{
            self.nameLabel.text = dict[@"name"];
        }
        
        CGSize size = [self.nameLabel.text sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(100, 22)];
        self.nameLabel.frame = CGRectMake(76, 16, size.width, 22);
    }
    
    
    if (![dict[@"persionSign"] length]) {
        self.tnameLabel.text = @"";
    }else{
        self.tnameLabel.text = dict[@"persionSign"];
    };
    
    
    //关注状态，0-未关注 1-已关注
    if ([dict[@"focus"] integerValue] == 0) {//nv
        [self.dashanbtn setTitle:Localized(@"关注", nil) forState:UIControlStateNormal];
        self.dashanbtn.backgroundColor = kZhuColor;
    }else{
        [self.dashanbtn setTitle:Localized(@"已关注", nil) forState:UIControlStateNormal];
        self.dashanbtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.img.layer.cornerRadius = 8;
    self.img.layer.masksToBounds = YES;
}

- (void)checkAction:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(choseTerm:index:)]) {
        [_delegate choseTerm:button index:self.tag];
    }
}




//-(void)imgClick{
//    if (self.addToCartsBlock) {
//        self.addToCartsBlock();
//    }
//}
//
//- (void)setIsChecked:(BOOL)isChecked{
//    _isChecked = isChecked;
//    //选中
//    if (_isChecked) {
//        self.selectimg.hidden = NO;
//    }
//    else{
//        self.selectimg.hidden = YES;
//    }
//}



@end
