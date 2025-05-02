//
//  ML_MineTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_MineTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface ML_MineTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;

@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *adrrnameLabel;

@property (nonatomic,strong)UIButton *dashanbtn;
@end


@implementation ML_MineTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"icon_wodehuiyuan_24_nor"];
    [self.contentView addSubview:img];
    self.img = img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(26);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(24);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = Localized(@"开通会员", nil);
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    nameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"icon_jinru_14_ccc_nor"];
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-26);
    }];
    
    UILabel *subnameLabel = [[UILabel alloc]init];
//    subnameLabel.text = @"1.0.1";
    subnameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    subnameLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    [self.contentView addSubview:subnameLabel];
    self.subnameLabel = subnameLabel;
    [subnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectimg.mas_left).mas_offset(-12);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}


@end
