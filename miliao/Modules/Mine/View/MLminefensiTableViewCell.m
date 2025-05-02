//
//  MLminefensiTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/16.
//

#import "MLminefensiTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface MLminefensiTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *adrrnameLabel;

@property (nonatomic,strong)UIImageView *onlineimg;
@end


@implementation MLminefensiTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    
    UIImageView *img = [[UIImageView alloc]init];
    img.layer.cornerRadius = 25;
    img.layer.masksToBounds = YES;
    img.image = [UIImage imageNamed:@"Ellipse 24"];
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
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
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"小可爱";
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_right).mas_offset(16);
        make.top.mas_equalTo(img.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-120);
    }];
    
    UIButton *dashanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [dashanbtn setTitle:Localized(@"搭讪", nil) forState:UIControlStateNormal];
//    [dashanbtn setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
    dashanbtn.layer.borderWidth = 0.5;
    dashanbtn.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0].CGColor;
    [dashanbtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    dashanbtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    dashanbtn.layer.cornerRadius = 16;
    dashanbtn.imageEdgeInsets = UIEdgeInsetsMake(0,-2, 0, 2);
    dashanbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [dashanbtn addTarget:self action:@selector(dashanClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:dashanbtn];
    self.dashanbtn = dashanbtn;
    [dashanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(img.mas_top);
        //make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UIButton *videobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videobtn setImage:[UIImage imageNamed:@"icon_shipin_18_nor"] forState:UIControlStateNormal];
    [videobtn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:videobtn];
    [videobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.mas_equalTo(dashanbtn.mas_left).mas_offset(-18);
        make.top.mas_equalTo(20);
    }];
    
    UILabel *tnameLabel = [[UILabel alloc]init];
//    tnameLabel.text = @"有点小内向但是熟了...";
    tnameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tnameLabel.textColor = [UIColor colorFromHexString:@"#666666"];
    [self.contentView addSubview:tnameLabel];
    self.tnameLabel = tnameLabel;
    [tnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-150);
    }];
    
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];
    [self.contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
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
    } else {
        self.onlineimg.image = AppDelegate.shareAppDelegate.offlineImage;
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
        
//        CGSize size = [self.nameLabel.text sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(100, 22)];
//        self.nameLabel.frame = CGRectMake(76, 16, size.width, 22);
//        self.hostimg.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10, self.nameLabel.y, 41.5, self.nameLabel.height);
    }
    
    
    if (![dict[@"persionSign"] length]) {
        self.tnameLabel.text = @"";
    }else{
        self.tnameLabel.text = dict[@"persionSign"];
    };

    if ([_dict[@"call"] integerValue] == 0) {//nv
        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice"] forState:UIControlStateNormal];
        [self.dashanbtn setTitle:Localized(@"搭讪", nil) forState:UIControlStateNormal];
        self.dashanbtn.layer.borderWidth = 0.5;
        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(32);
        }];
    }else{
        [self.dashanbtn setImage:[UIImage imageNamed:@"Slice 15"] forState:UIControlStateNormal];
        [self.dashanbtn setTitle:@"" forState:UIControlStateNormal];
        self.dashanbtn.layer.borderWidth = 0;
        [self.dashanbtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(28);
        }];
    }
    
}

-(void)dashanClick:(UIButton *)btn{

    if (self.clickbuttonBlock) {
        self.clickbuttonBlock(self.tag, btn);
    }

}


-(void)videoClick{
    if (self.clickCellVideoBlock) {
        self.clickCellVideoBlock(self.tag);
    }
}



@end
