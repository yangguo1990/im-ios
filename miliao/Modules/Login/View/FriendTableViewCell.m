//
//  FriendTableViewCell.m
//  facetest
//
//  Created by apple on 2022/8/15.
//

#import "FriendTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>


@interface FriendTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;
@property (nonatomic,strong)UILabel *labetext;
@property (nonatomic,strong)UILabel *titlelabetext;
@end


@implementation FriendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    UIImageView *img = [[UIImageView alloc]init];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.image = [UIImage imageNamed:@"tuPhot"];
    UITapGestureRecognizer *tapgise = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick)];
    [img addGestureRecognizer:tapgise];
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    
    UILabel *labetext = [[UILabel alloc]init];
    labetext.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    labetext.textAlignment = NSTextAlignmentLeft;
    labetext.numberOfLines = 0;
    labetext.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [img addSubview:labetext];
    self.labetext = labetext;
    [labetext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_left).mas_offset(13);
        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-20);
    }];
    
    UILabel *titlelabetext = [[UILabel alloc]init];
    titlelabetext.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titlelabetext.textAlignment = NSTextAlignmentLeft;
    titlelabetext.numberOfLines = 0;
    titlelabetext.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [img addSubview:titlelabetext];
    self.titlelabetext = titlelabetext;
    [titlelabetext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labetext.mas_left).mas_offset(0);
        make.bottom.mas_equalTo(labetext.mas_top).mas_offset(-3);
    }];
    
    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_gouxuan_30_sel"];
    [img addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.bottom.mas_equalTo(img.mas_bottom).mas_offset(-20);
        make.right.mas_equalTo(img.mas_right).mas_offset(-20);
    }];
}

-(void)imgClick{
    if (self.addToCartsBlock) {
        self.addToCartsBlock();
    }
}

- (void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    //选中
    if (_isChecked) {
        self.selectimg.hidden = NO;
    }
    else{
        self.selectimg.hidden = YES;
    }
}


-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.labetext.text = _dict[@"content"];
    self.titlelabetext.text = _dict[@"title"];
    NSString *basess = [ML_AppUserInfoManager sharedManager].currentLoginUserData.domain;
    NSString *ss = [NSString stringWithFormat:@"%@%@",basess,dict[@"imagePath"]];
    [_img sd_setImageWithURL:[NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"人气推荐占位图"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.layer.cornerRadius = 16;
    self.contentView.frame = CGRectInset(self.bounds, 15, 10);
    self.contentView.clipsToBounds = YES;
}


@end
