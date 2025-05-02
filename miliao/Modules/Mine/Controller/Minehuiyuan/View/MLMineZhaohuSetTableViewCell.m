//
//  MLMineZhaohuSetTableViewCell.m
//  miliao
//
//  Created by apple on 2022/10/12.
//

#import "MLMineZhaohuSetTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface MLMineZhaohuSetTableViewCell()

@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *adrrnameLabel;
@property (nonatomic,strong)UIButton *dashanbtn;
@property (nonatomic,strong)UIImageView *img;
@end


@implementation MLMineZhaohuSetTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
    return self;
}


-(void)setCell{

    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:backView];
    backView.layer.cornerRadius = 16*mWidthScale;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = kGetColor(@"ffdced");
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16*mWidthScale);
        make.right.mas_equalTo(-16*mWidthScale);
        make.top.mas_equalTo(8*mHeightScale);
        make.bottom.mas_equalTo(-8*mHeightScale);
    }];
    
    
    self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.label];
    self.label.textColor = UIColor.blackColor;
    self.label.font = [UIFont boldSystemFontOfSize:14];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28*mWidthScale);
        make.top.mas_equalTo(16*mHeightScale);
        make.height.mas_equalTo(20*mHeightScale);
    }];
    
    
    UIButton *zhidingbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhidingbtn setTitle:Localized(@"置顶", nil) forState:UIControlStateNormal];
    zhidingbtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [zhidingbtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    zhidingbtn.tag = 1000;
    [self.contentView addSubview:zhidingbtn];
    self.zhidingbtn = zhidingbtn;
    [zhidingbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(152*mWidthScale);
        make.centerY.mas_equalTo(self.label.mas_centerY);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
    
    UIButton *bianjibtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bianjibtn setTitle:Localized(@"编辑", nil) forState:UIControlStateNormal];
    [bianjibtn setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    bianjibtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [bianjibtn setImage:[UIImage imageNamed:@"icon_bianji_18_666_nor"] forState:UIControlStateNormal];
    [bianjibtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    bianjibtn.tag = 2000;
    [self.contentView addSubview:bianjibtn];
    [bianjibtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(217*mWidthScale);
        make.centerY.mas_equalTo(self.label.mas_centerY);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
    
    

    
    UIButton *shanchubtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shanchubtn setTitle:Localized(@"删除", nil) forState:UIControlStateNormal];
    [shanchubtn setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    shanchubtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [shanchubtn setImage:[UIImage imageNamed:@"icon_shanchu_18_666_nor"] forState:UIControlStateNormal];
    [shanchubtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    shanchubtn.tag = 3000;
    [self.contentView addSubview:shanchubtn];
    [shanchubtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(self.label.mas_centerY);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    

    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"小哥哥，我是女主播小可爱李真真真真，想和你聊聊天，好不好呀！交个朋友吧";
    nameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    nameLabel.textColor = [UIColor colorFromHexString:@"#000000"];
    nameLabel.numberOfLines = 0;
    nameLabel.backgroundColor = UIColor.whiteColor;
    nameLabel.layer.cornerRadius = 12*mWidthScale;
    nameLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*mWidthScale);
        make.right.mas_equalTo(-20*mWidthScale);
        make.bottom.mas_equalTo(-16*mHeightScale);
        make.top.mas_equalTo(44*mHeightScale);
    }];

   UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"zhaohuzhuangtai"];
    img.hidden = YES;
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(nameLabel.mas_centerY);
        make.width.height.mas_equalTo(68*mWidthScale);
    }];
    

}

- (void)setConStr:(NSString *)conStr
{
    _conStr = conStr;
    
    self.nameLabel.text = conStr;
    CGSize size = [conStr sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(ML_ScreenWidth - 32, 100)];
   
    
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    NSLog(@"dic is %@",dict);
    if ([_dict[@"status"] integerValue] == 0) {
        self.img.hidden = NO;
    }else{
        self.img.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}






- (void)checkAction:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(choseTerm:index:)]) {
        [_delegate choseTerm:button index:self.tag];
    }
} 



@end
