//
//  ML_SettingtitleTableViewCell.m
//  miliao
//
//  Created by apple on 2022/9/6.
//

#import "ML_SettingtitleTableViewCell.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SDWebImage/SDWebImage.h>
@interface ML_SettingtitleTableViewCell()

@property (nonatomic,strong)UIImageView *selectimg;

@property (nonatomic,strong)UILabel *tnameLabel;
@property (nonatomic,strong)UIButton *agebtn;
@property (nonatomic,strong)UILabel *adrrnameLabel;

@property (nonatomic,strong)UIButton *dashanbtn;

@end


@implementation ML_SettingtitleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setCell];
    }
    return self;
}


-(void)setCell{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5*mHeightScale);
        make.bottom.mas_equalTo(-5*mHeightScale);
    }];
    backView.layer.cornerRadius = 12*mHeightScale;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = UIColor.whiteColor;
    self.liveV = [[UIView alloc] init];
    self.liveV.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.contentView addSubview:self.liveV];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = Localized(@"开通会员", nil);
    nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorFromHexString:@"#FF333333"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

    UIImageView *selectimg = [[UIImageView alloc]init];
    selectimg.image = [UIImage imageNamed:@"Slice 3"];
    [self.contentView addSubview:selectimg];
    self.selectimg = selectimg;
    [selectimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
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
